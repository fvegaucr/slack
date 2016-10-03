#!/bin/bash

CHECK_RUBY=`whereis ruby | grep ruby: | cut -d : -f2`
CHECK_GEM=`whereis gem | grep gem: | cut -d : -f2`
BOOTST_LOG="../var/bootstrap_sh.log"


if [ "$CHECK_RUBY" == "" ] && [ "$CHECK_GEM" == "" ]; then
    printf "`date -u` --" >> $BOOTST_LOG
    sudo apt-get autoremove -y ruby >> $BOOTST_LOG 2>&1
    sudo apt-get autoremove -y gem >> $BOOTST_LOG 2>&1
    printf "`date -u` --" >> $BOOTST_LOG
      apt-get install -y ruby-full >> $BOOTST_LOG 2>&1
    printf "`date -u` --" >> $BOOTST_LOG
      apt-get install -y rubygems >> $BOOTST_LOG 2>&1
    sleep 5
    printf "`date -u` --" >> $BOOTST_LOG
      echo "Ruby has being installed"
      ruby -v
    printf "`date -u` --" >> $BOOTST_LOG
      echo "Gem has being installed"
      gem -v
    sleep 3
    echo "The following gems will be installed ipaddress, json and net-ssh"
    printf "`date -u` --" >> $BOOTST_LOG
      gem install ipaddress >> $BOOTST_LOG 2>&1
    printf "`date -u` --" >> $BOOTST_LOG
      gem install json >> $BOOTST_LOG 2>&1
    printf "`date -u` --" >> $BOOTST_LOG
      gem install net-ssh >> $BOOTST_LOG 2>&1
    printf "`date -u` -- gems installed" >> $BOOTST_LOG
      echo "gems have being installed"
      gem list
elif [ "$CHECK_RUBY" != "" ] && [ "$CHECK_GEM" == "" ] ; then 
  GEM=`whereis gem | grep -v gem`
  if [ "$GEM" == "" ]; then
    echo "Installing rubygems"  
    printf "`date -u` --" >> $BOOTST_LOG
      apt-get install gem -y >> $BOOTST_LOG 2>&1
  else
    printf "`date -u` --" >> $BOOTST_LOG
      echo "rubygem is already installed"
  fi  
elif [ "$CHECK_RUBY" == "" ] && [ "$CHECK_GEM" != "" ] ; then 
  printf "`date -u` --" >> $BOOTST_LOG
    apt-get install -y ruby-full >> $BOOTST_LOG 2>&1
    sleep 5
  printf "`date -u` --" >> $BOOTST_LOG
    echo "Ruby has being installed"
    ruby -v
elif [ "$CHECK_RUBY" != "" ] && [ "$CHECK_GEM" != "" ]; then
  printf "`date -u` --" >> $BOOTST_LOG
  echo "Dependencies already installed"
    ruby -v
    gem -v
    gem list
  exit 0
else 
  echo "`date -u` -- ERROR Couldnt Determine installation" >> $BOOTST_LOG  
  exit 1 
fi

