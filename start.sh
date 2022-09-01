#!/bin/bash

gcloud compute instances create vm-1 \
--zone=europe-west3-a --machine-type=e2-small \
--network-interface=subnet=default,no-address \
--metadata-from-file=startup-script=script_preparation.sh \
--service-account=1035704952186-compute@developer.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_only \
--create-disk=auto-delete=yes,boot=yes,device-name=vm1,image=projects/opensuse-cloud/global/images/opensuse-leap-15-4-v20220722-x86-64,mode=rw,size=10,type=projects/midietz-one/zones/europe-west3-a/diskTypes/pd-balanced \
--create-disk=device-name=disk-1,boot=no,mode=rw,name=disk-1,image=projects/opensuse-cloud/global/images/opensuse-leap-15-4-v20220722-x86-64,size=100,type=projects/midietz-one/zones/europe-west3-a/diskTypes/pd-balanced \
--shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring 
