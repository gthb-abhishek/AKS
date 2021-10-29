curl -sL https://run.linkerd.io/install | sh
user=`whoami`
export PATH=$PATH:/home/$user/.linkerd2/bin

#generate root CA certifcate 
step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure

#Generate CA certificate and key for 10 years
step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 87600h --no-password --insecure --ca ca.crt --ca-key ca.key

#Deploy LinkerD on AKS
linkerd install --identity-trust-anchors-file ca.crt --identity-issuer-certificate-file issuer.crt --identity-issuer-key-file issuer.key | kubectl apply -f -

#Validate LinkerD
 linkerd check
