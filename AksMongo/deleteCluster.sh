
if [ "$#" -ne 1 ]; then 
    echo "please specify resource group name"
    echo "usage: ./deleteCluster groupName"
    exit 1
fi

GROUPNAME=$1

echo "Deleting group $GROUPNAME ..." 
az group delete --name $GROUPNAME --yes --no-wait