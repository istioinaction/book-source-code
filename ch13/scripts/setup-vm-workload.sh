sudo mkdir -p /etc/certs
sudo cp "${HOME}"/root-cert.pem /etc/certs/root-cert.pem
sudo  mkdir -p /var/run/secrets/tokens
sudo cp "${HOME}"/istio-token /var/run/secrets/tokens/istio-token
curl -LO https://storage.googleapis.com/istio-release/releases/1.9.3/deb/istio-sidecar.deb
sudo dpkg -i istio-sidecar.deb
sudo cp "${HOME}"/cluster.env /var/lib/istio/envoy/cluster.env
sudo cp "${HOME}"/sidecar.env /var/lib/istio/envoy/sidecar.env
sudo cp "${HOME}"/mesh.yaml /etc/istio/config/mesh
sudo sh -c 'cat $(eval echo ~$SUDO_USER)/hosts >> /etc/hosts'
sudo mkdir -p /etc/istio/proxy
sudo chown -R istio-proxy /var/lib/istio /etc/certs /etc/istio/proxy /etc/istio/config /var/run/secrets /etc/certs/root-cert.pem

# wget https://github.com/istioinaction/book-source-code/raw/master/services/forum/forum-linux-amd64 && chmod +x forum-linux-amd64

# RUN main IN BACKGROUND
# LOCAL_USERS=true ./forum-linux-amd64 &

# START THE SIDECAR
# sudo systemctl start istio
# tail -f /var/log/istio/istio.log 
