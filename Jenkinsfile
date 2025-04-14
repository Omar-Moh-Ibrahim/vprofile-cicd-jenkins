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
        DOCKER_IMAGE = 'omaribrahim91/web01'
    }

    stages {
        stage('Checkout Code') {
            steps {
                container('maven') {
                    checkout scm
                }
            }
        }

        stage('Build WAR') {
            steps {
                container('maven') {
                    sh '''
                        echo "===== BUILDING WAR ====="
                        mvn clean package
                        echo "===== BUILD OUTPUT ====="
                        ls -l target/
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh '''
                        echo "===== PREPARING DOCKERFILE ====="
                        cat > Dockerfile <<EOF
FROM tomcat:9.0-jre17
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
EOF
                        echo "===== DOCKERFILE CONTENTS ====="
                        cat Dockerfile
                        
                        echo "===== BUILDING IMAGE ====="
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
                        echo "===== LOGGING TO DOCKER HUB ====="
                        echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                        
                        echo "===== PUSHING IMAGE ====="
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            container('docker') {
                sh 'docker logout || true'
            }
            cleanWs()
        }
        success {
            echo "===== SUCCESS ====="
            echo "Image pushed: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
            echo "Image pushed: ${DOCKER_IMAGE}:latest"
        }
        failure {
            echo "===== BUILD FAILED ====="
        }
    }
}
