#!/bin/bash

# suspenduser--Suspends a user account for the indefinite future

# Source: Wicked Cool Shell Scripts - 2E 2015
# Script 41

homedir="/home"
secs=10

if [ -z $1 ] ; then
	echo "Usage: $0 account" >&2
	exit 1
elif [ "$(id -un)" != "root" ] ; then
	echo "Error. You must be 'root' to run this command." >&2
	exit 1
fi

echo "Please change the password for account $1 to something new."
passwd $1

# Now let's see if they're logged in and, if so, boot them.

if who|grep "$1" > /dev/null ; then

	for tty in $(who | grep $1 | awk '{ print $2 }'); do

		cat << "EOF" > /dev/$tty

*********************************************************************
URGENT NOTICE FROM THE ADMINISTRATOR:

This account is being suspended, and you are going to be logged out
in $secs seconds. Please immediately shut down any processes you
have running and log out.

If you have any questions, please contact your supervisor.
**********************************************************************
EOF
	done

	echo "(Warned $1, now sleeping $secs seconds)"

	sleep $secs

	jobs=$(ps -u $1 | cut -d\	 -f1)

	kill -s HUP $jobs					# Send hangup sig to their processes
	sleep 1   							# Give it a second...
	kill -s KILL $jobs > /dev/null 2>1  # and kill anything left

	echo "$1 was logged in. Just logged them out."
fi

# Finally, let's close off their home directory from prying eyes.
chmod 000 $homedir/$1

echo "Account $1 has been suspended."

exit 0