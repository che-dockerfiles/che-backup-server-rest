# che-backup-server-rest

This repository contains internal REST backup server image dockerfiles for Eclipse Che.

The image uses restic REST server that supposed to store Che backups.

It is designed to be deployed by Che Operator by setting `autoconfigureRestBackupServer` to `true` in an instance of `CheClusterBackup` and be accecible only from within the cluster.
