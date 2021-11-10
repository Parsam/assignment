#!/bin/bash

source aws_creds

num=1
bucket_name="bucket"
#pwd=$(pwd)
echo "-----------------------------------------------------------------------------------------------------" > outfile
echo -e "Name\t\tRegion\t\tCreationDate\t\t\tNumberOfFiles\tSize\tLastModified" >> outfile
echo "-----------------------------------------------------------------------------------------------------" >> outfile
cat outfile

while [ -n "$bucket_name" ]; do

    bucket_name=`aws s3api list-buckets --query "Buckets[].Name" --output text | awk -v i=$num '{print $i;}'`
    creation_date=`aws s3api list-buckets --query "Buckets[].CreationDate" --output text | awk -v n=$num '{print $n;}'`

    if [[ -n "$bucket_name" ]]; then
        region=`aws s3api get-bucket-location --bucket $bucket_name --output text`
        last_modified=`aws s3 ls $bucket_name --recursive | sort | tail -n 1 | awk '{print $1}'`

        if [[ $(aws s3api list-objects --bucket $bucket_name) ]]; then
          number_of_files=`aws s3api list-objects --bucket $bucket_name --output text --query "[length(Contents[])]"`
          size=`aws s3api list-objects --bucket $bucket_name --output text --query "[sum(Contents[].Size)]"`
        else
          number_of_files=""
          size=""
        fi
    else
        region=""
    fi

    #bucket_name=`docker run --rm -it -v $pwd/.aws:/root/.aws amazon/aws-cli s3api list-buckets --query "Buckets[].Name" --output text | awk -v i=$num '{print $i;}'`
    #region=`docker run --rm -it -v $pwd/.aws:/root/.aws amazon/aws-cli s3api get-bucket-location --bucket $bucket_name --output text`
    #creation_date=`docker run --rm -it -v $pwd/.aws:/root/.aws amazon/aws-cli s3api list-buckets --query "Buckets[].CreationDate" --output text | awk -v n=$num '{print $n;}'`

    output="$bucket_name\t$region\t$creation_date\t$number_of_files\t\t$size\t$last_modified"


    echo -e $output >> outfile
    cat outfile | tail -1

    num=$((num+1))
done




