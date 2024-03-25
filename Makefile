init:
	terraform -chdir=terraform/ init

servers:
	terraform -chdir=terraform/ apply -auto-approve
	./update-ansible-ip.sh

deploy:
	terraform -chdir=terraform/ output -json | jq -r '.web_servers.value | to_entries[] | "\(.value)"' | xargs -I {} ssh-keyscan {} >> ~/.ssh/known_hosts
	cd ansible && ansible-playbook -i inventory.yaml playbooks/world-tree.yml

stop:
	terraform -chdir=terraform/ destroy -auto-approve

all: servers deploy
