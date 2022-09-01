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

# create disk and attach
gcloud compute disks create disk-1 \
   --size 10GB --zone europe-west3-a \
   --image projects/opensuse-cloud/global/images/opensuse-leap-15-4-v20220722-x86-64 \
   --type projects/midietz-one/zones/europe-west3-a/diskTypes/pd-balanced

gcloud compute instances attach-disk vm-1 \
  --disk disk-1 --zone europe-west3-a

# mount disk
sudo mkdir /mnt/builddisk
sudo mount -t xfs -o nouuid /dev/sdb3 /mnt/builddisk
sudo chmod a+w /mnt/builddisk

# start preparation work
sudo echo $RANDOM > /mnt/builddisk/prep.txt

# Unmount and detach disk
sudo umount /mnt/builddisk
gcloud compute instances detach-disk vm-1 \
--disk=disk-1  --zone europe-west3-a

# Create a custom network with no access 
gcloud compute networks create vm-2-build-network --subnet-mode=custom
gcloud compute networks subnets create  vm-2-build-subnet --network=vm-2-build-network \
--range=10.0.0.0/29 --region=europe-west3

# Start vm-2 
gcloud compute instances create vm-2 \
--zone=europe-west3-a --machine-type=n2d-standard-4 \
--network-interface=subnet=vm-2-build-subnet,no-address \
--metadata=startup-script="cat /prep.txt > result.txt && echo $RANDOM >> /result.txt" \
--no-service-account --no-scopes \
--create-disk=auto-delete=yes,boot=yes,device-name=sda,image=projects/opensuse-cloud/global/images/opensuse-leap-15-4-v20220722-x86-64,mode=rw,size=10,type=projects/midietz-one/zones/europe-west3-a/diskTypes/pd-balanced \
--disk=auto-delete=no,boot=no,device-name=disk-1,name=disk-1 \
--shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring 

# Wait (in real life we would check the output of the vm-2)
sleep 1m

# Delete vm-2 and the network
gcloud compute instances delete vm-2 --keep-disks=data --zone=europe-west3-a -q
gcloud compute networks subnets delete  vm-2-build-subnet --region=europe-west3 -q
gcloud compute networks delete vm-2-build-network -q

# Attach and mount disk again
gcloud compute instances attach-disk vm-1 \
--disk=disk-1  --zone europe-west3-a
sudo mount -t xfs -o nouuid /dev/sdb3 /mnt/builddisk

# Print result
cat /mnt/builddisk/result.txt







