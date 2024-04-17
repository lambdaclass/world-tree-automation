ifndef SERVERS
	override SERVERS = 3
endif

init:
	terraform -chdir=terraform/ init

start: init
	terraform -chdir=terraform/ apply -auto-approve -var="servers=${SERVERS}"
	./update-ansible-ip.sh
	terraform -chdir=terraform/ output -json | jq -r '.web_servers.value | to_entries[] | "\(.value)"' | xargs -I {} ssh-keyscan {} >> ~/.ssh/known_hosts
	cd ansible && ansible-playbook -i inventory.yaml playbooks/world-tree.yml

stop:
	terraform -chdir=terraform/ destroy -auto-approve -var="servers=${SERVERS}"
