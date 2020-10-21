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
  - App is hosted on [Heroku](https://rails-engine-lr.herokuapp.com/)

### Authors
  - **Logan Riffell** - [GitHub](https://github.com/lkriffell)

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
  
## Endpoints
### Crud Endpoints
#### Items
  1. ```get '/api/v1/items'``` responds with all items currently in the database
  2. ```get '/api/v1/items/:id'``` responds with one item based on it's id
  3. ```post 'api/v1/items'``` creates an item in the database
  4. ```put 'api/v1/items/:id'``` updates an item in the database based on it's id
  5. ```delete 'api/v1/items/:id'``` deletes an item in the database based on it's id
#### Merchants
  1. ```get '/api/v1/merchants'``` responds with all merchants currently in the database
  2. ```get '/api/v1/merchants/:id'``` responds with one merchant based on it's id
  3. ```post 'api/v1/merchants'``` creates a merchant in the database
  4. ```put 'api/v1/merchants/:id'``` updates a merchant in the database based on it's id
  5. ```delete 'api/v1/merchants/:id'``` deletes a merchant in the database based on it's id
### Relationship Endpoints
#### Items
  1. ```get '/api/v1/items/:id/merchant'``` responds with the merchant that sells the item with that id
#### Merchants
  1. ```get '/api/v1/merchants/:id/items'``` responds with a list of items sold by the merchant with that id
### Search Endpoints
#### Items
  1. ```get 'api/v1/item/find?:attribute=:value'``` responds with the item that has the same or similar :value for the specified :attribute
  2. ```get 'api/v1/item/find_all?:attribute=:value'``` responds with all items that have the same or similar :value for the specified :attribute
  - :attributes - name, description, unit_price, merchant_id
#### Merchants
  1. ```get 'api/v1/merchants/find?name=Als+Toy+Barn'``` responds with the merchant that has the same or similar :value for the specified :attribute
  2. ```get 'api/v1/merchants/find_all?name=barn'``` responds with all merchants that have the same or similar :value for the specified :attribute
  - :attributes - name
### Business Endpoints
#### Merchants
  1. ```get 'api/v1/merchants/most_revenue?quantity=2'``` responds with a list of `quantity` size based on the merchants with the most revenue
  2. ```get 'api/v1/merchants/most_items?quantity=2'``` responds with a list of `quantity` size based on the merchants with the most items succsessfully sold
  3. ```get 'api/v1/revenue?start=2020-10-20&end=2020-10-23'``` responds with the total revenue earned by all merchants within the dates specified
  4. ```get 'api/v1/merchants/:id/revenue'``` responds with the total revenue of one merchant based on the id
