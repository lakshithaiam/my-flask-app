pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "54.161.97.225"
    }
    stages {
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
                        sshCommand remote: remote, command: "ansible-playbook -i aws_ec2.yml ping.yml"
                        
                       
                    }
                }
            }
        }
    }   
}