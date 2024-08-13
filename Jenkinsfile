pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker_id' // Jenkins credentials ID for Docker Hub
        DOCKER_IMAGE_NAME = 'devopsuses/my-repo'           // Replace with your Docker image name
        DOCKER_TAG = 'latest'                            // Replace with your desired tag
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from your GitHub repository
                git 'https://github.com/lakshithaiam/my-flask-app.git'
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
                    // Login to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        // Push the Docker image
                        docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}").push("${DOCKER_TAG}")
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images
            sh 'docker system prune -af'
        }
    }
}
