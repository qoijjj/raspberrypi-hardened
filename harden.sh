#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Setting numerous hardened sysctl values..."
cp ./config/hardening.conf /etc/sysctl.d/

echo "Disabling coredumps in limits.conf..."
cp ./config/limits.conf /etc/security/limits.conf

echo "Blacklisting unused kernel modules..."
cp ./config/blacklist.conf /etc/modprobe.d/

echo "Setting more restrictive file permissions..."
chmod 600 /etc/at.deny
chmod 600 /etc/cron.deny
chmod 600 /etc/crontab
chmod 700 /etc/cron.d
chmod 700 /etc/cron.daily/
chmod 700 /etc/cron.daily
chmod 700 /etc/cron.hourly
chmod 700 /etc/cron.weekly
chmod 700 /etc/cron.monthly

echo "Installing dnf-automatic and chkrootkit..."
dnf install -y dnf-automatic chkrootkit

echo "Setting hardening kernel parameters..."
grubby --update-kernel=ALL --args="init_on_alloc=1 init_on_free=1 slab_nomerge page_alloc.shuffle=1 randomize_kstack_offset=on vsyscall=none debugfs=off lockdown=confidentiality random.trust_cpu=off random.trust_bootloader=off nvme_core.default_ps_max_latency_us=0 mitigations=auto,nosmt"

echo "Building hardened_malloc..."
dnf install rpm-build rpmdevtools rpmlint gcc make g++
rm -r fedora-extras
git clone https://github.com/rusty-snake/fedora-extras.git
cd fedora-extras
./rpmbuild.sh hardened_malloc

echo "Installing hardened_malloc"
dnf install hardened_malloc*.rpm
cp -f ./config/ld.so.preload /etc/

echo "Complete. Reboot your system for changes to take effect."
