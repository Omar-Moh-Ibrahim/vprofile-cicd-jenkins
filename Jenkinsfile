pipeline {
    agent {
        kubernetes {
            yaml '''
                spec:
                  containers:
                  - name: docker
                    image: docker:dind
                    securityContext:
                      privileged: true
                    volumeMounts:
                      - name: docker-storage
                        mountPath: /var/lib/docker
                      - name: workspace
                        mountPath: /workspace
                    env:
                      - name: DOCKER_TLS_CERTDIR
                        value: ""
                    
                  - name: maven
                    image: maven:3.9.9-eclipse-temurin-21-alpine
                    command: ["sleep", "999999"]
                    volumeMounts:
                      - name: workspace
                        mountPath: /workspace
                    
                  volumes:
                    - name: docker-storage
                      emptyDir: {}
                    - name: workspace
                      emptyDir: {}
            '''
        }
    }
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        GIT_REPO = 'https://github.com/Omar-Moh-Ibrahim/vprofile-cicd-jenkins.git'
        DOCKER_IMAGE = ' omaribrahim91/web01'
    }
    
    stages {
        stage('Checkout GitHub Repo') {
            steps {
                container('maven') {
                    sh '''
                        echo "===== CLONING REPOSITORY ====="
                        git clone ${GIT_REPO} /workspace/source
                        cd /workspace/source
                        git checkout main
                    '''
                }
            }
        }
        
        stage('Build WAR File') {
            steps {
                container('maven') {
                    sh '''
                        echo "===== BUILDING WAR ====="
                        cd /workspace/source
                        mvn clean package
                        ls -l target/*.war
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh '''
                        echo "===== BUILDING DOCKER IMAGE ====="
                        cd /workspace/source
                        
                        cat > Dockerfile <<EOF
FROM tomcat:9.0-jre17
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
EOF
                        
                        docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                        docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                container('docker') {
                    sh '''
                        echo "===== PUSHING TO DOCKER HUB ====="
                        echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo "===== CLEANUP ====="
            container('docker') {
                sh '''
                    docker logout
                '''
            }
        }
        success {
            echo "===== SUCCESS ====="
            echo "Docker image pushed to Docker Hub: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
        }
    }
}
