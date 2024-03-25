#!/usr/bin/env bash

set -ex

output=$(terraform -chdir=terraform/ output -json)

if [ "${output}" == "{}" ]; then
	echo "terraform reports that there are no current servers running."
	exit 1
fi

cd ansible/

cp inventory.yaml inventory.yaml.bak

cat <<EOF >inventory.yaml
webservers:
  hosts:
EOF

echo $output | jq -r '.web_servers.value | to_entries[] | "\(.key):\(.value)"' | while IFS=: read -r host ip; do
	cat <<EOF >>inventory.yaml
    $host:
      ansible_host: $ip
      ansible_user: dev
      ansible_python_interpreter: /usr/bin/python3
EOF
done
