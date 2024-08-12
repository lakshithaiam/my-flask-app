pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker_id')
        DOCKER_IMAGE = "devopsuses/my-flask-app"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/lakshithaiam/my-flask-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}:latest").inside {
                        sh 'python -m unittest discover'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKER_HUB_CREDENTIALS') {
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

