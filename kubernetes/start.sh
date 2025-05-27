#!/bin/bash

az aks get-credentials --resource-group verdant-prod --name verdant-prod --overwrite-existing
kubectl apply -f config.yaml
kubectl apply -f db.yaml
kubectl apply -f backend.yaml
kubectl apply -f ingress.yaml
