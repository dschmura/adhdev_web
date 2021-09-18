# Jumpstart Pro Rails Template

All your Rails apps should start off with a bunch of great defaults.

## Getting Started

Jumpstart Pro is a preconfigured Rails application, so you can either
download the code or clone this repository and add your own repo as a
remote to merge in updates.

#### Requirements

You'll need the following installed to run the template successfully:

* Ruby 3.0 or higher
* bundler - `gem install bundler`
* Redis - For ActionCable support (and Sidekiq, caching, etc)
* PostgreSQL - `brew install postgresql`
* Imagemagick - `brew install imagemagick`
* Yarn - `brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)
* Foreman (optional) - `gem install foreman` - helps run all your
  processes in development
* [Stripe CLI](https://stripe.com/docs/stripe-cli) for Stripe webhooks in development - `brew install stripe/stripe-cli/stripe`

#### Initial Setup

First, edit `config/database.yml` and change the database name.

Next, run `bin/setup` to install Rubygem and Javascript dependencies. This will also install foreman system wide for you and setup your database.

```bash
bin/setup
```

Optionally, you can rename the application name in `config/application.rb`. This won't affect anything, so it's not too important.

You can also rename the app in the Jumpstart config UI which updates the app name in the navbar, footer, etc.

#### Running Jumpstart Pro

To run your application, you'll use the `bin/dev` command:

```bash
bin/dev
```

This starts up Foreman running the Procfile.dev config.

We've configured this to run the Rails server, CSS bundling, and JS bundling out of the box. You can add background workers like Sidekiq, the Stripe CLI, etc to have them run at the same time.

#### Windows Support

If you'd like to run Jumpstart Pro on Windows, we recommend using WSL2. You can find instructions here: https://gorails.com/setup/windows

Alternatively, if you'd like to use Docker on Windows, you'll need to make sure you clone the repository and preserve the Linux line endings.

```bash
git clone git@github.com:username/myrepo.git --config core.autocrlf=input
```

#### Running with Docker Compose

We include a sample Docker Compose configuration that runs Rails, Postgresql, and Redis for you.

Simply run:
```
docker-compose up
```

Then open http://localhost:3000

#### Running with Docker

If you'd like to run Jumpstart Pro with Docker directly, you can run:

```bash
docker build --tag myapp .
docker run myapp
```
