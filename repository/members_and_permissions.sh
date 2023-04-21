#! /bin/bash

# gh api graphql -F owner='$OWNER' -f query='
# query($owner: String!) {
#   organization(login: $owner) {
#     repositories(first: 100) {
#       nodes {
#         name
#         collaborators(first: 100) {
#           nodes {
#             login
#             organizationVerifiedDomainEmails(login: $owner)
#           }
#           edges {
#             permission
#           }
#         }
#       }
#     }
#   }
# }
# '

# Get the options
while getopts "h:o:r:v:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      o)
          OWNER=${OPTARG};;
   esac
done

echo "Job Started: Get Repos and their Admins in org $OWNER"
echo 
    
gh api graphql -F owner="$OWNER" -f query='
query($owner: String!) {
  organization(login: $owner) {
    repositories(first: 100) {
      nodes {
        name
        collaborators(first: 100) {
          nodes {
            login
            organizationVerifiedDomainEmails(login: $owner)
          }
          edges {
            permission
          }
        }
      }
    }
  }
}
'

echo " ...Done."
echo 

echo "Job Started: Get Repos and their Admins in org $OWNER"

  
