pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/lakshithaiam/my-flask-app.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the application...'
                // Example: Build Docker image
                sh 'docker build -t my-flask-app .'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Example: Run tests (if any)
                // sh 'pytest'
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to registry
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                        docker.image('my-flask-app').push("${env.BUILD_ID}")
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Example: Deploy to Kubernetes or another environment
                // sh 'kubectl apply -f deployment.yaml'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Perform cleanup actions, such as removing Docker images
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
