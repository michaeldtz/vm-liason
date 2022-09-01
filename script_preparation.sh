#!/bin/bash

# Install gcloud
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-400.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-400.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh -q
source ./google-cloud-sdk/path.bash.inc

# Or via Zypper
#sudo zypper -n addrepo https://download.opensuse.org/repositories/Cloud:Tools/15.4/Cloud:Tools.repo
#sudo zypper -n refresh
#sudo zypper -n install google-cloud-sdk

# mount disk
sudo mkdir /mnt/builddisk
sudo mount -o discard,defaults /dev/sdb /mnt/builddisk
sudo chmod a+w /mnt/builddisk

# start preparation work
sudo echo $RANDOM > /mnt/builddisk/prep.txt

# Unmount and detach disk
sudo umount /mnt/builddisk
gcloud compute instances detach-disk vm-1 --disk=disk-1

# Create a custom network with no access 
gcloud compute networks create vm-2-build-network --subnet-mode=custom
gcloud compute networks subnets create  vm-2-build-subnet --network=vm-2-build-network \
--range=10.0.0.0/32 --region=europe-west3

# Start vm-2 
gcloud compute instances create vm-2 \
--zone=europe-west3-a --machine-type=e2-small \
--network-interface=subnet=vm-2-build-subnet,no-address \
--metadata=startup-script="cat /prep.txt > result.txt && echo $RANDOM >> /result.txt" \
--no-service-account \
--disk=auto-delete=no,boot=yes,device-name=vm1,name=disk-1 \
--shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring 

# Wait (in real life we would check the output of the vm-2)
sleep 1m

# Delete vm-2
gcloud compute instances delete vm-2 --keep-disks=all

# Attach and mount disk again
gcloud compute instances attach-disk vm-1 --disk=disk-1
sudo mount -o discard,defaults /dev/sdb /mnt/builddisk
sudo chmod a+w /mnt/builddisk

# Print result
cat /mnt/builddisk/result.txt
