# deletes objects and markers in S3 and deletes dynamodb table
echo '#!/bin/bash' > deleteBucketScript.sh \
&& aws --output text s3api list-object-versions --bucket $TFSTATE_BUCKET \
| grep -E "^VERSIONS" |\
awk '{print "aws s3api delete-object --bucket $TFSTATE_BUCKET --key "$4" --version-id "$8";"}' >> \
deleteBucketScript.sh && . deleteBucketScript.sh; rm -f deleteBucketScript.sh; echo '#!/bin/bash' > \
deleteBucketScript.sh && aws --output text s3api list-object-versions --bucket $TFSTATE_BUCKET \
| grep -E "^DELETEMARKERS" | grep -v "null" \
| awk '{print "aws s3api delete-object --bucket $TFSTATE_BUCKET --key "$3" --version-id "$5";"}' >> \
deleteBucketScript.sh && . deleteBucketScript.sh; rm -f deleteBucketScript.sh;

aws s3 rb s3://$TFSTATE_BUCKET 


aws dynamodb delete-table --table-name terraform-state-locks
