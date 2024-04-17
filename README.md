# World Tree Automatic Deployment

This guide aims to provide an automatic deployment for servers on AWS, that run the [World Tree](https://github.com/worldcoin/world-tree) application.

## Requirements
- AWS
    - Your `AWS` credentials stored at `~/.aws/credentials` (Or pass them manually to terraform)
    - An S3 bucket to store `terraform` state.
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- `jq`
- `make`

## Getting Started

### Steps before running
- Change the AWS config.
    - Optionally, you can change the AWS region, and the amount of servers created.
        - File located at [terraform/providers.tf](https://github.com/lambdaclass/world-tree-automation/blob/main/terraform/providers.tf)

- Change the SSH Public Keys
    - Change the SSH public keys, that allow you to log into the server
        - File located at [terraform/user_data/worldcoin.yml](https://github.com/lambdaclass/world-tree-automation/blob/main/terraform/user_data/worldcoin.yml)

- Change the Ethereum Mainnet HTTPS URL Endpoint
    - Change the Endpoint passed as an argument to binray inside the systemd service
        - File located at [ansible/playbooks/templates/world-tree.service.j2](https://github.com/lambdaclass/world-tree-automation/blob/main/ansible/playbooks/templates/world-tree.service.j2)

- AWS Instance Type
    - If desired, change the `instance_type` default value with your desired instance type. 
        - Edit the [terraform/variables.tf](https://github.com/lambdaclass/world-tree-automation/blob/main/terraform/variables.tf) file.

- AWS region
    - You can also change the AWS Region where the EC2 servers are going to be created.
        - Edit the [variables.tf](https://github.com/lambdaclass/world-tree-automation/blob/main/terraform/variables.tf) file.

- AWS S3 Bucket
    - You can change the AWS S3 region location, as well as the directory inside the bucket.
        - Edit the backend section inside the [providers.tf](https://github.com/lambdaclass/world-tree-automation/blob/main/terraform/providers.tf) file.

### Steps to start deployment

- `make start SERVERS=N`
    - Initializes Terraform backend. Then, creates `N` (Integer) amount servers on AWS. Each server will appear on your dashboard with the names `worldcoin-N`. 
      - If `N` is not defines, it will default to `3`.

- `make stop`
    - Destroy all the running servers.

### Additional Notes
#### The servers contain two different users.

- `dev` is the user where the world-tree app is going to be deployed. 
  - The app will be executed by a `systemd` service.

- `admin` is the user that, unlike `dev`, is added to the `sudo` group. 
  - This user is meant to run commands that require escalated privileges.

#### World Tree service
- The `world-tree.service` is located at `.config/systemd/user/world-tree.service`
  - Any changes on how the binary is executed must be changed here.
- Port `8080` is firewall-enabled and listening for any request.
