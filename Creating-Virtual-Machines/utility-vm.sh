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
read Region
echo Region=$Region



echo gcloud beta compute --project=$projectID instances create $Name --zone=$Zone --machine-type=$Machine --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=$sAccount --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=windows-server-2016-dc-core-v20200813 --image-project=windows-cloud --boot-disk-size=100GB --boot-disk-type=pd-ssd --boot-disk-device-name=$Name --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any