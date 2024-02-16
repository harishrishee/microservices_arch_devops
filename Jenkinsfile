pipeline {
  agent any
  
  stages {
    stage('Install Maven') {
        steps {
            script {
                def mvnHome = tool 'Maven 3.8.4'
                // Ensure that Maven is installed
                if (mvnHome == null) {
                    // Install Maven if not found
                    def mvnInstaller = tool 'Maven 3.8.4'
                    if (mvnInstaller == null) {
                        echo 'Installing Maven...'
                        // Install Maven from Apache
                        mvnInstaller = tool name: 'Maven 3.8.4', type: 'maven', label: ''
                    }
                    mvnHome = mvnInstaller
                }
                // Set environment variable for Maven home directory
                env.MAVEN_HOME = mvnHome
                // Update PATH to include Maven bin directory
                env.PATH = "${mvnHome}/bin:${env.PATH}"
            }
        }
    }
    stage('Checkout') {
      steps {
        sh 'echo passed'
        //git branch: 'main', url: 'https://github.com/iam-veeramalla/Jenkins-Zero-To-Hero.git'
        git branch: 'shoes-microservice-spring-boot-svc', url: 'https://github.com/harishrishee/microservices_arch_devops.git'
      }
    }
    stage('Build') {
      steps {
          // Run Maven commands
          sh 'mvn clean install'
      }
    }
    // stage('Static Code Analysis') {
    //   environment {
    //     SONAR_URL = "http://34.201.116.83:9000"
    //   }
    //   steps {
    //     withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
    //       sh 'cd java-maven-sonar-argocd-helm-k8s/spring-boot-app && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
    //     }
    //   }
    // }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "harishrishee/mavensvc:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('dockerHub')
      }
      steps {
        script {
            sh 'cd java-maven-sonar-argocd-helm-k8s/spring-boot-app && docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "dockerHub") {
                dockerImage.push()
            }
        }
      }
    }
    // stage('Update Deployment File') {
    //     environment {
    //         GIT_REPO_NAME = "Jenkins-Zero-To-Hero"
    //         GIT_USER_NAME = "iam-veeramalla"
    //     }
    //     steps {
    //         withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
    //             sh '''
    //                 git config user.email "abhishek.xyz@gmail.com"
    //                 git config user.name "Abhishek Veeramalla"
    //                 BUILD_NUMBER=${BUILD_NUMBER}
    //                 sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
    //                 git add java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
    //                 git commit -m "Update deployment image to version ${BUILD_NUMBER}"
    //                 git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
    //             '''
    //         }
    //     }
    // }
  }
}