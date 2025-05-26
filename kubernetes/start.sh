#!/bin/bash

kubectl apply -f config.yaml
kubectl apply -f db.yaml
kubectl apply -f backend.yaml
kubectl apply -f ingress.yaml
