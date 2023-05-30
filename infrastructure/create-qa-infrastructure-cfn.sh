PATH="$PATH:/usr/local/bin"
APP_NAME="petclinic"
APP_STACK_NAME="Adam-$APP_NAME-App-QA-${BUILD_NUMBER}"
CFN_KEYPAIR="adam-${APP_NAME}-qa.key"
CFN_TEMPLATE="./infrastructure/qa-docker-swarm-infrastructure-cfn-template.yml"
AWS_REGION="eu-west-1"
aws cloudformation create-stack --region ${AWS_REGION} --stack-name ${APP_STACK_NAME} --capabilities CAPABILITY_IAM --template-body file://${CFN_TEMPLATE} --parameters ParameterKey=KeyPairName,ParameterValue=${CFN_KEYPAIR}