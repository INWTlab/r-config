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
        stage('Build package builder') {
            steps {
                sh '''
                  docker build -t tmp-deb-builder .
                '''
            }
        }
        stage('Build r.deb package') {
            environment {
                GPG_PASSPHRASE = credentials('deb-repo-gpg-passphrase-aneudecker')
                GPG_KEY = credentials('deb-repo-gpg-key-aneudecker')
            }
            steps {
                sh '''
                    mkdir -p .gpg
                    cp $GPG_PASSPHRASE .gpg/passphrase
                    cp $GPG_KEY .gpg/private.key

                    docker run --rm --name tmp-deb-builder-r \
                      --memory=$MEMORY --memory-swap=$MEMORY \
                      --cpus=$NWORKERS -e NWORKERS=$NWORKERS \
                      -v $PWD/.gpg:/app/.gpg \
                      -v /var/www/html/deb-repo:/tmp/deb-repo/ \
                      tmp-deb-builder bash r-deb/build.sh
                '''
            }
        }
        stage('Build r-packages.deb package') {
            environment {
                GPG_PASSPHRASE = credentials('deb-repo-gpg-passphrase-aneudecker')
                GPG_KEY = credentials('deb-repo-gpg-key-aneudecker')
            }
            steps {
                sh '''
                    mkdir -p .gpg
                    cp $GPG_PASSPHRASE .gpg/passphrase
                    cp $GPG_KEY .gpg/private.key

                    docker run --rm --name tmp-deb-builder-r-packages \
                      --memory=$MEMORY --memory-swap=$MEMORY \
                      --cpus=$NWORKERS -e NWORKERS=$NWORKERS \
                      -v $PWD/.gpg:/app/.gpg \
                      -v /var/www/html/deb-repo:/tmp/deb-repo/ \
                      tmp-deb-builder bash r-packages-deb/build.sh
                '''
            }
        }
    }
    post {
        always {
            sh '''
               rm -rf .gpg
               docker stop tmp-deb-builder-r || :
               docker stop tmp-deb-builder-r-packages || :
               # docker rmi tmp-deb-builder || :
            '''
        }
    }
}