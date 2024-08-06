pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:lakshithaiam/my-flask-app.git', credentialsId: 'SSH_Username_with_private_key'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'echo "Building application..."'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo "Running tests..."'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
