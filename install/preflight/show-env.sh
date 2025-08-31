#!/bin/bash

echo "Installation ENV:"
env | grep -E "^(USER|HOME|SETUP_REPO|SETUP_REF)="
