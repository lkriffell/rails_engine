# Viewing Party

  - This is the base repo for the [Rails Engine](https://backend.turing.io/module3/projects/rails_engine) used for Turing's Backend Module 3.
  - This is the frontend repo: [Rails Driver](https://github.com/lkriffell/rails_driver)
  - This is our completed repo for [Rails Engine](https://github.com/lkriffell/rails_engine/)

### About this Project

  - This application is an api which exposes data for merchants and their items. It makes use of advanced ActiveRecord quiries to return various different endpoints.
  - Rails Driver is the frontend of this project, which holds a spec harness to test call our api.
  - The project description is found [here](https://backend.turing.io/module3/projects/rails_engine/)
  - The project requirements are found [here](https://backend.turing.io/module3/projects/rails_engine/requirements)

### Deployment
  - App is hosted on [Heroku](https://viewing-party-lr-cc.herokuapp.com/)

### Authors
  - **Logan Riffell** - [GitHub](https://github.com/lkriffell)

### Versions

  - Ruby 2.5.3
  - Rails 5.2.4.3

### Schema

  ![Schema](/app/assets/images/schema.png)
  - This project uses a rake task to seed the database from csv files: ```rake seed:csv``` 

## Getting Started

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on how to deploy the project on a live system.

### Installing

A step by step series of examples that tell you how to get a development
env running

## Local Setup

1. Clone [Rails Engine](https://github.com/lkriffell/rails_engine/)

2. Clone [Rails Driver](https://github.com/lkriffell/rails_driver)

2. Install gem packages: `bundle install`

3. Setup the database:
- `rails db:create`
- `rails db:migrate`
- `rake seed:csv` (Run the rake task to import the data from each csv file into the database)

## Running the local tests
1. Be sure you already ran `bundle install`
2. `bundle exec rspec spec/requests/api/v1/merchants` OR `bundle exec rspec spec/requests/api/v1/items`
3. To run all tests at once simply run `bundle exec rspec`

## Running the Spec Harness
1. run the Rails Engine server with `rails s`
2. In a new terminal window cd into Rails Driver and run `bundle exec rspec spec/features/harness_spec.rb`

### Testing Tools
  - Factory Bot
  - Faker
  - RSpec
  - Shoulda-matchers
  - Simplecov
  - Capybara

### Development Tools
  - figaro
  - faraday
  - json
  - fast_jsonapi
  - activerecord-reset-pk-sequence

## Built With
  - Ruby version [2.5.3](https://ruby-doc.org/core-2.5.3/)
  - Ruby on Rails version [5.2.4.3](https://rubygems.org/gems/rails/versions/5.2.4.3)
