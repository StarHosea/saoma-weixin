#!/usr/bin/env bash
set -euo pipefail

source_dir="/etc/letsencrypt/live/wx.shuangdeng.space"
target_dir="/opt/1panel/apps/openresty/openresty/conf/ssl/wx.shuangdeng.space"

install -d -m 700 "$target_dir"
install -m 644 "$source_dir/fullchain.pem" "$target_dir/fullchain.pem"
install -m 600 "$source_dir/privkey.pem" "$target_dir/privkey.pem"

docker exec 1Panel-openresty-NhRG openresty -t
docker exec 1Panel-openresty-NhRG openresty -s reload
