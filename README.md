# JustRails8

JustRails8 is a minimal, vanilla Rails 8 development environment designed to get you up and running quickly with Docker Compose. It provides a clean Rails 8 setup in a containerized environment, allowing you to edit files locally with your favorite editor and start the app with a simple `docker compose up`. This project is ideal for starting new Rails 8 projects or experimenting with Rails 8 in Galleys lightweight, reproducible setup.

## Purpose

The goal of JustRails8 is simplicity and flexibility:
- **Vanilla Rails 8**: A fresh Rails 8 app with no extra gems or configurations beyond SQLite3 as the database.
- **Dockerized Development**: Run your Rails app in a Docker container, mapping local files for seamless editing.
- **Quick Start**: Spin up the environment with `docker compose up` and start coding.
- **Clean Slate**: Use this as a starting point for new projects, with no baggage from previous setups.

This repository is distributed as a public GitHub template to help developers bootstrap new Rails 8 projects. The original repository (`mkyed/just-rails-8`) is not linked here because JustRails8 is meant to be forked or copied as the foundation for your own project, not as a dependency or ongoing upstream source.

## Prerequisites

Before using JustRails8, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/) (with Docker Compose)
- [Git](https://git-scm.com/downloads)
- Your preferred code editor (e.g., VS Code, RubyMine, or Vim)

## Getting Started

Follow these steps to set up and run JustRails8:

1. **Clone or Copy the Repository**
   - If using GitHub, click the "Use this template" button to create a new repository based on JustRails8, or fork it.
   - Alternatively, download the project files and place them in a new directory.
   - Example:
     ```bash
     git clone <your-new-repo-url> my-rails-project
     cd my-rails-project
     ```

   **Note**: This project is not linked to the original `mkyed/just-rails-8` repository. It’s designed to be a starting point for your own project, so you should initialize a new Git repository after copying the files:
     ```bash
     rm -rf .git
     git init
     git add .
     git commit -m "Initial commit"
     ```

2. **Start the Docker Environment**
   - Run the following command to build and start the Rails 8 app in a Docker container:
     ```bash
     docker compose up
     ```
   - This command:
     - Builds the Docker image using `Dockerfile.dev` (based on Ruby 3.3, with Rails 8 and dependencies pre-installed).
     - Creates a fresh Rails 8 app (if none exists) using SQLite3.
     - Sets up the database with `rails db:setup`.
     - Starts the Rails server on port `3008` (mapped to `3000` inside the container).

3. **Access the App**
   - Open your browser and navigate to `http://localhost:3008` to see the Rails welcome page.
   - The app is now running, and you can start developing!

4. **Edit Files Locally**
   - The project directory is mounted as a volume (`./:/app` in `docker-compose.yml`), so changes made locally with your editor are instantly reflected in the container.
   - Example: Modify `app/controllers/application_controller.rb` or add new models in `app/models/`.

5. **Stop the App**
   - To stop the containers, press `Ctrl+C` in the terminal running `docker compose up`, or run:
     ```bash
     docker compose down
     ```

## Project Structure

Key files in JustRails8:

- **`docker-compose.yml`**: Defines the Docker Compose service for the Rails app, including volumes for the app code, Ruby gems, and SQLite database, and maps port `3008` to `3000`.
- **`Dockerfile.dev`**: Configures the development Docker image with Ruby 3.3, Rails 8, and necessary system dependencies (e.g., SQLite3, Node.js, Yarn).
- **`bin/just-rails-8-setup.sh`**: Initializes a new Rails 8 app (if none exists) with SQLite3 and starts the server. Run automatically by `docker compose up`.
- **`bin/just-rails-8-reset.sh`**: Cleans up Docker resources (images, volumes, networks) for debugging or resetting the environment. Optional flags:
  - `--clean-git` or `-cg`: Removes Git-related files (use with caution).
  - `--verbose` or `-v`: Shows detailed output.
  - `--help` or `-h`: Displays usage information.
  - Example:
    ```bash
    ./bin/just-rails-8-reset.sh --verbose
    ```

## Usage Tips

- **Customizing the Rails App**: After the initial setup, the Rails app is generated in the project directory. Modify it as you would any Rails app (e.g., add gems to `Gemfile`, create controllers, or update routes).
- **Rebuilding the Image**: If you modify `Dockerfile.dev` or encounter issues, reset the environment:
  ```bash
  ./bin/just-rails-8-reset.sh
  docker compose up --build
