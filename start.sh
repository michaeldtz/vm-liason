#!/bin/bash

gcloud compute instances create vm-1 \
--zone=europe-west3-a --machine-type=n2d-standard-4 \
--network-interface=subnet=default,no-address \
--metadata-from-file=startup-script=vm1_startup_script.sh \
--service-account=1035704952186-compute@developer.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_only \
--create-disk=auto-delete=yes,boot=yes,device-name=sda,image=projects/opensuse-cloud/global/images/opensuse-leap-15-4-v20220722-x86-64,mode=rw,size=10,type=projects/midietz-one/zones/europe-west3-a/diskTypes/pd-balanced \
--shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring 

gcloud compute instances get-serial-port-output vm-1 --zone=europe-west3-a | grep startup-script
gcloud compute instances get-serial-port-output vm-2 --zone=europe-west3-a | grep startup-script