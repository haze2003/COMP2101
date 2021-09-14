#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable
oldhostname=$(hostname)

# Tell the user what the current hostname is in a human friendly way
echo "This computer's current hostname is: $oldhostname"

# Ask for the user's student number using the read command
read -p "Please enter your student number: " studentnum

# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
newhostname=pc$studentnum

# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
# tell the user you did that
grep $newhostname /etc/hosts >/dev/null && (echo "Current hostname already set in /etc/hosts.")
test $? -gt 0 &&
sudo sed -i "s/$oldhostname/$newhostname/" /etc/hosts && echo "Updating hostname to $newhostname in /etc/hosts file..."

# If that hostname is not the current hostname, change it using the hostnamectl command and
# tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
currenthctl=$(hostnamectl | grep "Static" | sed s/"   "/""/ | cut -d" " -f3)
test $currenthctl = $newhostname && (echo "Static hostname already set in hostnamectl, nothing to do.") && exit
test $currenthctl = $newhostname || (sudo hostnamectl set-hostname $newhostname) &&
echo "Static hostname updated. Hostname is now set to: $newhostname. Please reboot to ensure hostname persistance."
