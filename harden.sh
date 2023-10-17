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

echo "Installing unattended-upgrades and chkrootkit..."
apt-get install -y unattended-upgrades chkrootkit

echo "Installing hardening-runtime"
apt-get install -y hardening-runtime

echo "Configuring unattended-upgrades..."
cp ./config/50-unattendedupgrades.conf /etc/apt/apt.conf.d/

echo "Setting hardening kernel parameters..."
echo " init_on_alloc=1 init_on_free=1 slab_nomerge page_alloc.shuffle=1 randomize_kstack_offset=on vsyscall=none debugfs=off lockdown=confidentiality random.trust_cpu=off random.trust_bootloader=off nvme_core.default_ps_max_latency_us=0 mitigations=auto,nosmt" >> /boot/cmdline.txt

echo "Complete. Reboot your system for changes to take effect."
