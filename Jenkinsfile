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
    // TODO: fix linting issues and enable this section
    //stage('Run linter') {
    //  sh 'bundle exec rubocop --cache false bin lib --except Style/AccessModifierDeclarations'
    //  // ignore long blocks in spec files
    //  sh 'bundle exec rubocop --cache false --except Metrics/BlockLength spec'
    //}

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
        reportName: 'Loki documentation'
      ])
    }
  }
}
