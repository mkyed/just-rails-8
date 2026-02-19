FROM ruby:4.0-slim

# Install system dependencies for Rails
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y \
    build-essential curl \
    sqlite3 libsqlite3-dev \
    libvips \
    libyaml-dev \
    libmsgpack-dev \
    git-core \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Rails gem to ensure 'rails' command is available
RUN gem install rails -v '~> 8.1'
RUN gem update rdoc

# Copy the rest of the application code (if any)
COPY . .

# Expose port 3000 for Rails server
EXPOSE 3000

CMD ["just-rails-8/setup.sh"]

