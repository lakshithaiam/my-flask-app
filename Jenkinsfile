pipeline {
    agent any

    environment {
        // Define environment variables for Docker Hub and GitHub
        DOCKER_HUB_REPO = 'lakshithaiam/my-flask-app' // Docker Hub repository name
        DOCKER_HUB_CREDENTIALS = 'dockerhub_credentials_id' // Jenkins credentials ID for Docker Hub
        GIT_REPO = 'git@github.com:lakshithaiam/my-flask-app.git' // GitHub repository SSH URL
        GIT_CREDENTIALS = 'github-ssh-key' // Jenkins credentials ID for GitHub SSH
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub using SSH
                git branch: 'main',
                    credentialsId: "${GIT_CREDENTIALS}",
                    url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${DOCKER_HUB_REPO}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        docker.image("${DOCKER_HUB_REPO}").push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
    }
}
