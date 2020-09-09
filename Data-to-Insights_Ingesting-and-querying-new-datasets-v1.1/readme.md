# Data to Insights: Ingesting and Querying New Datasets v1.1

## Table of Contents
* [Introduction](#Introduction)
* [Prerequisites](#prerequisites)
  * [Install Cloud SDK](#install-cloud-sdk)
* [Configure Authentication](#configure-authentication)
  * [Qwiklabs User](#qwiklabs-user)
  * [GCP Project ID](#gcp-project-id)
* [Clone this git-repository](#clone-this-git-repository)

## Ingesting Data from Google Cloud Storage


* [Upload a dataset to Google Cloud Storage](#upload-a-dataset-to-google-cloud)
  * [Clone this git repository](#clone-this-git-repository)
  * [Create a storage bucket](*create-a-storage-bucket)
 

## Ingesting a CSV into a Google BigQuery Table 

* [Open BigQuery](#open-bigquery)
* [Create a dataset](*create-a-dataset)
* [Upload the dataset](*upload-the-dataset)
* [Create table](*create-table)

## Run queries

## Clean up

  * [Delete your bucket](#delete-your-bucket)
 


## Introduction

The task allows you to ingest data into BigQuery from different sources, including this repository.  Documentation and summary about Google BigQuery can be found here: https://cloud.google.com/bigquery/docs. The Qwiklabs covered in this tutorial is called ‘Data to Insights: Ingesting and Querying New Dataset v1.1’. The instructions have been modified so that they can be completed using the cloud shell terminal only or using the google cloud SDK and BigQuery (bq) component. The files needed to complete the lab are also included in this repository. You will need to clone this respository in order to copy the needed files without using the web console. 

## Prerequisites

Use the credentials provided by Qwiklabs for the google cloud console or the google cloud SDK. 

### Install Cloud SDK

For instructions on how to install the google cloud SDK visit google documentation: https://cloud.google.com/sdk/install. 

## Configure authentication

### Qwiklabs User

Take note of the username provided by Qwiklabs and the user associated with the temporary Qwiklabs email assigned to this project.

From the cloud shell run the following to confirm the credentialed account:

```console
gcloud auth list
```

From the cloud SDK run the following to login with the provided credentials:

```console
gcloud auth login
```

### GCP Project ID

Take note for confirm the GCP project ID assigned to you. From the cloud shell run the following to confirm the associated project:

```console
gcloud projects list
```



### Clone this git-repository

In Cloud Shell session run the following command to use bash assistance:

```console
git clone https://github.com/nadinev6/
```

Change to the blogs directory:

```console
cd cloudshell-commands-for-qwiklabs/Data-to-Insights_Ingesting-and-querying-new-datasets-v1.1
```


## Ingesting Data from Google Cloud Storage



### Create a storage bucket

Set the environment variables for your project ID and bucket name, or use the shortcut below:


```console
projectID=`gcloud config get-value project`
```

```console
bucket=${projectID}-bucket
```

Shortcut:
```console
zsh set-var.sh
```

You should not see any output

**Create a bucket**

```console
gsutil mb -c multi_regional gs://${bucket}
```



### Upload a dataset to Google Cloud Storage


**Upload the dataset to your bucket**


Run the following to copy the NAICS_digit_2017_codes.csv object to your bucket:

```console
gsutil -m cp -r NAICS_digit_2017_codes.csv gs://${bucket}
```

To confirm that the dataset is in your bucket, run the following command:

```console
gsutil ls gs://${bucket}/*
```
(example) Output:

```console
gs://qwiklabs-gcp-03-68354171125c-bucket/NAICS_digit_2017_codes.csv
```


## Ingesting a CSV into a Google BigQuery Table 

### Open BigQuery

bq help retrieves information about the query, run:

```console
bq help query
```

Use the bq ls command to list any existing datasets in your project:

```console
bq ls
```

Your output should be empty since there are not datasets created

Run the following command to list the available datasets:

```console
bq ls bigquery-public-data:
```

There are no datasets so you need to create one


### Create a dataset


Use the bq mk command to create a new dataset named irs_990 in your Qwiklabs project:

```console
bq mk irs_990
```
(example) Output:

```console
Dataset 'qwiklabs-gcp-ba3466847fe3cec0:irs_990 successfully created.
```
Run bq ls to confirm that the dataset is part of your project:

```console
bq ls
```
(example) Output:

```console
 datasetId
 -------------
  irs_990
```

### Upload the dataset

Before you can build the table, you need to add the dataset to your project


```console
wget https://www.kaggle.com/irs/irs-990
```

List the file:

```console
ls
```

If the file is in csv format, ignore the next steps

If the file is zipped then unnzip the file:

```console
unzip irs_990.zip
```

List the file again:

```console
ls
```

### Create table


```console
bq load irs_990 
naics_digit_2017_codes.txt
name:string,gender:string,count:integer
```
example (Output):

```console
Waiting on job_4f0c0878f6184119abfdae05f5194e65 ... (35s) Current status: DONE
```

Run bq ls and naics_digit_2017_codes to confirm that the table now appears in your dataset:

```console
bq ls naics_digit_2017_codes
```

## Reading a CSV as an External Data Source in Google BigQuery Table

Instead of ingesting and storing the CSV data table in Google BigQuery, you decide you want to query the underlying data source directly

The process is essentially the same as before except for changing the Table Type

Ouput:

```console
### Upload the dataset
```

Before you can build the table, you need to add the dataset to your project

Copy and Paste the below GCS path:

Run this command to add the dataset to your project:


**external data configuration**

```console
wget https://github.com/nadinev6/cloudshell-commands-for-qwiklabs/Data-to-Insights_Ingesting-and-querying-new-datasets-v1.1/irs990_code_lookup.csv
```

or

Copy from the cloned repository;

```console
gsutil -m cp -r irs990_code_lookup.csv gs://${bucket}
```

### Create table


```console
bq load irs990_code_lookup 
name:string,gender:string,count:integer
```

example (Output):

```console
Waiting on job_4f0c0878f6184119abfdae05f5194e65 ... (35s) Current status: DONE
```

Run bq ls and babynames to confirm that the table now appears in your dataset:

```console
bq ls irs990_code_lookup 
```

Output:

```console
  tableId    Type
 ----------- -------
  irs990_code_lookup    TABLE
```

Run bq show and your dataset.table to see the schema:

```console
bq show irs_990.irs990_code_lookup 
```

## Run queries

Run the following command:

```console
bq query "SELECT irs_990_field,code, description FROM project.irs_990.irs990_code_lookup WHERE rs_990_field IN (‘elf’,’subbed’)
```


### Clean up

Before deleting a bucket, you must first delete the dataset in the bucket. Rune the following command:

```console
gsutil rm -rf gs://${BUCKET}/*
```

Delete the bucket:

```console
gsutil rb gs://${BUCKET}
```

Run the following command:

```console
bq query "SELECT irs_990_field,code, description FROM project.irs_990.irs990_code_lookup WHERE rs_990_field IN (‘elf’,’subbed’)
```


