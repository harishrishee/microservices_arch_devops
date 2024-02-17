pipeline {
    agent any

    parameters {
        string(name: 'NEW_TAG_VALUE', description: 'Enter the new tag value')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Current User: ${env.USER}"
                sh 'echo passed'
                git branch: 'main', credentialsId: 'PAT', url: 'https://github.com/harishrishee/microservices_arch_devops.git'
            }
        }

        stage('Update Tag in values.yaml') {
            steps {
                // Modify the values.yaml file to update the tag
                script {
                    // Define the new tag value from the parameter
                    def newTag = params.NEW_TAG_VALUE
                    
                    // Use sed to update the tag in values.yaml
                    sh "sed -i 's/tag: .*/tag: ${newTag}/' shoes-microservice-spring-boot-svc/values.yaml"
                }
            }
        }
        stage('Update Remote URL') {
            environment {
                GIT_CREDENTIALS = credentials('PAT')
                REPOSITORY_URL = 'https://github.com/harishrishee/microservices_arch_devops.git'        
            }
            steps {
                script {
                    def credentials = env.GIT_CREDENTIALS
                    def parts = credentials.split(':')
                    def username = parts[0]
                    def token = parts[1]
                    
                    // Update the Git remote URL with username and token
                    sh "git remote set-url origin https://${username}:${token}@${env.REPOSITORY_URL}"
                    sh 'git push --set-upstream origin main'
                }
            }
        }
        stage('Commit Changes') {
            steps {
                // Commit the changes back to the repository
                sh 'git add shoes-microservice-spring-boot-svc/values.yaml'
                sh 'git commit -m "Update tag in values.yaml"'
                sh 'git push'
            }
        }
    }
}