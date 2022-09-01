# vm-liason
Two VMs - One Disk and a Happy End


## Preparation
- Cloud NAT is required because the VMs are started without external IP address. Please create it
- Make sure to use a service account that has the permissions to create disks and VMs. 
 - Option A: For non production envs you can use Compute Engine Admin role
 - Option B: For production envs please create a customer role with the exact permissions

 

