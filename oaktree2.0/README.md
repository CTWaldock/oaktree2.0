# Budget Management System
  This Rails application allows users to create budgets in order to keep track of their expenses for specific projects or monthly expenditure. Users can sign up through a Devise-based user authentication system or login via GitHub and proceed to their home page in order to create new budgets with specifications on start date, end date, limits, and categories. Users can then add specific expenses to their categories and obtain a breakdown regarding their expenditure by category, most expensive purchases, most recent purchases, and daily spending average, etc. The back-end of this application utilizes the Ruby on Rails framework and uses PostgreSQL as the database for production. The front-end of this application uses the Bootstrap framework for styling purposes and borrows the Superhero theme from Bootswatch. The project includes a test suite that employs RSpec and Capybara for feature and unit testing purposes.

## Host on Local Environment
Clone this directory to your local environment and execute:
```
 $ bundle install

 $ rake db:migrate

 $ rails s
```

You should now be able to sign up, log in, create budgets, and add expenses.

## Demo

You can see a demo of this project [here](https://budget-management-system.herokuapp.com/) hosted via Heroku. An example account is included -- just log in.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viparthasarathy/budget-management-system.

## Copyright and License

[MIT License.](https://github.com/viparthasarathy/budget-management-system/blob/master/LICENSE.md) Copyright 2016 Vidul Parthasarathy.
