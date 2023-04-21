#! /bin/bash

# Get the options
while getopts "h:o:r:v:" option; do
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

# Change the repository visibility to $VISIBILITY
gh api --silent \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/"$OWNER"/"$REPO" \
  -f visibility=$VISIBILITY
  
# Get the repository details to determine its visibility
RESULT=$(gh api repos/"$OWNER"/"$REPO")

# Parse the result to show the owner, repository name, and visibility
OWNER=$(echo "$RESULT" | jq -r '.owner.login')
REPO=$(echo "$RESULT" | jq -r '.name')
VISIBILITY=$(echo "$RESULT" | jq -r '.visibility')

echo "New Values:"
echo "   Owner: $OWNER"
echo "   Repository: $REPO"
echo "   Visibility: $VISIBILITY"  
echo "Done."
  
