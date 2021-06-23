#!/bin/sh
set -x
for srv in sshd serial-getty@ttyS0; do
	timeout 30 systemctl enable --now "${srv}.service"
done
