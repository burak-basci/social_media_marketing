# Social Media Marketing Platform

This project is an AI-powered social media marketing platform designed to help businesses create, schedule, and publish content across multiple social media platforms with ease. It leverages Google Gemini for content generation and is built with a modern Dart and Flutter stack.

## Key Features

-   **AI-Powered Content Generation**: Utilizes Google Gemini to generate engaging and platform-specific content for social media campaigns.
-   **Multi-Platform Support**: Create content for X (Twitter), LinkedIn, Instagram, Facebook, and Pinterest.
-   **Campaign Management**: A wizard-style interface to guide users through the process of creating a new marketing campaign.
-   **Brand and Product Context**: Manage company profiles and products to provide the AI with the right context for content generation.
-   **Scheduling and Publishing**: Schedule posts and publish them to various social media platforms through a self-hosted Postiz instance.
-   **AI Interaction Logging**: Keep track of all interactions with the Gemini API, including prompts, responses, and token usage.
-   **Dockerized Environment**: The entire application is containerized for easy setup and deployment.

## Tech Stack

-   **Frontend**: Flutter Web
-   **Backend**: Serverpod (Dart)
-   **Database**: PostgreSQL with pgvector for vector similarity search
-   **AI**: Google Gemini
-   **Publishing**: Postiz
-   **Deployment**: Docker

## Project Structure

The project is a monorepo containing three main components:

-   `social_media_marketing_server/`: The Serverpod backend that powers the application. It includes all the API endpoints, services for interacting with Gemini and Postiz, and database models.
-   `social_media_marketing_flutter/`: The Flutter web application that provides the user interface for the platform.
-   `social_media_marketing_client/`: An auto-generated client library that facilitates type-safe communication between the Flutter app and the Serverpod backend.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

-   [Docker](https://docs.docker.com/get-docker/)
-   [Flutter](https://docs.flutter.dev/get-started/install)

You will also need to:

1.  **Set up your own Postiz instance**: This project does not come with its own Postiz instance. You will need to deploy and run your own. For more information on Postiz, please refer to its official documentation.
2.  **Obtain a Google Gemini API Key**: The AI-powered features of this application rely on the Google Gemini API. You will need to obtain an API key from the [Google AI Studio](https://aistudio.google.com/).

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/burak-basci/social_media_marketing.git
    cd social_media_marketing
    ```

2.  **Create an environment file for the backend**:

    Navigate to the `social_media_marketing_server` directory and create a `.env` file from the example:

    ```bash
    cp social_media_marketing_server/.env.example social_media_marketing_server/.env
    ```

    Now, edit the `social_media_marketing_server/.env` file and add your `GEMINI_API_KEY`.

3.  **Build and run the application**:

    The easiest way to get started is to use the provided build script. This script will build the Flutter web app and start all the services using Docker Compose.

    ```bash
    ./build-and-run.sh
    ```

4.  **Apply database migrations**:

    The first time you start the application, the database will be empty. You need to apply the initial migrations to create the necessary tables.

    ```bash
    docker compose exec backend dart run bin/main.dart --apply-migrations
    ```

## Access URLs

Once the application is running, you can access the different parts of the system at the following URLs:

-   **Frontend (Flutter Web)**: http://localhost:4129
-   **Backend API**: http://localhost:8080
-   **Backend Insights (Serverpod)**: http://localhost:8081
-   **Database (PostgreSQL)**: `localhost:8090`

## Management Commands

You can manage the application using the following Docker Compose commands:

-   **View logs**: `docker compose logs -f`
-   **Stop all services**: `docker compose down`
-   **Restart services**: `docker compose restart`
-   **View status**: `docker compose ps`
