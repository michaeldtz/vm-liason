# VM Liason - Two VMs - One Disk and a Happy End

## Overview
This example executes a opinionated build process in two steps on two VMs.
VM-1 prepares a disk. That disk is then re-mounted to the VM-2 which executes the build. Finally VM-1 mounts the disk again and reads the results.

## Preparation
- Make sure you have gcloud CLI installed to run start.sh
- Cloud NAT is required because the VMs are started without external IP address. Please create it
- Make sure to use a service account that has the permissions to create disks and VMs. 
    - Compute Engine Admin
    - Compute Instance Admin (v1)
    - Service Account User
    - Logs Writer
- ==> For productive setups the list of these roles should be replaced by a custom role with least privilege


## Run
./start.sh
    


