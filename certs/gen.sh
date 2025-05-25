#!/bin/bash

names=("pi" "mqttx" "backend")

if [ ! -f "$HOME/.step/certs/intermediate_ca.crt" ]; then
    step ca init --deployment-type standalone \
        --name verdant --dns localhost \
        --address 127.0.0.1:443 --provisioner verdantProvisioner
fi

gen_creds () {
    step certificate create "$client" \
        "$client.pem" "$client.key" --ca $HOME/.step/certs/intermediate_ca.crt \
        --ca-key $HOME/.step/secrets/intermediate_ca_key \
        --no-password --insecure --not-after 2400h
}

for client in ${names[@]}; do
    if [ -f "./$client.pem" ] || [ -f "./$client.key" ]; then
        read -p "Override key for $client [y/n]: " ans
        if [ "$ans" != "y" ]; then
            continue
        fi
    fi
    gen_creds
done
