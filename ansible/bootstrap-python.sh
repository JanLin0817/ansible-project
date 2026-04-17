#!/usr/bin/env bash
# Bootstrap CentOS 8 VMs:
#   1. Replace EOL/dead mirrors with vault.centos.org
#   2. Install python3.9 so modern ansible-core can run modules
set -euo pipefail

# Move the original (broken) repo files out of the way
sudo mkdir -p /etc/yum.repos.d/backup
sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/ 2>/dev/null || true

# Drop in a minimal vault-backed repo set
sudo tee /etc/yum.repos.d/CentOS-vault.repo >/dev/null <<'EOF'
[baseos]
name=CentOS-8 BaseOS (vault)
baseurl=http://vault.centos.org/centos/8.5.2111/BaseOS/x86_64/os/
gpgcheck=0
enabled=1

[appstream]
name=CentOS-8 AppStream (vault)
baseurl=http://vault.centos.org/centos/8.5.2111/AppStream/x86_64/os/
gpgcheck=0
enabled=1

[extras]
name=CentOS-8 extras (vault)
baseurl=http://vault.centos.org/centos/8.5.2111/extras/x86_64/os/
gpgcheck=0
enabled=1
EOF

sudo dnf clean all
sudo dnf install -y python39
