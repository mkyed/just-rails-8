# JustRails8

JustRails8 is a minimal, vanilla Rails 8 development environment designed to get you up and running quickly with Docker Compose. It provides a clean Rails 8 setup in a containerized environment, allowing you to edit files locally with your favorite editor and start the app with a simple `docker compose up`. This project is ideal for starting new Rails 8 projects or experimenting with Rails 8 in a lightweight, reproducible setup.

## Purpose

The goal of JustRails8 is simplicity and flexibility:
- **Vanilla Rails 8**: A fresh Rails 8 app with no extra gems or configurations beyond SQLite3 as the database.
- **Dockerized Development**: Run your Rails app in a Docker container, mapping local files for seamless editing.
- **Quick Start**: Spin up the environment with `docker compose up` and start coding.
- **Clean Slate**: Use this as a starting point for new projects, with no baggage from previous setups.

This repository is distributed as a public GitHub template ([mkyed/just-rails-8](https://github.com/mkyed/just-rails-8)) to help developers bootstrap new Rails 8 projects. It’s meant to be cloned or copied as the foundation for your own project, not as a dependency or ongoing upstream source. After cloning, you’ll reset the Git connection to start with a fresh repository.

## Prerequisites

Before using JustRails8, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/) (with Docker Compose)
- [Git](https://git-scm.com/downloads)
- Your preferred code editor (e.g., VS Code, RubyMine, or Vim)

## Getting Started

Follow these steps to set up and run JustRails8:

1. **Clone the Repository**
   - Clone the JustRails8 repository from [mkyed/just-rails-8](https://github.com/mkyed/just-rails-8):
     ```bash
     git clone https://github.com/mkyed/just-rails-8 my-rails-project
     cd my-rails-project
     ```
   - Alternatively, use GitHub’s “Use this template” button to create a new repository based on JustRails8, or fork it.

2. **Reset the Git Connection**
   - JustRails8 is a template for new projects, so you should initialize a new Git repository to avoid tracking the original repo. Run the following commands to reset the Git history:
     ```bash
     rm -rf .git
     git init
     git add .
     git commit -m "Initial commit"
     ```
   - This creates a fresh Git repository for your project, disconnected from `mkyed/just-rails-8`. You can now push to your own remote repository (e.g., on GitHub):
     ```bash
     git remote add origin <your-new-repo-url>
     git push -u origin main
     ```

3. **Start the Docker Environment**
   - Run the following command to build and start the Rails 8 app in a Docker container:
     ```bash
     docker compose up
     ```
   - This command:
     - Builds the Docker image using `Dockerfile.dev` (based on Ruby 3.3, with Rails 8 and dependencies pre-installed).
     - Creates a fresh Rails 8 app (if none exists) using SQLite3.
     - Sets up the database with `rails db:setup`.
     - Starts the Rails server on port `3008` (mapped to `3000` inside the container).

4. **Access the App**
   - Open your browser and navigate to `http://localhost:3008` to see the Rails welcome page.
   - The app is now running, and you can start developing!

5. **Edit Files Locally**
   - The project directory is mounted as a volume (`./:/app` in `docker-compose.yml`), so changes made locally with your editor are instantly reflected in the container.
   - Example: Modify `app/controllers/application_controller.rb` or add new models in `app/models/`.

6. **Stop the App**
   - To stop the containers, press `Ctrl+C` in the terminal running `docker compose up`, or run:
     ```bash
     docker compose down
     ```

## Project Structure

Key files in JustRails8:

- **`docker-compose.yml`**: Defines the Docker Compose service for the Rails app, including volumes for the app code, Ruby gems, and SQLite database, and maps port `3008` to `3000`.
- **`Dockerfile.dev`**: Configures the development Docker image with Ruby 3.3, Rails 8, and necessary system dependencies (e.g., SQLite3, Node.js, Yarn).
- **`just-rails-8/setup.sh`**: Initializes a new Rails 8 app (if none exists) with SQLite3 and starts the server. Run automatically by `docker compose up`.
- **`just-rails-8/reset.sh`**: Cleans up Docker resources (images, volumes, networks) for debugging or resetting the environment. Optional flags:
  - `--clean-git` or `-cg`: Removes Git-related files (use with caution).
  - `--verbose` or `-v`: Shows detailed output.
  - `--help` or `-h`: Displays usage information.
  - Example:
    ```bash
    ./just-rails-8/reset.sh --verbose
    ```

## Usage Tips

- **Customizing the Rails App**: After the initial setup, the Rails app is generated in the project directory. Modify it as you would any Rails app (e.g., add gems to `Gemfile`, create controllers, or update routes).
- **Rebuilding the Image**: If you modify `Dockerfile.dev` or encounter issues, reset the environment:
     ```bash
     ./just-rails-8/reset.sh
     docker compose up --build
     ```
- **Port Conflicts**: If port `3008` is in use, edit `docker-compose.yml` to map a different host port (e.g., `3010:3000`).
- **Database Persistence**: The SQLite database is stored in the `db_data` volume, so it persists between container restarts. To start fresh, reset with `./just-rails-8/reset.sh`.

## Why Reset the Git Connection?

JustRails8 is designed as a template for new projects, not a library or dependency. By resetting the Git connection after cloning from [mkyed/just-rails-8](https://github.com/mkyed/just-rails-8), you can:
- Start with a clean Git history.
- Customize the setup without tracking upstream changes.
- Own the project fully, using JustRails8 as a springboard for your Rails 8 development.

The original repository is provided as a reference, but your project should have its own Git repository to maintain independence.

## Contributing

Since JustRails8 is a minimal template, contributions are not expected. However, if you have ideas for improving the setup, feel free to fork the repository and share your enhancements in your own projects!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
