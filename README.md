
There are several options to configure the provider for AWS. To make it easier to configure, in this project, I set up the Terraform provider using static credentials.


locking enabled para evitar

S3 backend tiene el tfstate con versioning enabled, por si someone overwrite data accidentally or data get corrupte, so you can reverse to any prevoups state if you want to.

