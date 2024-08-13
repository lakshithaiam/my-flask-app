pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials-id' // Replace with your Docker Hub credentials ID
        DOCKER_IMAGE = 'devopsuses/my-repo:latest' // Replace with your Docker image name and tag
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git url: 'git@github.com:lakshithaiam/my-flask-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        // Push the Docker image to Docker Hub
                        docker.image(DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }

        // Optional: Add a deployment stage here if needed
        stage('Deploy') {
            steps {
                script {
                    // Example deployment command
                    echo 'Deploying to production...'
                    // You can replace this with your actual deployment logic
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker resources if needed
            cleanWs()
        }
    }
}

