
pipeline {
    agent any
    
     environment {
        PATH = "$PATH:/usr/local/bin"
        APP_REPO_NAME = "thich48-repo/petclinic-app-staging"
        AWS_REGION = "eu-west-1"
        ECR_REGISTRY = "390665570631.dkr.ecr.eu-west-1.amazonaws.com"
    }

		stages {
			stage('checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/staging'], [name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/thich48/petclinicMicroservices.git']])
                
            }
        }
		
		
        stage('Create ECR Repository') {
            steps {
                script {
                    sh "aws ecr create-repository --repository-name ${APP_REPO_NAME} --image-scanning-configuration scanOnPush=false --image-tag-mutability MUTABLE --region ${AWS_REGION}"
                }
            }
        }
        
        
          stage('Package with Maven Container') {
            steps {
                script {
                    sh './jenkins/package-with-maven-container.sh'
                }
            }
        }      
		
        stage('Build staging Docker Images for ECR') {
            steps {
                script {
                    sh '. ./jenkins/build-staging-docker-images-for-ecr.sh'
                }
            }
        }
		
        stage('Prepare ECR Tags for staging Docker Images') {
            steps {
                script {
                    sh './jenkins/prepare-tags-ecr-for-staging-docker-images.sh'
                }
            }
        }
        
        
         // Uploading Docker images into AWS ECR
        
        stage('Push staging Docker Images to ECR') {
            steps {
                script {
					sh 'aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 390665570631.dkr.ecr.eu-west-1.amazonaws.com'
                    sh '. ./jenkins/push-staging-docker-images-to-ecr.sh'
                }
            }  
        }
		
		 stage('EKS Deploy') {
        steps{   
            script {
			
			withKubeConfig(caCertificate: '', clusterName: 'eks-petclinic', contextName: '', credentialsId: 'K8S', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://53CD0E23729F468DFEC930A2692D4EF8.gr7.eu-west-1.eks.amazonaws.com') {
				sh 'aws eks update-kubeconfig --name eks-petclinic'
				sh 'kubectl apply -f k8s/base2 --recursive'
			}
			
            }
        }
       }
        
    }
}
