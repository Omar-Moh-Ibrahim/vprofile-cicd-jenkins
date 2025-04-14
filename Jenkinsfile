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
                    resources:
                      requests:
                        ephemeral-storage: "2Gi"
                      limits:
                        ephemeral-storage: "4Gi"
                    
                  - name: maven
                    image: maven:3.9.9-eclipse-temurin-21-alpine
                    command: ["sleep", "999999"]
                    volumeMounts:
                      - name: workspace
                        mountPath: /workspace
                    resources:
                      requests:
                        ephemeral-storage: "2Gi"
                      limits:
                        ephemeral-storage: "4Gi"
                    
                  volumes:
                    - name: docker-storage
                      emptyDir: {}
                    - name: workspace
                      emptyDir: {}
                      sizeLimit: "2Gi"
            '''
        }
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKER_IMAGE = 'omaribrahim91/jenkins-test'
    }

    stages {
        stage('Checkout Code') {
            steps {
                container('maven') {
                    checkout scm
                    sh '''
                        echo "===== CREATING .dockerignore ====="
                        cat > .dockerignore <<EOF
**/.git
**/.github
**/target/classes
**/target/generated-*
**/target/surefire-reports
**/target/test-classes
**/*.md
**/Jenkinsfile
EOF
                    '''
                }
            }
        }

        stage('Build WAR') {
            steps {
                container('maven') {
                    sh '''
                        echo "===== BUILDING WAR ====="
                        mvn clean package -DskipTests
                        echo "===== BUILD OUTPUT ====="
                        ls -lh target/
                        echo "===== WAR FILE LOCATION ====="
                        find /workspace -name "*.war"
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh '''
                        echo "===== VERIFYING FILES ====="
                        pwd
                        ls -lh
                        ls -lh target/
                        
                        echo "===== BUILDING IMAGE ====="
                        cat > Dockerfile <<EOF
FROM tomcat:9.0-jre17
WORKDIR /usr/local/tomcat/webapps/
RUN rm -rf ROOT
COPY target/vprofile-v2.war ROOT.war
EOF
                        echo "===== DOCKERFILE CONTENTS ====="
                        cat Dockerfile
                        
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
                    docker logout || true
                    docker system prune -af || true
                '''
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
            container('docker') {
                sh '''
                    echo "===== DIAGNOSTICS ====="
                    df -h
                    docker info || true
                    echo "===== WORKSPACE CONTENTS ====="
                    find /workspace -type f
                '''
            }
        }
    }
}
