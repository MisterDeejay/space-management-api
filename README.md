# Space Manager API

## Table of contents:

* [Description](./README.md#description)
  * [Task](./README.md#task)
* [Setup](./README.md#setup)
* [Running the app](./README.md#running-the-app)
* [Running the tests](./README.md#running-the-tests)
* [Development notes](./README.md#development-notes)

## Description

This app is a simple API application that responds to endpoints at /stores and /spaces to give clients the ability to manage short term leasing for retail spaces. The endpoint at /stores allows clients to create stores with the following attributes.
    ```
    Store
    # title - String
    # city - String
    # street - String
    # space_count - Integer
    ```
The endpoint at /spaces allows clients to create spaces with the following attributes.
    ```
    Space
    # title - String
    # size - Decimal
    # price_per_day - Decimal
    # price_per_week - Decimal
    # price_per_month - Decimal
    ```

## Task

Your task is to build this part of the API
• Please use Ruby on Rails for the the task
• Please create all CRUD endpoints for stores and spaces
• Store attributes: id (uuid), title, city, street, spaces_count, created_at, updated_at
• Space attributes: id (uuid), store, title, size, price_per_day, price_per_week, price_per_month, created_at, updated_at
• We want to filter the entries via a GET filter for every attribute
• Example: GET /stores?title=like:Center
• Keywords to SQL: eq => =, like => ILIKE, gt => >, lt => <
• Add an endpoint to get a price quote for a space
• GET /spaces/:id/price/:start_date/:end_date
• Have in mind the different prices
• Assume the store is open all days
• A month is 30 days

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

12. To get back a list of all Stores

To get back the bug count by application token

    ```curl http://localhost:3000/bugs?application_token=<application_token>```

12. To get back a specific bug

    ```curl http://localhost:3000/bugs/<bug_number>?application_token=<application_token>```

## Running the tests

    rspec spec/

## Development Notes

* A bug number is automatically assigned to each bug when submitting the params to create a new one. An error is raised if a number is accidentally submitted with the bug. All bug creation submission must include an application token. Bug numbers start at one and increment by one for each additional bug.

* An combo index has been added to the `application_token` and `number` column in the `Bug` table to allow for faster lookup when submitting to /bugs/<bug_number>?application_token=<application_token>

* A redis key-value cache store has been configured to cache request to ``/bugs/count?application_token=<application_token>`. Each time a request is made for a specific `application_token` to the url, the application will use that token as the key checking for the value in the cache. If available it will return that value; otherwise, it will execute a query to find the total number of bugs with that application token, store that value in cache, and finally return it in the response.

* Sidekiq was configured for Bug/State creation. Requests made to /bugs will add a `CreateBugAndStateJob` worker to the queue. This worker uses the `BugCreator` and `StateCreator` class to handle record creation.

* The `ExceptionHandler` class was created to rescue the common errors raised from requests made to the API and return error hashes with descriptive messages.
