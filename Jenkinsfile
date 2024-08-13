pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials-id' // ID of the Docker Hub credentials in Jenkins
        DOCKER_IMAGE_NAME = 'devopsuses/my-flask-app'  // Replace with your Docker image name
        DOCKER_TAG = 'latest'  // You can use a specific tag or use build number, e.g., "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code from your repository
                git url: 'https://github.com/lakshithaiam/my-flask-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        // Push the Docker image
                        docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}").push("${DOCKER_TAG}")
                    }
                }
            }
        }
    }
}
