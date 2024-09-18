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

        stage('Create Infrastructure') {
            environment{
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRECT_ACCESS_KEY = credentials('jenkins_aws_secrect_access_key')
            }          
            steps {
                script { 
                    dir('terraform'){
                        sh "terraform --version"
                        sh "ls -a"
                        sh "terraform init"
                        sh "terraform plan"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output instance_public_ips"
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Get some instance Infomation') {
            steps {

                echo "waithing for EC2 server to initialize"
                sleep(time: 120, unit: "SECONDS")

                echo "creating new file"
                echo "${EC2_PUBLIC_IP}"

                def ec2Instance = "ubuntu@${EC2_PUBLIC_IP}"

                sshagent(['server_ssh_key_terraform']){
                    sh "scp -o StrictHostKeyChecking=no README.md ${ec2Instance}:/home/ubuntu"
                    
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
