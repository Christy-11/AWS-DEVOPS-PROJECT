pipeline {
    agent any

    environment {
        REGISTRY = "ghcr.io"
        IMAGE_NAME = "christy-11/aws-devops-project"
        TAG = "latest"
        EC2_IP = "13.203.157.207"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def app = docker.build("${REGISTRY}/${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Login to GHCR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Cath-git', usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                    bat 'echo %GH_TOKEN% | docker login ghcr.io -u %GH_USER% --password-stdin'
                }
            }
        }

        stage('Push to GHCR') {
            steps {
                script {
                    docker.image("${REGISTRY}/${IMAGE_NAME}:${TAG}").push()
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'EC2_USER')]) {
                    bat 'copy "%SSH_KEY%" C:\\Windows\\Temp\\ec2_key.pem'
                    bat 'icacls C:\\Windows\\Temp\\ec2_key.pem /inheritance:r'
                    bat 'icacls C:\\Windows\\Temp\\ec2_key.pem /grant:r "%USERNAME%:(R)"'
                    bat "ssh -o StrictHostKeyChecking=no -i C:\\Windows\\Temp\\ec2_key.pem %EC2_USER%@%EC2_IP% \"docker pull ${REGISTRY}/${IMAGE_NAME}:${TAG} && docker stop flask-app || true && docker rm flask-app || true && docker run -d --name flask-app -p 80:80 ${REGISTRY}/${IMAGE_NAME}:${TAG}\""
                    bat 'del C:\\Windows\\Temp\\ec2_key.pem'
                }
            }
        }
    }
}
