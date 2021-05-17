# Jumpstart Pro Rails Template

All your Rails apps should start off with a bunch of great defaults. It's like Laravel Spark, for Rails.

**Note:** Requires Rails 5.2 or higher

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

First, you'll want to tweak `config/database.yml` and change the
database name. You can also rename the app in the Jumpstart admin UI
which updates the app name in the navbar, footer, etc.

Optionally, you can rename the application name in
`config/application.rb`. This won't affect anything, so it's not too
important.

Next, you can run `bin/setup` to install Rubygem and Javascript dependencies. This will also install foreman system wide for you and setup your database.

#### Running Jumpstart Pro

If you're using foreman: `foreman start`

Otherwise, you'll need to spin up several processes in different
terminals:

```bash
rails server

# Your background workers
sidekiq # or whatever you're using

# Optionally, the webpack dev server for automatically reloading JS and CSS changes
bin/webpack-dev-server

# Stripe requires webhooks for SCA payments
stripe listen --forward-to localhost:5000/webhooks/stripe
```

#### Running with Docker Compose

We include a sample Docker Compose configuration that runs Rails, Postgresql, and Redis for you.

Simply run:
```
docker-compose up
```

Then open http://localhost:5000

#### Running with Docker

If you'd like to run Jumpstart Pro with Docker directly, you can run:

```bash
docker build --tag myapp .
docker run myapp
```
