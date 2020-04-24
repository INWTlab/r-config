pipeline {
    agent { label 'master' }
    options {
      disableConcurrentBuilds()
      timeout(time: 3, unit: 'HOURS')
    }
    environment {
        NWORKERS = 2
        MEMORY = "10g"
    }
    stages {
        stage('Build package') {
            steps {
                sh '''
                  docker build -t tmp-deb-builder .
                  docker run --rm --name tmp-deb-builder \
                    --memory=$MEMORY --memory-swap=$MEMORY \
                    --cpus=$NWORKERS -e NWORKERS=$NWORKERS \
                    -v /var/www/html/deb-repo:/tmp/deb-repo/ \
                    tmp-deb-builder
                '''
            }
        }
    }
    post {
        always {
            sh '''
               docker stop tmp-deb-builder || :
               docker rm tmp-deb-builder || :
               docker rmi tmp-deb-builder || :
            '''
        }
    }
}