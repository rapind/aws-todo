# Setup Your Environment #

Instructions on setting up the aws-todo Rails environment.

## Sign Up for an Amazon Web Services Account ##
  1. http://aws.amazon.com/
  1. Sign up for the SimpleDB service (beta)
  1. Sign up for the EC2 service

## Install SimpleDB ##
See: http://developer.amazonwebservices.com/connect/entry.jspa?externalID=1242
  1. gem install aws-sdb
  1. Enter your amazon access and secret keys in 'config/aws\_adb\_proxt.xml'
  1. Create the SimpleDB domain "rake aws\_sdb:create\_domain DOMAIN=aws\_todo"
  1. Start the SimpleDB proxy server "rake aws\_sdb:start\_proxy\_in\_foreground"

Now you should be able to run the examples by just running the server (no other database setup).

You can view the users and tasks from SimpleDB by hitting the proxied resources directly. I.e. http://localhost:8888/aws_todo/users.xml and http://localhost:8888/aws_todo/tasks.xml