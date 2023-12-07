#!/bin/bash

# Create empty .env file
touch .env

# Create generated firebase_options.dart
mv lib/firebase_options.fallback.dart lib/firebase_options.dart