kubectl create -n istioinaction secret tls simple-sni-1.istioinaction.io \
--key simple-sni-1/3_application/private/simple-sni-1.istioinaction.io.key.pem  \
--cert simple-sni-1/3_application/certs/simple-sni-1.istioinaction.io.cert.pem

kubectl create -n istioinaction secret tls simple-sni-2.istioinaction.io \
--key simple-sni-2/3_application/private/simple-sni-2.istioinaction.io.key.pem  \
--cert simple-sni-2/3_application/certs/simple-sni-2.istioinaction.io.cert.pem