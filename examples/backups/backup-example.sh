# NOTE: Backup process should only have read rights to the original data.

# Backup aws
# -------------

# Export all production databases to a bucket
./aws/01-export-databases.sh aws-zone1 aws-zone1-db-exports prod
./aws/01-export-databases.sh aws-zone2 aws-zone2-db-exports prod

# List and backup all buckets
. ./aws/02-list-all-buckets.sh
for bucket in ${buckets}
do
  ./aws/03-copy-bucket.sh ${bucket}
  ./all/50-compress.sh ${bucket}
  # ./all/51-optional-encrypt.sh ${bucket}
  # ./all/52-optional-move-remote.sh ${bucket} gcloud-backup-bucket
  # ./all/53-optional-clean-remote.sh ${bucket} gcloud-backup-bucket
  ./all/54-clean-local.sh ${bucket}
done

# Clean database exports from buckets
./aws/90-clean-exports.sh aws-zone1-db-exports
./aws/90-clean-exports.sh aws-zone2-db-exports

# Backup gcloud
# -------------

# Export all production databases to a bucket
./gcloud/01-export-databases.sh gcloud-zone1 gcloud-zone1-db-exports prod
./gcloud/01-export-databases.sh gcloud-zone2 gcloud-zone2-db-exports prod

# List and backup all buckets
. ./gcloud/02-list-all-buckets.sh
for bucket in ${buckets}
do
  ./gcloud/03-copy-bucket.sh ${bucket}
  ./all/50-compress.sh ${bucket}
  # ./all/51-optional-encrypt.sh ${bucket}
  # ./all/52-optional-move-remote.sh ${bucket} aws-backup-bucket
  # ./all/53-optional-clean-remote.sh ${bucket} aws-backup-bucket
  ./all/54-clean-local.sh ${bucket}
done

# Clean database exports from buckets
./gcloud/90-clean-exports.sh gcloud-zone1-db-exports
./gcloud/90-clean-exports.sh gcloud-zone2-db-exports
