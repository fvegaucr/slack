#!/bin/bash
PACKAGE=$1
ACTION=$2
NOTIFY=$3
HOST=$4

CHECK_INSTALL='`ssh $HOST "whereis $PACKAGE | cut -d : -f2"`' 
INSTALL=`ssh '$HOST' "sudo apt-get install $PACKAGE -y"`
REMOVE=`ssh $HOST "sudo apt-get remove $PACKAGE -y"`
REMINSTLOG="../var/remote_installer_sh.log"
FILE_APP="../files/index.php"
RESTART=`ssh $HOST "service $PACKAGE restart"`

if [ "$ACTION" == "install" ] ; then
  echo "Starting Installation"
  echo ' '`date -u`' -- "install" Option selected' >> $REMINSTLOG
  if [ "$CHECK_INSTALL" == "" ]; then
    if [ "$PACKAGE" == "apache2" ]; then
      echo "Package $PACKAGE is not installed $HOST"
        echo ''`date -u`' -- Package '$PACKAGE' is not installed '$HOST''
      echo "Installing $PACKAGE in $HOST"
        echo ''`date -u`' -- Installing '$PACKAGE' in '$HOST''
      echo "========================================="
      echo "$INSTALL"
      `ssh $HOST "apt-get install -y libapache2-mod-php"`
      echo "$PACKAGE has being installed in $HOST"
      echo "Installing app"
        `scp $FILE_APP $HOST:/var/www/html/`
	`ls -la /var/www/html/`
	sleep 2
        echo "$RESTART"
    else
      echo "Package $PACKAGE is not installed $HOST"
        echo ''`date -u`' -- Package '$PACKAGE' is not installed '$HOST''
      echo "Installing $PACKAGE in $HOST"
        echo ''`date -u`' -- Installing '$PACKAGE' in '$HOST''
      echo "========================================="
      echo "$INSTALL"
      echo "$PACKAGE has being installed in $HOST"
    fi
  else
    echo "Package $PACKAGE already install in $HOST"
    REMOTEFILE=`ssh $HOST "ls /var/www/html | grep index.html"`
    if [ "$REMOTEFILE" == "index.html" ] ; then
      `scp $FILE_APP $HOST:/var/www/html/`
       `ssh $HOST "rm -rf /var/www/html/index.html"`
       echo "$RESTART"
    fi
      echo ''`date -u`' -- Package '$PACKAGE' already install in '$HOST''
    exit 0
  fi
elif [ "$ACTION" == "remove" ]; then
  echo ' '`date -u`' -- "remove" Option selected' >> $REMINSTLOG
  if [ "$CHECK_INSTALL" != "" ]; then
    if [ "$PACKAGE" == "apache2" ] ; then
      echo "Removing package $PACKAGE from $HOST"
      echo ''`date -u`' -- Removing '$PACKAGE' from '$HOST''
      echo "========================================="
      echo $REMOVE
      `ssh $HOST "rm -rf /var/www/html/*"`
      echo $RESTART 
      echo "$PACKAGE removed from $HOST"
    else
      echo "Removing package $PACKAGE from $HOST"
      echo ''`date -u`' -- Removing '$PACKAGE' from '$HOST''
      echo "========================================="
      echo $REMOVE
      echo "$PACKAGE removed from $HOST"
    fi
  else
    echo "Package $PACKAGE alredy uninstalled in $HOST"
    echo ''`date -u`' -- Package '$PACKAGE' already uninstalled in '$HOST''
    exit 0
  fi
else
  echo ' '`date -u`' -- "action" Option not Selected' >> $REMINSTLOG
  echo '"action" Option not Selected'
  echo 'Available Options "install/remove"'
  exit 1
fi
