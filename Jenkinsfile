pipeline {
    environment {
        IMAGEN = "mmarnun/prueba"
        USUARIO = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("BuildImagenDocker") {
            agent any
            stages {
                stage('Clone') {
                    steps {
                        git branch:'main',url:'https://github.com/mmarnun/icdc_prueba.git'
                    }
                }
                stage('BuildImagen') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:$BUILD_NUMBER"
                        }
                    }
                }
                stage('SubirImagen') {
                    steps {
                        script {
                            docker.withRegistry('', USUARIO) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('RemoveImage') {
                    steps {
                        sh "docker rmi $IMAGEN:$BUILD_NUMBER"
                    }
                }
            }
        }
        stage('ConexionSSH') {
            agent any
            steps {
                script {
                    sshagent(credentials: ['SSH_USER']) {
                        sh 'ssh -o StrictHostKeyChecking=no alex@isrevol.alexnm.es wget https://raw.githubusercontent.com/mmarnun/icdc_prueba/main/docker-compose.yaml -O prueba/docker-compose.yaml'
                        sh 'ssh -o StrictHostKeyChecking=no alex@isrevol.alexnm.es cd prueba/ && docker compose up -d --force-recreate'
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'alejandromanuelmartin03@gmail.com',
            subject: "Imagen creada!",
            body: "Imagen: $IMAGEN:$BUILD_NUMBER"
        }
    }
}
