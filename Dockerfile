FROM ruby:3.3-slim

# Install system dependencies for Rails and SQLite3
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock to install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 for Rails server
EXPOSE 3000

# Start the Rails server with live reloading
CMD ["bin/dev"]
