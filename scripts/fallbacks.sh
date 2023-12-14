#!/bin/bash

# Create empty .env file
cp fallback.env .env

# Create generated firebase_options.dart
cp lib/firebase_options.fallback.dart lib/firebase_options.dart