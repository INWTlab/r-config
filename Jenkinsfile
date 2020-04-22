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
                   docker build -t tmp_deb_builder .
                   docker run --rm --name tmp_deb_builder \
                     -v /var/www/html/deb-repo:/tmp/deb-repo/ \
                     tmp_deb_builder
                '''
            }
        }
    }
    post {
        always {
            sh '''
               docker stop tmp_deb_builder || :
               docker rmi tmp_deb_builder || :
            '''
        }
    }
}