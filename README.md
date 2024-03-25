# World Tree Automatic Deployment

This guide aims to provide an automatic deployment for servers on AWS, that run the [World Tree](https://github.com/worldcoin/world-tree) application.

Requirements:
- AWS account
  - An `AMI` token stored at `~/.aws/credentials` (Or pass them manually to terraform)
- Terraform
- Ansible
- `jq`

Getting Started:

`make init` to initialize the terraform backend (change aws bucket)
`make servers` to create the servers on AWS (possible to change amount and location)
`make deploy` to deploy the Ansible script that deploys the world-tree app
`make stop` to destroy the servers
