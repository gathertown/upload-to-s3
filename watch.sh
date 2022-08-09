#!/bin/sh
set -e

# handle SIGTERM gracefully
_t() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$child" 2>/dev/null
}

trap _t SIGTERM

# set node variable
n_name="${NODE_NAME:-unknown}"
echo "Monitoring ${LOCAL_PATH} on ${n_name}"

# launch inotifywait in the background
inotifywait -m /"${LOCAL_PATH}" -e close_write | while read path action file
do
  aws s3 cp "${path}/${file}" "s3://${S3_BUCKET}/${n_name}.${file}"
  echo "The file '$path' has been uploaded to 's3://${S3_BUCKET}/${n_name}.${file}'"
done &

# propagate bash signal to child
child=$!
wait "$child"
