#!/bin/bash

# Enter Project ID:
echo GCP Project ID:
read projectID
echo projectID=$projectID

# Enter Service Account ID:
echo Service Account:
read sAccount
echo sAccount=$sAccount

# Enter firewall rule type:
echo Firewall rule name:
read frName
echo frname=$frName

# Enter Zone:
echo Target tag:
read targetTag
echo targetTag=$targetTag


gcloud compute --project=$projectID firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=$targetTag