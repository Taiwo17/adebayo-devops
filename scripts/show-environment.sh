#!/bin/bash

if [ -z "$APP_ENV" ]; then
  echo "Error: APP_ENV is not set."
  exit 1
fi

echo "Adebayo DevOps Environment"
echo "=========================="
echo "Current environment: $APP_ENV"