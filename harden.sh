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

echo "Building hardened_malloc..."
apt-get install -y make gcc g++
rm -r hardened_malloc-12
wget https://github.com/GrapheneOS/hardened_malloc/archive/refs/tags/12.tar.gz
tar -xvf 12.tar.gz
cd hardened_malloc-12
make VARIANT=light

echo "Installing hardened_malloc"
cp out-light/libhardened_malloc-light.so /usr/local/lib/libhardened_malloc-light.so
cd ..
cp -f ./config/ld.so.preload /etc/

echo "Complete. Reboot your system for changes to take effect."
