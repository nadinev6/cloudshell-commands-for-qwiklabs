# VPC Networking 

* [Introduction](#Introduction)
* [Prerequisites](#prerequisites)
  * [Install Cloud SDK](#install-cloud-sdk)
* [Configure Authentication](#configure-authentication)
  * [Qwiklabs User](#qwiklabs-user)
  * [GCP Project ID](#gcp-project-id)

## Task 1: Create a Cloud SQL database

## Task 2: Configure a proxy on a virtual machine
  * [SSH to wordpress-europe-proxy](#ssh-to-wordpress-europe-proxy)
  * [Connect to your Cloud SQL instance](#connect-to-your-cloud-sql)

## Task 3: Connect an application to the Cloud SQL instance
  *[Configure the Wordpress-application](#configure-the-wordpress-application)


### Introduction

VPC networking documentation and summary can be found here: https://cloud.google.com/vpc. The Qwiklabs covered in this tutorial is called ‘VPC Networking’. The instructions have been modified so that they can be completed using the cloud shell terminal only or using the google cloud SDK. 

#### Prerequisites

Use the credentials provided by Qwiklabs for the google cloud console or the google cloud SDK. 

#### Install Cloud SDK

For instructions on how to install the google cloud SDK visit google documentation: https://cloud.google.com/sdk/install. 

#### Configure authentication

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

## Task 1: Create a Cloud SQL database

Specify the following, and leave the remaining settings as their defaults:


Instance ID:
   wordpress-db
Root password:
   type a password
Region:
  us-central1
Zone:
  do not specify*
Database Version:
  MySQL 5.7

Note the root password; it will be used in a later step and referred to as [ROOT_PASSWORD].


There are 2 ways to create an SQL database. You can run the following code which uses the default settings:
If none is specified, the default region that will be used isthe us-central1 region

The network name is ‘default’ 

Choose any password, here the password is ‘password123’

```console
gcloud sql instances create wordpress-db --database
—version=MYSQL_5_7 --tier=db-n1-standard-1 --region=us-central1 --root-password=password123
```

```console
gcloud --project=[PROJECT_ID] beta sql instances create [INSTANCE_ID]
       --network=[VPC_NETWORK_NAME]
       --no-assign-ip
```

First enable googleserviceapis to create a database in the terminal:

```console
gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=[RESERVED_RANGE_NAME] \
    --network=[VPC_NETWORK] \
    --project=[PROJECT-ID]
```


Output:

```console
PI [servicenetworking.googleapis.com] not enabled on project
[347532862495]. Would you like to enable and retry (this will take a
few minutes)? (y/N)?  y

Enabling service [servicenetworking.googleapis.com] on project [347532862495]...
Operation "operations/acf.c2330000-00d0-46e6-8b02-b748e6967dd4" finished successfully.
```

Next, create the SQL instance

To configure the details of your SQL instance as per lab instructions, your command should look like this:

```console
gcloud --project=[PROJECT-ID] beta sql instances create wordpress-db3 --network=default --no-assign-ip --database-version=MYSQL_5_7 --tier=db-n1-standard-1 --region=us-central1 --root-password=password123
```

## Task 2: Configure a proxy on a virtual machine

When your application does not reside in the same VPC connected network and region as your Cloud SQL instance, use a proxy to secure its external connection.
In order to configure the proxy, you need the Cloud SQL instance connection name.
The lab comes with 2 virtual machines preconfigured with Wordpress and its dependencies. You can view the startup script and service account access by clicking on a virtual machine name. Notice that we used the principle of least privilege and only allow SQL access for that VM. There's also a network tag and a firewall preconfigured to allow port 80 from any host.


### SSH to wordpress-europe-proxy

```console
gcloud compute ssh 
```

The first time you SSH into a VM instance you will asked to generate SSH keys to create a directory for SSH

When prompted, press enter to leave the passphrase blank
Press enter when asked for the passphrase 

The terminal returns the location of your identification, public key, fingerprint and the key’s random art that may look like this:

```console
Your identification has been saved in /home/student_02_754b2aa64023/.ssh/google_compute_engine.
Your public key has been saved in /home/student_02_754b2aa64023/.ssh/google_compute_engine.pub.
The key fingerprint is:
SHA256:J56N/fq8S+4iMxsMv3oGs7XSFboJs9W/tLt92mKjwCk student_02_754b2aa64023@cs-6000-devshell-vm-1ee8b294-770d-4062-b7ed-a1
27d10d376c
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|                 |
|          .      |
|      . So..     |
|      ==+Oo.     |
|       @E=*.o    |
|      + @+.B.o+..|
|      .=o=.=#Oo=.|
+----[SHA256]-----+
```

Once this has been generated you will not see this again.

Take note of the user name.This is the username assigned to your Qwiklabs project without the Qwiklabs email extension.
i.e. [USER]@qwiklabs.net

```console
gcloud compute ssh [USER]@wordpress-europe-proxy
```

Verify the region presented to you. If it is not the same region as indicated by the instance name, type n.

(example) Output:

```console
Warning: Permanently added 'compute.3408364968863487777' (ECDSA) to the list of known hosts.
Linux wordpress-europe-proxy 4.9.0-13-amd64 #1 SMP Debian 4.9.228-1 (2020-07-05) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Creating directory '/home/student-00-5133785f8dd8'.
student-00-5133785f8dd8@wordpress-europe-proxy:~$
```

### Connect to your Cloud SQL instance

```console
gcloud sql connect [instance-name] --user=root
```

Download the Cloud SQL Proxy and make it executable:

```console
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
```



Output (example):

```console

cloud_sql_proxy                100%[=================================================>]  13.82M  --.-KB/s    in 0.1s

2020-09-05 20:42:04 (109 MB/s) - ‘cloud_sql_proxy’ saved [14492253/14492253]
```

Return to the SSH window and save the connection name in an environment variable, replacing [SQL_CONNECTION_NAME] with the unique name you copied in a previous step.

[GCP-PROJECT-ID]:[REGION]:[SQL-INSTANCE-NAME]

(example):
qwiklabs-gcp-00-2e9c6f72b634:us-central1:wordpress-db3


```console
export SQL_CONNECTION=[SQL_CONNECTION_NAME]
```

No output. There verify the environment is set by running:

```console
echo $SQL_CONNECTION
```

The connection name should be printed out.

(example) Output:

```console
qwiklabs-gcp-02-962c8d3bafc3:us-central1:wordpress-db
```


To activate the proxy connection to your Cloud SQL database and send the process to the background, run the following command:

```console
./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &
```

Output:

```console
2020/09/05 20:48:05 Listening on 127.0.0.1:3306 for qwiklabs-gcp-00-2e9c6f72b634:us-central1:wordpress-db3
2020/09/05 20:48:05 Ready for new connections
```

Press enter

```console
The proxy will listen on 127.0.0.1:3306 (localhost) and proxy that connects securely to your Cloud SQL over a secure tunnel using the machine's external IP address.
```

## Task 3: Connect an application to the Cloud SQL instance


In this task, you will connect a sample application to the Cloud SQL instance.

Exit out of the SSH terminal, run:

```console
exit
```

## Configure the Wordpress application

To find the external IP address of your virtual machine, query its metadata:

```console
curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip && echo
```

The external IP address is returned 

(example) Output:

```console
34.87.55.82
```

Find the wordpress-europe-proxy external IP address, run:

```console
gloud compute instances list
```

(example) Output:

```console
NAME                     ZONE            MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
wordpress-europe-proxy   europe-west1-b  n1-standard-1               10.132.0.2   34.76.74.152  RUNNING
wordpress-us-private-ip  us-central1-a   n1-standard-1               10.128.0.2   34.66.87.70   RUNNING
```

1. Go to the wordpress-europe-proxy external IP in your browser and configure the Wordpress application

￼In this example the external IP is: 34.66.87.70

2. Click **Let's Go**

3. Specify the following, replacing [ROOT_PASSWORD] with the password you configured upon machine creation, and leave the remaining settings as their defaults:


Username:
  root
Password:
 [ROOT-PASSWORD]
Database Host
 127.0.0.1


You are using 127.0.0.1, localhost as the Database IP because the proxy you initiated listens on this address and redirects that traffic to your SQL server securely


4. When a connection has been made, click **Run the installation** to instantiate Wordpress and its database in your Cloud SQL. This might take a few moments to complete. 
5. Populate your demo site's information with random information and click **Install Wordpress**. You won't have to remember or use these details. 
Installing Wordpress might take up to 3 minutes, because it propagates all its data to your SQL Server.

6. When a 'Success!' window appears, remove the text after the IP address in your web browser's address bar and press ‘enter’. You'll be presented with a working Wordpress Blog!


## Task 4: Connect to Cloud SQL via internal IP

If you can host your application in the same region and VPC connected network as your Cloud SQL, you can leverage a more secure and performant configuration using Private IP

By using Private IP, you will increase performance by reducing latency and minimise the attack surface of your Cloud SQL instance because you can communicate with it exclusively over internal IPs

Locate the private IP address of your SQL instance, run:

```console
gcloud sql instances list
```

Note the Private IP address of the Cloud SQL server; it will be referred to as [SQL_PRIVATE_IP].
Copy the external IP address of wordpress-us-private-ip from the cloud instances command you ran earlier, or run the command again:

```console
gloud compute instances list
```

(example) Output:
```console

NAME                     ZONE            MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
wordpress-europe-proxy   europe-west1-b  n1-standard-1               10.132.0.2   34.76.74.152  RUNNING
wordpress-us-private-ip  us-central1-a   n1-standard-1               10.128.0.2   34.66.87.70   RUNNING
```


1. Paste the external IP address it in a browser window, and press ENTER

You should see the same Wordpress welcome page as before

2. Click **Let's Go**

3. Specify the following, and leave the remaining settings as their defaults: 
Property
Value
Username
root
Password
type the [ROOT_PASSWORD] configured when the Cloud SQL instance was created
Database Host
[SQL_PRIVATE_IP]

4. Click **Submit**

5. Notice that this time you are creating a direct connection to a Private IP, instead of configuring a proxy. That connection is private, which means that it doesn't egress to the internet and therefore benefits from better performance and security.

6. Click **Run the installation** An 'Already Installed!' window is displayed, which means that your application is connected to the Cloud SQL server over private IP. 
7. In your web browser's address bar, remove the text after the IP address and press ‘enter’. You'll be presented with a working Wordpress Blog! 

