#!/usr/bin/env bash
# check-bedrock-model.sh
#
# Probe whether a specific model ID is actually invokable on your AWS Bedrock
# account/region, using the credentials opencode (or any AWS_BEARER_TOKEN_BEDROCK
# consumer) already has configured.
#
# The Bedrock "control plane" list/describe APIs (ListFoundationModels,
# ListInferenceProfiles, GetFoundationModelAvailability, ...) frequently require
# permissions that scoped-down IAM users don't have, even though they *can*
# invoke models. This script sidesteps that by making a minimal, cheap
# Converse API call per model ID and reporting whether it succeeds, is denied
# by IAM/SCP, or needs a different ID format (e.g. cross-region inference
# profile prefix like "us.").
#
# Requires: curl, python3 (for URL-encoding), and the env vars:
#   AWS_BEARER_TOKEN_BEDROCK  - Bedrock API key / bearer token
#   AWS_REGION                - e.g. us-east-1 (or pass as $2 / -r)
#
# Usage:
#   check-bedrock-model.sh <model-id> [region]
#   check-bedrock-model.sh anthropic.claude-sonnet-5
#   check-bedrock-model.sh us.anthropic.claude-sonnet-5 us-east-1
#
#   # Check a whole list of candidate IDs at once:
#   check-bedrock-model.sh --list models.txt
#
# Notes:
#   - Bare model IDs often fail with "on-demand throughput isn't supported" -
#     retry with a region prefix (us./eu./apac./au./jp./global.) which uses
#     the cross-region inference profile instead.
#   - A 403 with "explicit deny in a service control policy" means the model
#     is blocked at the AWS Organization level (e.g. cost governance on
#     premium tiers) - no IAM change on this account can fix that.
#   - Each successful check makes a real (tiny) billed InvokeModel call.

set -euo pipefail

usage() {
  echo "Usage: $0 <model-id> [region]" >&2
  echo "       $0 --list <file-with-one-model-id-per-line> [region]" >&2
  exit 1
}

: "${AWS_BEARER_TOKEN_BEDROCK:?Set AWS_BEARER_TOKEN_BEDROCK first}"

check_one() {
  local model="$1" region="$2"
  local enc out status
  enc=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$model")
  out=$(mktemp)
  status=$(curl -s -o "$out" -w "%{http_code}" \
    -H "Authorization: Bearer ${AWS_BEARER_TOKEN_BEDROCK}" \
    -H "Content-Type: application/json" \
    -X POST "https://bedrock-runtime.${region}.amazonaws.com/model/${enc}/converse" \
    -d '{"messages":[{"role":"user","content":[{"text":"hi"}]}],"inferenceConfig":{"maxTokens":16}}')

  local msg
  msg=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d.get('message') or d.get('Message') or json.dumps(d)[:160])" "$out" 2>/dev/null || echo "(unparseable response)")

  case "$status" in
    200)
      echo "OK      $model"
      ;;
    400)
      if [[ "$msg" == *"on-demand throughput isn't supported"* || "$msg" == *"isn’t supported"* ]]; then
        echo "RETRY   $model  -> needs a region-prefixed inference profile id (e.g. ${region%%-*}.$model)"
      else
        echo "BADREQ  $model  -> $msg"
      fi
      ;;
    403)
      if [[ "$msg" == *"service control policy"* ]]; then
        echo "SCPDENY $model  -> blocked by AWS Organization SCP (not fixable via IAM alone)"
      else
        echo "DENIED  $model  -> $msg"
      fi
      ;;
    404)
      echo "INVALID $model  -> model id not recognized in this region"
      ;;
    *)
      echo "HTTP$status $model  -> $msg"
      ;;
  esac
  rm -f "$out"
}

if [[ "${1:-}" == "--list" ]]; then
  [[ -f "${2:-}" ]] || usage
  region="${3:-${AWS_REGION:-us-east-1}}"
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    check_one "$line" "$region"
  done < "$2"
else
  [[ -n "${1:-}" ]] || usage
  model="$1"
  region="${2:-${AWS_REGION:-us-east-1}}"
  check_one "$model" "$region"
fi
