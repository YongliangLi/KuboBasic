
LOCATN=eastus

# Configure host VM using daemonset to disable hugepages
kubectl apply -f resources/hostvm-node-configurer-daemonset.yaml
sleep 2

# Register Azure persistent disks to be used by dyanmically created persistent volumes
sed -e "s/LOCATN/${LOCATN}/g" resources/azure-storageclass.yaml > /tmp/azure-storageclass.yaml
kubectl apply -f /tmp/azure-storageclass.yaml
rm /tmp/azure-storageclass.yaml
sleep 5

# Create keyfile for the MongoD cluster as a Kubernetes shared secret
TMPFILE=$(mktemp)
/usr/bin/openssl rand -base64 741 > $TMPFILE
kubectl create secret generic shared-bootstrap-data --from-file=internal-auth-mongodb-keyfile=$TMPFILE
rm $TMPFILEget

# Create mongodb service with mongod stateful-set
kubectl apply -f resources/mongodb-service.yaml
sleep 5

# Print current deployment state (unlikely to be finished yet)
kubectl get all 
kubectl get persistentvolumes
echo
echo "Keep running the following command until all 'mongod-n' pods are shown as running:  kubectl get all"
echo
