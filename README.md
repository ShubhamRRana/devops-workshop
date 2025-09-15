- GitHub: Integrated version control for efficient code management. 📂
- Jenkins: Automated CI/CD pipeline for continuous integration. ⚙️
- Terraform: Provisioned cloud infrastructure with EC2 and Kubernetes. ☁️
- Ansible: Configured Jenkins master/slave and Maven on EC2 instances. 🖥️
- Docker: Containerized apps and stored images in JFrog Artifactory. 🐳
- Helm: Simplified Kubernetes app deployment. 🚢
- Prometheus & Grafana: Set up for system monitoring and visualization. 📊

Jeknins Pipeline:
- Build Stage : Runs mvn clean deploy to compile, test, and deploy the project using Maven. 🔨📦
- Jar Publish Stage : Publishes the generated JAR file to JFrog Artifactory using the Artifactory server and the defined uploadSpec. 📤📝
- Docker Build Stage : Builds a Docker image from the Dockerfile, tagging it with imageName and version. 🐳🔧
- Docker Publish Stage : Pushes the Docker image to JFrog Artifactory for storage and distribution. ⬆️🖼️
- Deploy Stage : Uses Helm to deploy the application (ttrend) to a Kubernetes cluster with the defined Helm chart. 🚢🌐
