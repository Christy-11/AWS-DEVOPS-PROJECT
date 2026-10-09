pipeline {
    agent any

    environment {
        REGISTRY = "ghcr.io"
        IMAGE_NAME = "christy-11/aws-devops-project"
        TAG = "latest"
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
    }
}
