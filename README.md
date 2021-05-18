# che-backup-server-rest

This repository contains internal REST backup server image dockerfiles for Eclipse Che.

It is designed to be deployed by Che Operator by setting `autoconfigureRestBackupServer` to `true` in an instance of `CheClusterBackup` and be accecible only from within the cluster.
