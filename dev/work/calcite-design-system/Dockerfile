# syntax=docker/dockerfile:1

# Container for running StencilJS demos or e2e tests (Puppeteer and Jest)
# This is mostly a workaround for:
# - https://github.com/ionic-team/stencil/issues/3853

# Resources:
# - https://docs.docker.com/language/nodejs/
# - https://docs.docker.com/storage/bind-mounts/
# - https://pptr.dev/troubleshooting#running-on-alpine
# - https://stenciljs.com/docs/testing-config

FROM alpine:3.19.0

WORKDIR /app

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

COPY package*.json ./

RUN apk add --no-cache \
    ca-certificates \
    chromium \
    freetype \
    harfbuzz \
    nodejs \
    npm \
    nss \
    ttf-freefont \
    # Install npm packages
    && npm install \
    # Create non-root user to fix filesystem permission issues
    && addgroup -S runner && adduser -S -G runner runner \
    && mkdir -p /home/runner/Downloads /app \
    && chown -R runner:runner /home/runner \
    && chown -R runner:runner /app

# Run everything after as non-privileged user.
USER runner

# You can test/start/etc directly with these two lines (useful in CI):

#   COPY . .
#   CMD [ "npm", "run", "test:watch" ]

# Or test/start/etc after the image is created (useful for local development):

#   # build the image
#   docker build --tag components .
#
#   # start the dev server
#   docker run --init --interactive --rm --cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) --publish 3333:3333 --name components_start components npm start
#
#   # run the tests and watch for changes
#   docker run --init --interactive --rm --cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) --name components_test components npm run test:watch
#
# NOTE: copying files in't necessary when using a bind mount (e.g. --volume .:/app:z)
# The bind mount allows the test/start npm scripts to rebuild the watched files
# when making changes on your host machine.
