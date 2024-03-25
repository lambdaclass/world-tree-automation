# World Tree Automatic Deployment

This guide aims to provide an automatic deployment for servers on AWS, that run the [World Tree](https://github.com/worldcoin/world-tree) application.

## Requirements:
- AWS account
  - Your `AMI` token stored at `~/.aws/credentials` (Or pass them manually to terraform)
- Terraform
- Ansible
- `jq` 
- `make`

---

## Getting Started:

### Steps before running
- Change the AWS bucket where `terraform` saves it's state.
    - File located at `terraform/providers.tf`
    - Optionally, you can change the AWS region, and the ammount of servers created.
     
### Steps to start deployment

- `make init`: Initializes the terraform backend.

- `make servers`: Creates `N` ammount servers on AWS. Each server will appear on your dashboard with the names `worldcoin-N`

- `make deploy`: Deploys the `ansible` script that deploys the world-tree app. I case you want to change some parameters, you can modify the `systemd` file template, located on `ansible/playbooks/templates/world-tree.service.j2`

- `make stop`: Destroy all the servers.
