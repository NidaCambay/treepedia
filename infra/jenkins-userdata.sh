#!/bin/bash
set -e

echo " System update..."
sudo apt update -y
sudo apt install -y wget unzip curl gnupg software-properties-common apt-transport-https ca-certificates maven net-tools

# -----------------------------
# Install OpenJDK 21
# -----------------------------
echo "Installing OpenJDK 21 from apt..."
sudo apt install -y openjdk-21-jdk
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' | sudo tee /etc/profile.d/jdk.sh
echo 'export PATH=$JAVA_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/jdk.sh
source /etc/profile.d/jdk.sh

# -----------------------------
# Install Jenkins
# -----------------------------
echo "Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -----------------------------
# Install Docker
# -----------------------------
echo "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins


# -----------------------------
# Install AWS CLI v2
# -----------------------------
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# -----------------------------
# Install aws-iam-authenticator
# -----------------------------
echo "Installing aws-iam-authenticator for x86_64..."
VERSION="0.7.2"
curl -Lo aws-iam-authenticator "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${VERSION}/aws-iam-authenticator_${VERSION}_linux_amd64"
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin

# -----------------------------
# Final message
# -----------------------------
echo "Jenkins, Docker, Java 21, aws cli,"
echo "Jenkins running at port 8080. To get admin password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
