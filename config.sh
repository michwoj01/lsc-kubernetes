curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$(uname -s | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --clientkubectl get nodes

aws eks create-cluster --region us-east-1 --name lsc-cluster --role-arn arn:aws:iam::543856997581:role/LabRole --resources-vpc-config subnetIds=subnet-00cb66674df17e29c,subnet-005aca4a935d60b90,securityGroupIds=sg-078d6b4081268d4a2
aws eks create-nodegroup --cluster-name lsc-cluster --nodegroup-name lsc-ng --node-role arn:aws:iam::543856997581:role/LabRole --subnet subnet-00cb66674df17e29c subnet-005aca4a935d60b90 --instance-types t3.medium --scaling-config minSize=1,maxSize=2,desiredSize=1 --disk-size 20 --ami-type AL2_x86_64
aws eks --region us-east-1 update-kubeconfig --name lsc-cluster

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

helm repo add nfs-ganesha-server-and-external-provisioner https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/
helm install nfs-server-provisioner nfs-ganesha-server-and-external-provisioner/nfs-server-provisioner -f ./nfs-values.yaml

kubectl apply -f ./files/pvc.yaml
kubectl apply -f ./files/deployment.yaml
kubectl apply -f ./files/service.yaml
kubectl apply -f ./files/job.yaml