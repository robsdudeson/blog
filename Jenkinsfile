import groovy.json.JsonOutput

def slackNotificationChannel = 'builds'

def notifySlack(text, channel, attachments) {
    def slackURL = 'https://hooks.slack.com/services/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'
    def jenkinsIcon = 'https://wiki.jenkins-ci.org/download/attachments/2916393/logo.png'

    def payload = JsonOutput.toJson([text: text,
        channel: channel,
        username: "Jenkins",
        icon_url: jenkinsIcon,
        attachments: attachments
    ])

    sh "curl -X POST --data-urlencode \'payload=${payload}\' ${slackURL}"
}

def appImg = null

pipeline {
  agent any

  stages {
      stage('Build Image') {
        steps {
          script{
            appImg = docker.build('robsdudeson/blog:latest')
          }
        }
      }

      stage('Reset DB') {
        steps {
          sh "docker-compose run app wait-for-it db:3306 -- rake db:reset"
        }
      }

      stage('Run Tests'){
        steps {
          sh "docker-compose run app wait-for-it db:3306 -- rake test"
        }
      }

      stage('Publish Image To Registry'){
        steps {
          script{
            docker.withRegistry('https://registry.hub.docker.com','hub.docker.com - credentials'){
              appImg.push(env.BRANCH_NAME)

              switch (env.BRANCH_NAME){
                case "master":
                  appImg.push('latest')
                break
                case "develop":
                  appImg.push('latest-develop')
                break
              }
            }
          }
        }
      }

      stage('Deploy Image to Dev Env'){
        steps{
          script {
          switch (env.BRANCH_NAME){
            case "master":
              sh 'echo Not doing that yet...'
            break
            case "develop":
              //sh 'echo its broke on the server side ... will check on it when i get a minute lawlzzzzzz'
              sh 'scp docker-compose.deploy.yml jenkins@docker.robsdudeson.com:/home/jenkins/blog/docker-compose.deploy.yml'
              sh 'scp deploy.sh jenkins@docker.robsdudeson.com:/home/jenkins/blog/deploy.sh'
              sh 'ssh jenkins@docker.robsdudeson.com chmod +x /home/jenkins/blog/deploy.sh'
              sh 'ssh jenkins@docker.robsdudeson.com /home/jenkins/blog/deploy.sh'
            break
          }
        }
      }
    }
  }
  post {
    always {
      sh "docker-compose down -v"
    }
    success{
      notifySlack("SUCCESS: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}] ${env.BUILD_URL}", slackNotificationChannel, [])
    }
    failure{
      notifySlack("FAILED: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}] ${env.BUILD_URL}", slackNotificationChannel, [])
    }
  }
}
