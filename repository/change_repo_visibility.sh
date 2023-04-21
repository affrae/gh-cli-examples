#! /bin/bash

# Get the options
while getopts ":h:o:r:v" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      o)
          OWNER=${OPTARG};;
      r)
          REPO=${OPTARG};;
      v)
          VISIBILITY=${OPTARG};;
   esac
done

echo "OWNER=$OWNER"
echo "REPO=$REPO"
echo "VISIBILITY=$VISIBILITY"

gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$OWNER/$REPO \
  -f visibility=$VISIBILITY
