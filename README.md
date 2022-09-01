# vm-liason
Two VMs - One Disk and a Happy End


## Preparation
- Cloud NAT is required because the VMs are started without external IP address. Please create it
- Make sure to use a service account that has the permissions to create disks and VMs. 
    - Compute Engine Admin
    - Compute Instance Admin (v1)
    - Service Account User
    - Logs Writer
- ==> For productive setups the list of these roles should be replaced by a custom role with least privilege
    


