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
          NEWVISIBILITY=${OPTARG};;
   esac
done
# Get the repository details to determine its visibility
RESULT=$(gh api repos/"$OWNER"/"$REPO")

# Parse the existing details to show the owner, repository name, and visibility
VISIBILITY=$(echo "$RESULT" | jq -r '.visibility')

echo "Getting Current Values..."
echo "Current Values:"
echo "   Owner: $OWNER"
echo "   Repository: $REPO"
echo "   Visibility: $VISIBILITY"  
echo 


echo "Requested Values:"
echo "   Owner: $OWNER"
echo "   Repository: $REPO"
echo "   Visibility: $NEWVISIBILITY" 
echo 
echo "Getting Current Values..."

# Change the repository visibility to $VISIBILITY
gh api --silent \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/"$OWNER"/"$REPO" \
  -f visibility=$NEWVISIBILITY
echo "...Done."
  
echo "Confirming New Values..."
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
echo "...Done."
  
