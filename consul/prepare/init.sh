wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://releases.hashicorp.com/consul/1.5.1/consul_1.5.1_linux_amd64.zip
mv cfssl_linux-amd64 cfssl
mv cfssljson_linux-amd64 cfssljson
chmod u+x cfssl*
unzip consul_1.5.1_linux_amd64.zip
chmod u+x consul

./cfssl gencert -initca ca/ca-csr.json | ./cfssljson -bare ca
./cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca/ca-config.json \
  -profile=default \
  ca/consul-csr.json | ./cfssljson -bare consul

GOSSIP_ENCRYPTION_KEY=$(./consul keygen)

echo "gossip-encryption-key: "
echo $GOSSIP_ENCRYPTION_KEY | tr -d "\n " | base64

echo "ca.pem: |"
cat ca.pem | base64

echo "consul.pem: |"
cat consul.pem | base64

echo "consul-key.pem: |"
cat consul-key.pem | base64
