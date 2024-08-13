pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'devopsuses/my-repo'
        DOCKER_IMAGE_TAG = 'my-flask-app'
        DOCKER_REGISTRY = 'index.docker.io'
        DOCKER_CREDENTIALS_ID = 'docker_id'  // ID of Docker Hub credentials in Jenkins
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
                script {
                    echo 'Logging in to Docker registry...'
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo ${DOCKER_PASSWORD} | docker login ${DOCKER_REGISTRY} -u ${DOCKER_USERNAME} --password-stdin
                        """
                    }
                    
                    echo 'Deploying the Docker image...'
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").push()
                    }
                    
                    echo 'Logging out from Docker registry...'
                    sh 'docker logout ${DOCKER_REGISTRY}'
                }
            }
        }

        stage('Cleanup Docker Images') {
            steps {
                script {
                    echo 'Removing Docker images...'
                    sh "docker rmi ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} || true"  // '|| true' prevents build failure if image is not found
                }
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
