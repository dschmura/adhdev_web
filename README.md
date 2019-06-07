# Jumpstart Pro Rails Template

All your Rails apps should start off with a bunch of great defaults. It's like Laravel Spark, for Rails.

**Note:** Requires Rails 5.2 or higher

## Getting Started

Jumpstart Pro is a preconfigured Rails application, so you can either
download the code or clone this repository and add your own repo as a
remote to merge in updates.

#### Requirements

You'll need the following installed to run the template successfully:

* Ruby 2.6 or higher
* bundler - `gem install bundler`
* Redis - For ActionCable support (and Sidekiq, caching, etc)
* PostgreSQL -
* Yarn - `brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)
* Foreman (optional) - `gem install foreman` - helps run all your
  processes in development

#### Initial Setup

First, you'll want to tweak `config/database.yml` and rename `jumpstart`
anywhere to the name of your app.

Next, you can run `bin/setup` to install Rubygem and Javascript dependencies. This will also install foreman system wide for you and setup your database.

#### Running Jumpstart Pro

If you're using foreman: `foreman start`

Otherwise, you'll need to spin up several processes in different
terminals:

```bash
rails server

# Your background workers
sidekiq # or whatever you're using

# Optionally, the webpack dev server for automatically reloading JS and
CSS changes
bin/webpack-dev-server
```
