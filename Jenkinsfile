pipeline {
    agent {
        dockerfile true
    }

    tools {
        maven 'maven' // Specify the Maven installation name
    }
    
    environment {
        APP_NAME = "shoes-microservice-spring-boot-svc"
        RELEASE = "1.0.0"
        DOCKER_USER = "harishrishee"
        DOCKER_PASS = credentials("dockerHubSecret")
        DOCKER_REGISTRY = 'https://index.docker.io/v1/' // Docker Hub URL
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        SONAR_URL = 'http://sonarcube-sonarqube:9000'
        SONAR_TOKEN = credentials('sonarcube-token')
    }

    stages {
        stage('Clone Git Repository') {
            steps {
                script {
                    // Clone the Git repository
                    git branch: 'shoes-microservice-spring-boot-svc', credentialsId: 'PAT', url: 'https://github.com/harishrishee/microservices_arch_devops.git'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarcube') {
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=shoes-microservice-spring-boot-svc -Dsonar.projectName='shoes-microservice-spring-boot-svc' -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_TOKEN}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerHub', url: 'https://index.docker.io/v1/') {
                        def docker_image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                        docker_image.push()
                        docker_image.push('latest') // Pushing latest tag
                    }
                }
            }
        }
    }
}
