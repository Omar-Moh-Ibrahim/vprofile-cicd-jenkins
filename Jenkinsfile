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
                        cpu: "500m"
                        memory: "512Mi"
                        ephemeral-storage: "1Gi"
                      limits:
                        cpu: "1"
                        memory: "1Gi"
                        ephemeral-storage: "2Gi"
                    
                  - name: maven
                    image: maven:3.9.9-eclipse-temurin-21-alpine
                    command: ["sleep", "999999"]
                    volumeMounts:
                      - name: workspace
                        mountPath: /workspace
                    resources:
                      requests:
                        cpu: "500m"
                        memory: "512Mi"
                        ephemeral-storage: "1Gi"
                      limits:
                        cpu: "1"
                        memory: "1Gi"
                        ephemeral-storage: "2Gi"
                    
                  volumes:
                    - name: docker-storage
                      emptyDir: {}
                    - name: workspace
                      emptyDir: {}
                      sizeLimit: "1Gi"
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
                        du -sh target/*.war
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh '''
                        echo "===== DOCKER BUILD CONTEXT ====="
                        du -sh .
                        du -sh target/

                        echo "===== BUILDING IMAGE ====="
                        docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                        docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                        
                        echo "===== IMAGE DETAILS ====="
                        docker images | grep ${DOCKER_IMAGE}
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
                '''
            }
        }
    }
}
