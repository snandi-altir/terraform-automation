pipeline {
    agent any
    environment {
        IMAGE_NAME = "jenkins-slave-custom"        
        VERSION = "4.13.3-1-jdk11-terraform1.5"
        IMAGE_VERSION = "${VERSION}"
        ECR_URL = "523530352396.dkr.ecr.us-west-2.amazonaws.com"
        AWS_DEFAULT_REGION = "us-west-2"
        AWS_ACCOUNT_ID = "523530352396"

    }


    stages {
      stage('Git checkout') {
        steps {
                git branch: 'main',
                url: 'https://github.com/snandi-altir/terraform-automation.git'
              }
        }
          
        stage('Build Docker image') {
            steps {
                script {
                  withAWS(roleAccount:'523530352396', role:'AllowAltirJenkins') {
                sh'''
                aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                which docker
                whoami
                docker ps
                cat Dockerfile_jenkinsagent
                docker build -t ${ECR_URL}/${IMAGE_NAME}:${IMAGE_VERSION} . -f Dockerfile_jenkinsagent --no-cache
                '''
                  }
                }
              }
          }
          
            stage('Push docker image to ECR') {
              steps {
                script {
                  withAWS(roleAccount:'523530352396', role:'AllowAltirJenkins') {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker push ${ECR_URL}/${IMAGE_NAME}:${IMAGE_VERSION}"
                }
              }
            }

        }
        
    }
}
