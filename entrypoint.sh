#! /bin/bash -l
set -uo pipefail

GITHUB_TOKEN=$1
PYRE_ARGS=$2

post_pr_comment() {
  local msg=$1
  payload=$(echo '{}' | jq --arg body "${msg}" '.body = $body')
  request_url=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
  curl -s -S \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "${payload}" \
    "${request_url}"
}

main() {
  pyre --source-directory . check > /tmp/PyreOutput.txt
  comment_title="Pyre Output"
  comment_body=""

  comment_body="${comment_body}

<details><summary><code>Pyre Command (> pyre ${PYRE_ARGS} . check)</code></summary>
\'\'\'\n
$(cat /tmp/PyreOutput.txt)
\`\`\`

</details>
"
  comment_msg="## ${comment_title}
${comment_body}
"
  post_pr_comment "${comment_msg}"
}

main "$@"
