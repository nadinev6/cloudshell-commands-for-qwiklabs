#!/bin/bash
# Enter Project ID:
echo GCP Project ID:
read projectID
echo projectID=$projectID

# Enter Service Account ID:
echo Service Account:
read sAccount
echo sAccount=$sAccount

# Enter a name for your VM:
echo Name:
read Name
echo Name=$Name

# Enter Region:
echo Region:
read Region
echo Region=$Region

# Enter Zone:
echo Zone:
read Zone
echo Zone=$Zone

# Enter Zone:
echo Cores:
read core
echo core=$core

# Enter Zone:
echo Memory:
read mem
echo mem=$mem

echo gcloud beta compute --project=$projectID instances create $Name --zone=$Zone --machine-type=e2-custom-$core-$mem768 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=$sAccount --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=debian-9-stretch-v20200805 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=$Name —reservation-affinity=any
