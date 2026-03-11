// =============================================================================
// Jenkinsfile — CI Pipeline for claude-project
//
// Flow:
//   Checkout (develop) → Build → Test → Push to GitHub → Docker Build → Verify
//
// Requirements:
//   - Jenkins agent with label 'docker-agent' (Docker + Git + Maven installed)
//   - Credentials ID 'github-credentials' configured in Jenkins
// =============================================================================

pipeline {
    // Run on any agent that has Docker + Maven available
    agent {
        label 'docker-agent'
    }

    environment {
        // ── Project info ──────────────────────────────────────────────────────
        APP_NAME    = 'claude-project'
        APP_VERSION = '0.0.1-SNAPSHOT'
        IMAGE_NAME  = "${APP_NAME}:${APP_VERSION}"
        IMAGE_LATEST = "${APP_NAME}:latest"

        // ── GitHub settings ───────────────────────────────────────────────────
        // Credential ID stored in Jenkins → Manage Credentials
        GITHUB_CREDENTIALS = 'github-credentials'
        GITHUB_ACCOUNT     = 'ShibaDev2026'
        GITHUB_REPO_URL    = "https://github.com/${GITHUB_ACCOUNT}/claude-project.git"
        GITHUB_BRANCH      = 'develop'

        // ── Maven JVM tuning ──────────────────────────────────────────────────
        MAVEN_OPTS = '-Xms256m -Xmx1g'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))   // keep last 10 builds
        timeout(time: 30, unit: 'MINUTES')               // abort if > 30 min
        timestamps()                                     // prefix logs with time
    }

    triggers {
        // Poll GitHub every 5 minutes; fires only when new commits are detected
        pollSCM('H/5 * * * *')
    }

    stages {

        // ── Stage 1: Checkout ─────────────────────────────────────────────────
        // Pull the latest code from the develop branch before doing anything else
        stage('Checkout') {
            steps {
                echo '=== [1/6] Checkout — pulling latest code from develop ==='
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${GITHUB_BRANCH}"]],
                    userRemoteConfigs: [[
                        url: "${GITHUB_REPO_URL}",
                        credentialsId: "${GITHUB_CREDENTIALS}"
                    ]]
                ])
                echo "Current commit: ${env.GIT_COMMIT}"
            }
        }

        // ── Stage 2: Build ────────────────────────────────────────────────────
        // Compile source code and package into a JAR (tests skipped here,
        // run separately in the next stage for clearer reporting)
        stage('Build') {
            steps {
                echo '=== [2/6] Build — mvn clean package ==='
                sh 'mvn clean package -DskipTests'
            }
        }

        // ── Stage 3: Test ─────────────────────────────────────────────────────
        // Execute unit/integration tests and publish the JUnit report
        stage('Test') {
            steps {
                echo '=== [3/6] Test — mvn test ==='
                sh 'mvn test'
            }
            post {
                always {
                    // Publish test results even if tests fail
                    junit allowEmptyResults: true,
                          testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        // ── Stage 4: Push to GitHub develop ───────────────────────────────────
        // Maven build + test passed → push HEAD to develop and tag the commit.
        // Docker stages only run after GitHub is successfully updated.
        stage('Push to GitHub') {
            steps {
                echo '=== [4/6] Push to GitHub — Maven build succeeded, updating develop ==='
                withCredentials([usernamePassword(
                    credentialsId: "${GITHUB_CREDENTIALS}",
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {
                    sh """
                        # Configure git identity for the CI bot
                        git config user.email "ci-bot@jenkins"
                        git config user.name  "Jenkins CI"

                        # Tag this commit to mark a successful Maven build
                        git tag -f build-${BUILD_NUMBER}

                        # Push HEAD and the tag to develop
                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/${GITHUB_ACCOUNT}/claude-project.git \
                            HEAD:refs/heads/${GITHUB_BRANCH}
                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/${GITHUB_ACCOUNT}/claude-project.git \
                            build-${BUILD_NUMBER} --force
                    """
                }
                echo "Pushed: HEAD → ${GITHUB_BRANCH}, tag: build-${BUILD_NUMBER}"
            }
        }

        // ── Stage 5: Docker Build ─────────────────────────────────────────────
        // Build a Docker image from the JAR produced in Stage 2
        // Tagged as both <version> and latest for convenience
        stage('Docker Build') {
            steps {
                echo '=== [5/6] Docker Build — building image ==='
                sh "docker build -t ${IMAGE_NAME} -t ${IMAGE_LATEST} ."
            }
        }

        // ── Stage 6: Verify Image ─────────────────────────────────────────────
        // Quick sanity check: confirm the image exists and inspect its metadata
        stage('Verify Image') {
            steps {
                echo '=== [6/6] Verify Image — inspecting Docker image ==='
                sh "docker image inspect ${IMAGE_NAME}"
                sh "docker images | grep ${APP_NAME}"
            }
        }

    }

    // ── Post-build actions ────────────────────────────────────────────────────
    post {
        success {
            echo "Build SUCCESS: ${APP_NAME} ${APP_VERSION} (build #${BUILD_NUMBER})"
        }
        failure {
            echo "Build FAILED:  ${APP_NAME} ${APP_VERSION} (build #${BUILD_NUMBER})"
        }
        always {
            // Clean workspace after every build to free disk space
            cleanWs()
        }
    }
}
