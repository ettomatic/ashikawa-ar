# Contributing

When you want to write code for the project, please follow these guidelines:

1. Claim the ticket: Tell us that you want to work on a certain ticket, we will assign it to you (We don't want two people to work on the same thing ;) )
2. Write an Integration Test: Describe what you want to do (our integration tests touch the database)
3. Implement it: Write a unit test, check that it fails, make the test pass – repeat (our unit tests don't touch the database)
4. Write Documentation for it.
5. Check with `rake` that everything is fine and send the Pull Request :)

## How to get started developing

Getting started is easy, just follow these steps.

### In a nutshell

* Clone the project.
* `cd` into the folder and run `bundle` 
* `rake` and see all tests passing
* Happy coding!

### Detailed description

Make sure you are running Ruby 1.9.x (or JRuby/Rubinius in 1.9 mode) and clone the latest snapshot into a directory of your choice.

Change into the project directory. Run `bundle` to get all dependencies (do a `gem install bundler` before if you don't have bundler installed).

Now you can run `rake` to see all tests passing (hopefully). Happy coding!

You can also start up yard for documentation: `rake yard:server`

### Guard

Guard is a tool for comfortable development. If you want to use it for development, you have to first start an instance of ArangoDB and then start guard with `guard`. This will:

* Run a documentation server on `http://localhost:8808`
* Run `bundle` whenever you change the dependencies
* Run the integration and unit tests whenever you change a file in the lib or spec directory

### Continuous Integration

Our tests are run on Travis CI, the build status is displayed above. **Please note** that it only runs the unit tests and not the integration tests, because that would require ArangoDB to be installed on the Travis CI boxes. *Therefore green doesn't neccessarily mean green* (which is unfortunate). Therefore it is important that you run the integration tests on your local machine before sending the pull requests.
