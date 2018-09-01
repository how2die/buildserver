FROM how2die/jenkins-rpi

# Distributed Builds plugins
RUN /usr/local/bin/install-plugins.sh ssh-slaves

# Scaling
RUN /usr/local/bin/install-plugins.sh kubernetes

# GitHub integration
RUN /usr/local/bin/install-plugins.sh github-pullrequest
