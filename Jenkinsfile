pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'flask-app'
        DOCKER_IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo "Running tests"'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the project...'
                sh 'echo "Deploying project"'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            cleanWs()
        }
    }
}
