#!/bin/bash

# Add user Jenkins if user doesn't already exist
id jenkins > /dev/null 2>&1
if [ $? != 0 ]
then
  useradd -m -d /var/jenkins jenkins
else
  echo "The user jenkins already exists, you need to do the slave node setup manually"
  echo "Follow the document \"Jenkins continuous build service\" for how to setup a slave node."
  #exit 1
fi


# Change requiretty requirement in sudoers file
# Enables setting capabilities remotely, something that is needed to run the
# breathing unit tests
MOD_FILE=/tmp/sudoers.modified
sed -r 's/^Defaults[ \t]+requiretty/Defaults:jenkins\t!requiretty/g' /etc/sudoers  > $MOD_FILE
chmod 0440 $MOD_FILE
chown root:root $MOD_FILE
mv $MOD_FILE /etc/sudoers


# Setup ssh keys between Jenkins service and this slave node
JENKINS_SSH_DIR=/tmp/$$_.ssh
mkdir -p $JENKINS_SSH_DIR
chmod 700 $JENKINS_SSH_DIR
wget http://sth016ux:8080/job/jenkins_support/ws/id_rsa.pub -O downloaded_id_rsa.pub
cat downloaded_id_rsa.pub > $JENKINS_SSH_DIR/authorized_keys
rm downloaded_id_rsa.pub
chmod 600 $JENKINS_SSH_DIR/authorized_keys
chown -R jenkins:jenkins $JENKINS_SSH_DIR
mv $JENKINS_SSH_DIR ~jenkins/.ssh
