FROM how2die/jenkins-rpi

# Install git
RUN apt-get update && apt-get install -y git

# Install Docker
RUN curl -sSL https://get.docker.com | sh

# Install kubectl
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list 
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl
