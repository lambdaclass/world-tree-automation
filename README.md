# World Tree Automatic Deployment

This guide aims to provide an automatic deployment for servers on AWS, that run the [World Tree](https://github.com/worldcoin/world-tree) application.

## Requirements
- AWS account
    - Your `AMI` token stored at `~/.aws/credentials` (Or pass them manually to terraform)
- Terraform
- Ansible
- `jq` 
- `make`

---

## Getting Started

### Things to change before running
- SSH KEY
    - Change the `ssh_autorized_keys` resource on the `webservers.yml` file. Add your own key in order to be able to log into the server.
- AWS Instance Type
    - If desired, change the `instance_type` default value with your desired instance type. Edit the `variables.tf` file.
-  AWS region
    - You can also change the AWS Region where the EC2 servers are going to be created.

### Steps before running
- Change the AWS bucket where `terraform` saves it's state.
    - File located at `terraform/providers.tf`
    - Optionally, you can change the AWS region, and the amount of servers created.

### Steps to start deployment

- `make init`
    - Initializes the terraform backend.

- `make start SERVERS=N`
    - Creates `N` (Integer) amount servers on AWS. Each server will appear on your dashboard with the names `worldcoin-N`

- `make deploy`
    - Deploys the `ansible` script that deploys the world-tree app. I case you want to change some parameters, you can modify the `systemd` file template, located on `ansible/playbooks/templates/world-tree.service.j2`

- `make stop SERVERS=N`
    - Destroy all the running servers.

### Additional Notes
The servers contain two different users.

`dev` is the user where the world-tree app is going to be deployed. The app will be executed by a `systemd` service.
`admin` is a user that, unlike `dev`, is added to the `sudo` group. This user is meant to run commands that require escalated privileges.
