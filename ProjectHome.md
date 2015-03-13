# Rails SimpleDB Task List (Implemented with Amazon Web Services) #

This project shows a simple implementation of a task list using the following technologies:

  * Ruby on Rails 2.02
  * Amazon SimpleDB
  * Deployed on Amazon EC2

No local database is used. No MySQL or sqlite.

See the [Setup](Setup.md) for installation instructions. You will need an Amazon Web Services account.

This is a rather simple project, but I think it does a decent job in demonstrating the power of handing off infrastructure to third-party utility computing services (clouds) like EC2, S3, SQS, and SimpleDB.

It would be trivial to scale this application with a little bit of resource caching (calls to  Amazon) and an observer. You could deploy it on **n** servers (in fact there are scripts that will automatically drop in new EC2 instances based on CPU load) without any concerns over database clustering. Naturally you still need to develop with data integrity in mind, and ActiveResource has no where near the attention of ActiveRecord to date, so it's not a replacement for your typical relational DB setup in most instances.

## Next Steps: ##
  1. Implement a proper caching layer at the controllers.
  1. Put a decent UI on it.
  1. Replace the proxy with direct calls to SimpleDB (we're marshalling objects twice right now).
  1. Put together the cap recipes for EC2 deployment.


---

- _Dave Rapin_