#!/usr/bin/env bash
# WARN: it turns out that the different OS images end up with this disk on different
#       devices, sometimes /dev/sdc, sometimes /dev/sda.  We will continue with
#       manual configuration of this.
# sudo parted /dev/sdc mklabel gpt
# sudo parted -a opt /dev/sdc mkpart primary ext4 0% 100%
# sudo mkfs.ext4 -L data /dev/sdc1
sudo mkdir /data
# echo "LABEL=data /data ext4 defaults 0 2" | sudo tee -a /etc/fstab
# sudo mount -a

