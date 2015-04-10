#!/usr/bin/env bash
set -eo pipefail; [[ -n "$PLUSHU_TRACE" ]] && set -x

if [[ -n "$PLUSHU_APP_NAME" ]]; then
  app=$PLUSHU_APP_NAME
elif [[ -n "$2" ]]; then
  app=$2
  shift
else
  echo "Missing app name" >&2
  exit 1
fi

app_dir=$PLUSHU_APPS_DIR/$app

# Check if app exists
if [[ ! -d "$app_dir" ]]; then
  echo "App not found: $app" >&2
  exit 1
fi

cidfile=$app_dir/proc/web.cid

if [[ -f "$cidfile" ]]; then
  if [[ "$2" == "-t" ]]; then
    docker logs --follow "$(<"$cidfile")"
  else
    docker logs "$(<"$cidfile")" | tail -n 100
  fi
else
  echo "App not running: $app"
fi
