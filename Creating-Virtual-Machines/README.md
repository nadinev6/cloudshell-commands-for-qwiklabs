# Creating Virtual Machines
Table of Contents
* [Introduction](#Introduction)
* [Prerequisites](#prerequisites)
  * [Install Cloud SDK](#install-cloud-sdk)
* [Configure Authentication](#configure-authentication)
  * [Qwiklabs User](#qwiklabs-user)
  * [GCP Project ID](#gcp-project-id)

* [Create a virtual machine)](*create-a-virtual-machine)
  * [Create a VM](*create-a-vm)
  * [Explore the VM details](*explore-the-vm-details)
  * [Examine availability policies](*examine-availability-policies)
  * [Explore the VM logs](*exxplore-the-vm-logs)

* [Create a Windows VM](*create-a-windows-vm)
  * [Create a VM](*create-a-vm)
  * [Set the password for the VM](*set-the-password-for-the-vm)

* [Clean up](clean-up)
  * [Delete the VM](*delete-the-vm)


### Introduction

Virtual machines documentation and summary of how to use the services can be found here: https://cloud.google.com/compute. The Qwiklabs covered in this tutorial is called ‘Creating Virtual Machines’. The instructions have been modified so that they can be completed using the cloud shell terminal only or using the google cloud SDK. 

#### Prerequisites

Use the credentials provided by Qwiklabs for the  cloud console or the google cloud SDK. 

#### Install Cloud SDK

For instructions on how to install the google cloud SDK visit google documentation: https://cloud.google.com/sdk/install. 

### Configure authentication

#### Qwiklabs User

Take note of the username provided by Qwiklabs and the user associated with the temporary Qwiklabs email assigned to this project.

From the cloud shell run the following to confirm the credentialed account 

```console
gcloud list
```

 From the cloud SDK run the following to login with the provided credentials:

```console
gcloud auth login
```

#### GCP Project ID

Take note for confirm the GCP project ID assigned to you. From the cloud shell run the following to confirm the credentialed account 

```console
gcloud projects list
```


##	Create a virtual machine

### Create a VM

Run the following command to service accounts:

```console
cloud iam service-accounts list
```

Output:

```console
NAME                                    EMAIL                                                                            
  DISABLED
Compute Engine default service account  440157913927-compute@developer.gserviceaccount.com                               
  False
App Engine default service account      qwiklabs-gcp-01-aa61206acec7@appspot.gserviceaccount.com                         
  False
Qwiklabs User Service Account           qwiklabs-gcp-01-aa61206acec7@qwiklabs-gcp-01-aa61206acec7.iam.gserviceaccount.com
  False
```

```console
Take note of the ‘Compute Engine default service account’ as you will need it throughout this lab.
```

Output:

```console
gcloud beta compute --project=qwiklabs-gcp-01-aa61206acec7 instances create vm-1 --zone=us-central1-a --machine-type=n1-standard-1 --subnet=default --no-address --maintenance-policy=MIGRATE --service-account=440157913927-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=debian-9-stretch-v20200805 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-1 —reservation-affinity=any
```

### Explore the VM details

```console
gcloud compute instances describe [$NAME]
```

When prompted about a zone, type y only if the zone presents matches the zone you set, otherwise type n


### Examine availability policies 

In the description scroll down to see the availability of your VM 

If preemtible is false this mean that the instance can be interrupted and not available at all times. This column should look like this:

```console
 preemptible: false
```


### Explore the VM logs

Confirm the instance is created:

```console
gcloud compute instances list
```



## Create a Windows VM

### Create a VM

```console
gcloud beta compute --project=qwiklabs-gcp-01-8c72720fba45 instances create win-vm --zone=europe-west2-a --machine-type=e2-small --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=118959651289-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=windows-server-2016-dc-core-v20200813 --image-project=windows-cloud --boot-disk-size=100GB --boot-disk-type=pd-ssd --boot-disk-device-name=win-vm --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```

```console
gcloud compute --project=qwiklabs-gcp-01-8c72720fba45 firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
```

gcloud compute --project=qwiklabs-gcp-01-8c72720fba45 firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

```console
### Set the password for the VM
gcloud compute reset-windows-password win-vm
```

Output:

```console
This command creates an account and sets an initial password for the
user [student_01_1ce23464ceb9] if the account does not already exist.
If the account already exists, resetting the password can cause the
LOSS OF ENCRYPTED DATA secured with the current password, including
files and stored passwords.

For more information, see:
https://cloud.google.com/compute/docs/operating-systems/windows#reset
```


When prompted to reset the password type y


When prompted about a zone, type y only if the zone presents matches the zone you set, otherwise type n




## Create a custom VM

### Create a VM

```console
gcloud beta compute —project=[$PROJECT_ID] instances create custom-vm --zone=us-west1-b --machine-type=e2-custom-6-32768 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=118959651289-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=debian-9-stretch-v20200805 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=custom-vm —reservation-affinity=any
```


### Connect via SSH to your custom VM

```console
gcloud beta compute ssh --zone "us-west1-b" "custom-vm" --project “[$PROJECT_ID]”
```


When prompted to continue type y



Output:

```console
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/student_01_1ce23464ceb9/.ssh/google_compute_engine.
Your public key has been saved in /home/student_01_1ce23464ceb9/.ssh/google_compute_engine.pub.
The key fingerprint is:
SHA256:x4a277CEPXgjBOkPOVa11R5vIgn+esgR09kUzidr5nk student_01_1ce23464ceb9@cs-6000-devshell-vm-2a8e25a7-9825-41b5-a495-2a
5382133801
The key's randomart image is:
+---[RSA 2048]----+
|        . ....   |
|     . ..o o+    |
|    o ...o *+o.  |
|   . +  +o= ++o  |
|    * . S++.+o   |
|   . = =.+.+ .   |
|      =.O+  o E  |
|       ++*.  .   |
|        .oo      |
+----[SHA256]-----+
.
.
.
:~$
```

To see information about memory and swap space on your custom VM, type the following:

```console
free
```

To see details about the RAM installed on your VM, run:

```console
sudo dmidecode -t 17
```

To see the number of processors, type
nproc

To see details about the CPUs installed on your VM, run:

```console
lscpu
```

To exit SSH, type:

```console
exit
```

## Clean up

### Delete the VM

Run this command for each of your VMs:

```console
gcloud compute instances delete [NAME]
```
