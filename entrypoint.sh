#! /bin/bash -l
set -uo pipefail

GITHUB_TOKEN=$1
PYRE_ARGS=$2
PIP_ARGS=$3

post_pr_comment() {
  local msg=$1
  payload=$(echo '{}' | jq --arg body "${msg}" '.body = $body')
  request_url=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
  curl -s -S \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "${payload}" \
    "${request_url}" > /dev/null
}

install_dependencies() {
 local pip_args=$1
 if [ -z $1 ]
 then
    return 0
 else
    pip install $1
 fi
}

main() {
  install_dependencies "${PIP_ARGS}"
  pyre $2 check > /tmp/PyreOutput.txt
  if ! [ -s /tmp/PyreOutput.txt ]
  then
    exit 0
  fi 
  comment_msg="##pyre ${PYRE_ARGS} check
  "
  for FILE in $(cat /tmp/PyreOutput.txt |
    tr '\/' '\n' |
    grep '\.py' |
    awk -F ':' ' { print $1 } ' |
    sort |
    uniq)
  do
    comment_msg="${comment_msg}

 <details><summary><code>${FILE}</code></summary>

\`\`\`
$(cat /tmp/PyreOutput.txt | grep ${FILE})
\`\`\`

</details>
"
  done
  post_pr_comment "${comment_msg}"
  exit 1
}

main "$@"