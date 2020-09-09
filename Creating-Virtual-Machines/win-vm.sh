#!/bin/bash
# Enter Project ID:
echo GCP Project ID:
read projectID
echo projectID=$projectID

# Enter Service Account ID:
echo Service Account:
read sAccount
echo sAccount=$sAccount

# Enter VM name:
echo Name:
read Name
echo Name=$Name

# Enter Region:
echo Region:
read REGION
echo REGION=$REGION

# Enter Zone:
echo Zone:
read ZONE
echo ZONE=$ZONE

# Enter Machine type:
echo Machine:
read Machine 
echo Machine=$Machine

# Enter Boot disk (image):
echo image
read image
echo image=$image

# Enter Image Project:
echo project
read project
echo project=$project

# Enter Boot disk type:
echo disk
read disk 
echo disk=$disk

# Enter Boot disk size:
echo size
read size
echo size=$size


echo gcloud beta compute --project=$ProjectID instances create $Name --zone=$Zone --machine-type=$Machine --subnet=default --no-address --maintenance-policy=MIGRATE --service-account=$sAccount --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=$image --image-project=debian-cloud --boot-disk-size=$size --boot-disk-type=$disk --boot-disk-device-name=vm-1 —reservation-affinity=any
