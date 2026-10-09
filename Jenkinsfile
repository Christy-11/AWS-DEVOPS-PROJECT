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
                    app = docker.build("${REGISTRY}/${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Login to GHCR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ghcr-credentials', usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                    sh 'echo $GH_TOKEN | docker login ghcr.io -u $GH_USER --password-stdin'
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
