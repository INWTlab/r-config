pipeline {
    agent { label 'master' }
    options {
      disableConcurrentBuilds()
      timeout(time: 3, unit: 'HOURS')
    }
    stages {
        stage('Build package') {
            steps {
                sh '''
                   docker build -t tmp-deb-builder .
                   docker run --rm --name tmp-deb-builder \
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