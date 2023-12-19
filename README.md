# raspberrypi-hardened

## Notice

- This script only supports RaspberryPiOS 12 until further notice.
- This script is in *alpha*, **use at your own risk**.

## What

This is a script that hardens the default fedora installation significantly using the following modifications:

- Setting numerous hardened sysctl values (Inspired by but not the same as Kicksecure's)
- Disabling coredumps in limits.conf
- Blacklisting numerous unused kernel modules to reduce attack surface
- Setting more restrictive file permissions (Based on recommendations from [lynis](https://cisofy.com/lynis/))
- Installing and configuring unattended-upgrades and chkrootkit
- Sets numerous hardening kernel parameters (Inspired by [Madaidan's Hardening Guide](https://madaidans-insecurities.github.io/guides/linux-hardening.html))


## How

```
# ./harden.sh
```
