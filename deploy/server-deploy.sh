#!/usr/bin/env bash
set -euo pipefail

repo_url="https://github.com/StarHosea/saoma-weixin.git"
state_dir="/opt/1panel/deploy/saoma-weixin"
target_dir="/opt/1panel/www/sites/wx.shuangdeng.space"
state_file="$state_dir/deployed-sha"

install -d "$state_dir" "$target_dir"

exec 9>"$state_dir/deploy.lock"
flock -n 9 || exit 0

remote_sha="$(git ls-remote "$repo_url" refs/heads/main | awk '{print $1}')"
if [[ -z "$remote_sha" || "$(cat "$state_file" 2>/dev/null || true)" == "$remote_sha" ]]; then
  exit 0
fi

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

git clone --quiet --depth 1 --branch main "$repo_url" "$work_dir/repo"
rsync -a --delete \
  --exclude='.git/' \
  --exclude='.github/' \
  --exclude='deploy/' \
  "$work_dir/repo/" "$target_dir/"

printf '%s\n' "$remote_sha" > "$state_file"

