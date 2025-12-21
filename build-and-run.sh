#!/bin/bash

# Social Media Marketing - Build and Run Script
# This script builds the Flutter web app and starts all services with Docker Compose

set -e  # Exit on error

echo "========================================="
echo "Social Media Marketing - Build & Deploy"
echo "========================================="
echo ""

# Step 1: Build Flutter Web App
echo "[1/4] Building Flutter Web App..."
cd social_media_marketing_flutter
flutter build web --release
cd ..
echo "✓ Flutter web app built successfully"
echo ""

# Step 2: Stop any running containers
echo "[2/4] Stopping existing containers..."
docker compose down
echo "✓ Containers stopped"
echo ""

# Step 3: Build Docker images
echo "[3/4] Building Docker images..."
docker compose build
echo "✓ Docker images built successfully"
echo ""

# Step 4: Start all services
echo "[4/4] Starting services..."
docker compose up -d
echo "✓ All services started"
echo ""

# Wait for services to be healthy
echo "Waiting for services to be ready..."
sleep 10

# Show status
echo ""
echo "========================================="
echo "Deployment Status"
echo "========================================="
docker compose ps
echo ""

# Show access URLs
echo "========================================="
echo "Access URLs"
echo "========================================="
echo "Frontend (Flutter Web): http://localhost:4129"
echo "Backend API:            http://localhost:8080"
echo "Backend Insights:       http://localhost:8081"
echo "Database:               localhost:8090"
echo ""
echo "========================================="
echo "Logs"
echo "========================================="
echo "View all logs:       docker compose logs -f"
echo "View frontend logs:  docker compose logs -f frontend"
echo "View backend logs:   docker compose logs -f backend"
echo "View database logs:  docker compose logs -f postgres"
echo ""
echo "========================================="
echo "Management Commands"
echo "========================================="
echo "Stop all services:   docker compose down"
echo "Restart services:    docker compose restart"
echo "View status:         docker compose ps"
echo ""
echo "✅ Deployment complete! Open http://localhost:4129 in your browser"
