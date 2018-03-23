#!/bin/sh
##
# Script to deploy a Kubernetes project with a StatefulSet running a MongoDB Replica Set, to Azure ACS.
##

# Set the location to deploy to - run the following to see list of available locations: $ az account list-locations
GROUPNAME=mongodcA
CLUSTERNAME=mongoclusterA
LOCATN=eastus
NODECOUNT=3

# Create an Azure resource group (to hold collection of related assets)
echo "Creating Azure group"
az group create --name $GROUPNAME --location $LOCATN

# Create a new Azure Kubernetes cluster with one Linux master node and just
# one Linux agent node (to keep under free account quote maximum of 4 cores),
echo "Creating AKS Kubernetes orchestrator"
az aks create --resource-group $GROUPNAME --name $CLUSTERNAME --node-count $NODECOUNT --generate-ssh-keys

echo "Sleeping for 90 seconds before attempting to get credentials"
sleep 90

#sudo az aks install-cli
az aks get-credentials --resource-group $GROUPNAME --name $CLUSTERNAME

