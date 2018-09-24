# Space Manager API

## Table of contents:

* [Description](./README.md#description)
  * [Task](./README.md#task)
* [Setup](./README.md#setup)
* [Running the app](./README.md#running-the-app)
* [Running the tests](./README.md#running-the-tests)

## Description

This app is a simple API application that responds to endpoints at /stores and /spaces to give clients the ability to manage short term leasing for retail spaces. The endpoint at /stores allows clients to create stores with the following attributes.

    Store
    # title - String
    # city - String
    # street - String
    # space_count - Integer

The endpoint at /spaces allows clients to create spaces with the following attributes.

    Space
    # title - String
    # size - Decimal
    # price_per_day - Decimal
    # price_per_week - Decimal
    # price_per_month - Decimal

## Task

Your task is to build this part of the API

  * Please use Ruby on Rails for the the task
  * Please create all CRUD endpoints for stores and spaces
  * Store attributes: id (uuid), title, city, street, spaces_count, created_at, updated_at
  * Space attributes: id (uuid), store, title, size, price_per_day, price_per_week, price_per_month, created_at, updated_at
  * We want to filter the entries via a GET filter for every attribute
  * Example: GET /stores?title=like:Center
  * Keywords to SQL: eq => =, like => ILIKE, gt => >, lt => <
  * Add an endpoint to get a price quote for a space
  * GET /spaces/:id/price/:start_date/:end_date
  * Have in mind the different prices
  * Assume the store is open all days
  * A month is 30 days

## Setup

1. Make sure you have Ruby 2.3 installed in your machine. If you need help installing Ruby, take a look at the [official installation guide](https://www.ruby-lang.org/en/documentation/installation/).

2. Install the [bundler gem](http://bundler.io/) by running:

    ```gem install bundler```

3. Clone this repo:

    ```git clone git@github.com:MisterDeejay/space-management-api.git```

4. Change to the app directory:

    ```cd space-management-api```

5. Install dependencies:

    ```bundle install```

## Running the app

6. Start the server

    ```rails s```

7. Create the database

    ```rails db:create db:migrate```

10. To create a new store:

    ```curl -H "Content-Type: application/json" -X POST -d '{"title":"Abc Store","city":"San Francisco","street":"111 Minna St","spaces_count":"20"}' http://localhost:3000/stores```

11. To create a new space for a store:

    ```curl -H "Content-Type: application/json" -X POST -d '{"title":"Elm Space","size":"15","price_per_day":"10.25","price_per_week":"61.50","price_per_month":"287"}' http://localhost:3000/stores/1/spaces```

12. To get back a list of all stores and/or filtered by attribute

    ```curl http://localhost:3000/stores```

    ```curl http://localhost:3000/stores?title=like:Ab```

13. To get a list back of all spaces in a specific store

    ```curl https://localhost:3000/stores/1/spaces```

14. To get a specific store or space back

    ```curl https://localhost:3000/stores/1```

    ```curl https://localhost:3000/stores/1/spaces/1```

15. To update a specific store's attributes

    ```curl -H "Content-Type: application/json" -X PUT -d '{"title":"Abcde Store"}' http://localhost:3000/stores/1```

16. To update a specific space's attributes

    ```curl -H "Content-Type: application/json" -X PUT -d '{"title":"Peach Space"}' http://localhost:3000/stores/1/spaces/1```

17. To delete a specific store and/or space

    ```curl -X DELETE http://localhost:3000/stores/2```

    ```curl -X DELETE http://localhost:3000/stores/1/space/3```

18. To get a price quote back for a specific space

    ```curl http://localhost:3000/stores/1/spaces/2/price/2018-12-01/2019-12-01```

## Running the tests

    rspec spec/
