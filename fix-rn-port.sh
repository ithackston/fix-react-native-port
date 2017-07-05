#! /bin/bash

while getopts o:p:d: option
do
  case "${option}" in
  o) OLDPORT=${OPTARG};;
  p) NEWPORT=${OPTARG};;
  d) DIRECTORY=${OPTARG};;
  esac
done

if [ -z $NEWPORT ]
then
  echo "usage: fix-rn-port.sh -p <new-port> [-o <old-port>] [-d <directory>]"
  echo ""
  echo "Replaces the packager port used by React Native IOS."
  echo ""
  echo "required arguments:"
  echo "  -p    replacement port number"
  echo ""
  echo "optional arguments:"
  echo "  -o    the port number to replace (default 8081)"
  echo "  -d    the directory to search (default current directory)"
  exit 1
fi

if [ -z $OLDPORT ]
then
  OLDPORT=8081
fi

if [ -z $DIRECTORY ]
then
  DIRECTORY="."
fi

if [ -e $DIRECTORY ]
then
  FILES=(
    "RCTWebSocketExecutor.m"
    "RCTBridgeDelegate.h"
    "RCTBundleURLProvider.m"
    "RCTPackagerConnection.m"
  )
  
  echo -e "Searching for port $OLDPORT in '$DIRECTORY'."
  
  for FILENAME in "${FILES[@]}"
  do
    echo -e "\n-   Replacing port $OLDPORT with $NEWPORT in $FILENAME..."
    find $DIRECTORY -name $FILENAME -exec sed -i.tmp "s/$OLDPORT/$NEWPORT/" '{}' \;
    find $DIRECTORY -name $FILENAME -exec grep -n $NEWPORT '{}' \;
  done

  echo -e "\n-   Replacing port $OLDPORT with $NEWPORT in React.xcodeproj build script..."
  find $DIRECTORY -name project.pbxproj -path *React.xcodeproj* -exec sed -i.tmp "s/$OLDPORT/$NEWPORT/" '{}' \;
  find $DIRECTORY -name project.pbxproj -path *React.xcodeproj* -exec grep -n $NEWPORT '{}' /dev/null \;
else
  echo "The specified directory $DIRECTORY does not exist."
fi

