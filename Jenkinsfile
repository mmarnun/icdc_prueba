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
                            newApp = docker.build "$IMAGEN:latest"
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
        stage('ConexionSSH') {
            agent any
            steps {
                script {
                    sshagent(credentials: ['SSH_USER']) {
                        sh 'ssh -o StrictHostKeyChecking=no alex@isrevol.alexnm.es wget https://raw.githubusercontent.com/mmarnun/icdc_prueba/main/docker-compose.yaml -O prueba/docker-compose.yaml'
                        sh 'ssh -o StrictHostKeyChecking=no alex@isrevol.alexnm.es cd prueba/ && docker compose pull && docker compose down && docker compose up -d'
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'alejandromanuelmartin03@gmail.com',
            subject: "Imagen creada!!",
            body: "Imagen: $IMAGEN"
        }
    }
}
