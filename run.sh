#!/bin/bash
set -e

CERT_DIR=/data/ssl
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/key.pem" ] || [ ! -f "$CERT_DIR/cert.pem" ]; then
  echo "Generating new self-signed SSL certificate..."
  openssl req -nodes -new -x509 -days 3650 \
    -keyout "$CERT_DIR/key.pem" \
    -out "$CERT_DIR/cert.pem" \
    -subj "/C=IN/ST=NA/L=NA/O=NareshEnterprises/CN=vdoninja.local"
else
  echo "Using existing SSL certificate from /data/ssl"
fi

cp "$CERT_DIR/cert.pem" /app/vdo.ninja/cert.pem

export KEY_PATH="$CERT_DIR/key.pem"
export CERT_PATH="$CERT_DIR/cert.pem"
export PORT=8443

cd /app/webserver
exec node server.js
