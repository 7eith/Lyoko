#!/bin/bash
set -e

VM_IP=$1
WAIT_TIME=${2:-45}
PLAYBOOK=${3:-lyoko.yml}

echo "=== Waiting VM to BOOT (${WAIT_TIME}s) ==="
sleep ${WAIT_TIME}

echo "=== Testing SSH connection ==="
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 seith@${VM_IP} "echo 'VM ready'" 2>/dev/null; do
  echo "VM not ready, retry in 5s..."
  sleep 5
done

echo "=== Executing Ansible playbook ==="
cd "$(dirname "$0")/../../ansible"
ansible-playbook -i inventory/hosts.yml ${PLAYBOOK}

echo "=== Provisioning done ==="