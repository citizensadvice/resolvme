#!/usr/bin/env groovy

node('docker && awsaccess') {
  cleanWorkspace()

  stage('Build docker image') {
    checkout scm
    def imageId = 'docker.io/resolvme:latest'
    dockerImage = docker.build('resolvme:latest')
    dockerTestImage = docker.build('resolvme:jenkins', "-f Dockerfile-dev .")
  }

  dockerTestImage.inside() {
    stage('Run linter') {
      sh 'bundle exec rubocop --fail-level=F'
    }

    stage('Run unit tests') {
      sh 'bundle exec rake spec'
    }

    stage('Publish coverage report') {
      publishHTML([
        allowMissing: false,
        alwaysLinkToLastBuild: true,
        keepAll: false,
        reportDir: 'coverage',
        reportFiles: 'index.html',
        reportName: 'Coverage report'
      ])
    }

    stage('Generate documentation') {
      sh 'bundle exec yard doc --exclude vendor .'
      publishHTML([
        allowMissing: false,
        alwaysLinkToLastBuild: true,
        keepAll: false,
        reportDir: 'doc',
        reportFiles: 'index.html',
        reportName: 'Resolvme documentation'
      ])
    }
  }
}
