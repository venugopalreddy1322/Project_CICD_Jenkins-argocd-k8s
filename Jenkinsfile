pipeline {
    agent any
    environment {
      DOCKER_IMAGE_NAME = "venu1322/ultimate-cicd"
      DOCKER_IMAGE_TAG = "V${BUILD_ID}"

    }
    stages {
        /*stage('Build package') {
            steps {
                script {
                    sh 'mvn clean install'
                }
            }
        }*/
        stage('Build docker image from Dockerfile') {
            steps {
                script {
                     dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                }
            }
        }
        stage('Static code analysis:SonarQube') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonarqube') {
                    sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        
        
        stage('Push Docker image to DockerHub registry') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub_pwd') {
                    dockerImage.push()
                    }
                }
            }

        }
        stage('Push Arifact to GitHub Repository') {
            environment {
                GIT_USER_NAME = "venugopalreddy1322"
                GIT_REPO_NAME = "Project_CICD_Jenkins-argocd-k8s-manifests-repo"
            }
            steps {
                script {
                    withCredentials([string(credentialsId: 'github_pwd', variable: 'GITHUB_AUTH')]) {
                    sh '''
                    git config user.email "venugopalreddy1322@gmail.com"
                    git config user.name "Venugopalreddy1322"
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" k8s_manifests/k8smanifest.yaml
                    git add k8s_manifests/k8smanifest.yaml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}" k8s_manifests/k8smanifest.yaml
                    
                    git push https://${GITHUB_AUTH}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:refs/heads/main
                    '''
                    }

                }
            }
        }
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }

    }
}
// git pull https://${GITHUB_AUTH}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} main
