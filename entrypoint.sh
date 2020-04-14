#! /bin/bash -l
set -uo pipefail

PYRE_ARGS=$1
GITHUB_TOKEN=$2

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

main() {
  pyre --source-directory . check > /tmp/PyreOutput.txt
  comment_title="Pyre Output"
  comment_body=""

  comment_body="${comment_body}

<details><summary><code>Pyre Run Output (${PYRE_ARGS})</code></summary>
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
