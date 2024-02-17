pipeline {
    agent any

    tools {
        maven 'Maven 3.9.6'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Current User: ${env.USER}"
                sh 'echo passed'
                git branch: 'shoes-microservice-spring-boot-svc', credentialsId: 'PAT', url: 'https://github.com/harishrishee/microservices_arch_devops.git'
            }
        }

        stage('SonarQube Analysis') {
             environment {
                SONAR_URL = 'https://sonarqube.automationlabs.work.gd'
                SONAR_TOKEN = credentials('sonarcube-token')
            }
            steps {
                withSonarQubeEnv('sonarcube') {
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=shoes-microservice-spring-boot-svc -Dsonar.projectName='shoes-microservice-spring-boot-svc' -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_TOKEN}"
                }
            }
        }

        stage('Build') {
            steps {
                // Run Maven commands
                sh 'mvn clean install'
            }
        }

        stage('Build and Push Docker Image') {
            environment {
                DOCKER_REGISTRY_CREDENTIALS = credentials('dockerHub')
                DOCKER_IMAGE = "harishrishee/mavensvc:${BUILD_NUMBER}"
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerHub') {
                        sh "docker login -u $DOCKER_REGISTRY_CREDENTIALS_USR -p $DOCKER_REGISTRY_CREDENTIALS_PSW"
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        sh "docker push ${DOCKER_IMAGE}"
                        sh "docker rmi ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }
}
