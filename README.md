# upload-to-s3

## Description
[Daemonset](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) that monitors `hostPath` and uploads files to an s3 bucket.

## Overview

`Upload-to-s3` is monitoring a kubernetes volume of type [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) using the [inotify-tools](https://github.com/inotify-tools/inotify-tools).

Applications running on kubernetes can use `hostPath` modifying `/proc/sys/kernel/core_pattern` file to populate the directory with coredumps, see [core manpage](https://man7.org/linux/man-pages/man5/core.5.html) for details.

For consistency reasons we're using non-privileged user called `gather` with user id `1000`.
The requirement for the `LOCAL_PATH` directory is to have at least `r` permissions for user with ID `1000`.

AWS credentials (region, id, bucket_name and key) are passed as environment variables.

The daemonset is using a hardcoded `nodeSelector` to limit the daemonset deployment to a specific nodepool.

Implementation based on [Handling Core-Dumps in Kubernetes Clusters in GCP](https://faun.pub/handling-core-dumps-in-kubernetes-clusters-in-gcp-b1b2a54c25dc).

## Deployment Workflow

* `develop` branch deploys in development cluster
* `staging` branch deploys in staging clusters
* `production` branch deploys in production clusters

## Development

Develop against the `develop` branch. Open PR to develop, then promote changes to `staging` and `production`.

## License

See [LICENSE](LICENSE) file.
