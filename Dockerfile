# Use the official lightweight Ruby image.
# https://hub.docker.com/_/ruby
FROM ruby:2.7-slim

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true

RUN apt-get update && apt-get install -y \
    build-essential

RUN gem install bundler && bundle install --without test

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD ["ruby", "./app.rb"]

