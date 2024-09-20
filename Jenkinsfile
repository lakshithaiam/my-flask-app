pipeline {
    agent any
    environment {
        // Define environment variables for Docker Hub and GitHub
        DOCKER_HUB_REPO = 'lakshithaiam/my-flask-app' // Docker Hub repository name
        DOCKER_HUB_CREDENTIALS = 'dockerhub_credentials_id' // Jenkins credentials ID for Docker Hub
        GIT_REPO = 'git@github.com:lakshithaiam/my-flask-app.git' // GitHub repository SSH URL
        GIT_CREDENTIALS = 'github-ssh-key' // Jenkins credentials ID for GitHub SSH
        
        ANSIBLE_SERVER = "54.161.97.225"
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
                        
                    }
                }
            }
        }

    }

}

        stage("copy files to ansible server") {
            steps {
                script {
                    echo "copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh 'scp $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/ssh-key.pem'
                        }
                    }
                }
            }
        }
        stage("execute ansible playbook") {
            steps {
                script {
                    echo "calling ansible playbook to configure ec2 instances"
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]){
                        remote.user = user
                        remote.identityFile = keyfile
                        sshCommand remote: remote, command: "ansible --version"
                        sshCommand remote: remote, command: "ansible-inventory -i aws_ec2.yml --list"
                        sshCommand remote: remote, command: "ansible-inventory -i aws_ec2.yml --graph"
                        sshCommand remote: remote, command: "ls -l"
                        sshCommand remote: remote, command: "ansible-playbook -i aws_ec2.yml newping.yml python_version.yml installdocker.yml appdeploy.yml"
                        
                       
                    }
                }
            }
        }
    }   
}