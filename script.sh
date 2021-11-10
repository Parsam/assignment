#!/bin/bash

source aws_creds

function list_buckets()
{
  aws s3 ls | awk '{print $3}'
}

function list_objects()
{
  if [[ -n "$1" ]]; then
    echo "-----------------------------------------"
    echo -e "CreationDate \t\t Size ObjectName"
    echo "-----------------------------------------"
    aws s3 ls --human-readable --recursive $1
  else
    echo "Enter S3 bucket name"
  fi
}

function dscrb() {
  creation_date=`aws s3 ls |grep $bucket_name | awk '{print $1}'`
  region=`aws s3api get-bucket-location --bucket $bucket_name --output text`
  last_modified=`aws s3 ls $bucket_name --recursive | sort | tail -n 1 | awk '{print $1}'`
  if [[ $(aws s3api list-objects --bucket $bucket_name) ]]; then
    number_of_files=`aws s3api list-objects --bucket $bucket_name --output text --query "[length(Contents[])]"`
    size=`aws s3api list-objects --bucket $bucket_name --output text --query "[sum(Contents[].Size)]"`
  else
    number_of_files=""
    size=""
  fi

  output="$bucket_name\t$region\t$creation_date\t$number_of_files\t\t$size\t$last_modified"
  echo -e $output
}

function describe_bucket()
{
  if [[ -n "$1" ]]; then
    echo "-------------------------------------------------------------------------------------"
    echo -e "Name\t\tRegion\t\tCreationDate\tNumberOfFiles\tSize\tLastModified"
    echo "-------------------------------------------------------------------------------------"
    bucket_name=$1
    dscrb
  else
    echo "Enter S3 bucket name"
  fi
}

function describe_all_buckets()
{
  num=1
  bucket_name="bucket"
  echo "-------------------------------------------------------------------------------------"
  echo -e "Name\t\tRegion\t\tCreationDate\tNumberOfFiles\tSize\tLastModified"
  echo "-------------------------------------------------------------------------------------"

  while [ -n "$bucket_name" ]; do
    bucket_name=`aws s3 ls | awk '{print $3}' | sed "${num}q;d"`
    if [[ -n "$bucket_name" ]]; then
      dscrb
    else
      break
    fi
    num=$((num+1))
  done
}


