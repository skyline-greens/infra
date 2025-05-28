#!/bin/bash

kubectl delete -f config.yaml
kubectl delete -f db.yaml
kubectl delete -f backend.yaml
kubectl delete -f studio.yaml
kubectl delete -f frontend.yaml
kubectl delete -f ingress.yaml
