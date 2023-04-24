#! /bin/bash



################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: $0 [-h|o <ORG>|p <PERMISSION>]"
   echo "options:"
   echo "h               Print this Help."
   echo "o <ORG>         List for the Organization <ORG>."
   echo "p <PERMISSION>  List for the permission ADMIN, READ or WRITE."
   echo
}

# Get the options
while getopts "hp:o:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      p)  
          PERMISSION=${OPTARG}
          ;;    
      o)
          OWNER=${OPTARG}
          ;;

   esac
done

echo "Job Started: Get Repos and their Members with Permission: $PERMISSION in org $OWNER"
echo 
    
gh api graphql -F owner="$OWNER" -f query='
query($owner: String!) {
  organization(login: $owner) {
    login
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
' | jq --arg perm "$PERMISSION" '.data.organization.repositories.nodes[] | .name as $name | [.collaborators.nodes, .collaborators.edges] | transpose | map({login: .[0].login, organizationVerifiedDomainEmails: .[0].organizationVerifiedDomainEmails, permission: .[1].permission}) | [.[] | select(.permission==$perm)] | {name: $name, collaborators_with_admin: .}'

echo " ...Done."
echo 

echo "Job Finished: Get Repos and their Members with Permission: $PERMISSION in org $OWNER"

  
