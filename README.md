## **This is a command line utility that returns information over all S3 buckets in an Amazon account.**


-------------------------------------


#### First you have to create aws_creds file with AWS credentials in this folder.

#### Then source script.sh file in your terminal session.
$source script.sh


--------------------------------------

#### The following functions are available


`list_buckets` - list all S3 buckets in AWS account

`list_objects` - list objects in bucket (require an argument)

`describe_bucket` - show detailed information about specific bucket (require an argument)

`describe_all_buckets` - show detailed information about all bucket in AWS account