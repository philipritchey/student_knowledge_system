# Student Knowledge System

https://tamu-sks.herokuapp.com

## Getting Started (From Zero to Deployed in ... Some Amount of Time)
* be in your dev machine, e.g. a fresh VPS or container (recommend Ubuntu 20+ with >=2 GB RAM)
* fork this repository: [fork it](https://github.com/philipritchey/student_knowledge_system/fork)
* clone your fork: `git clone git@github.com:YOU/student_knowledge_system.git`
* `cd student_knowledge_system`
* install rbenv with ruby-build: `curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash`
* reload profile: `source ~/.bashrc`
* install ruby 3.1.3: `rbenv install 3.1.3`
* set ruby 3.1.3 as the local default version: `rbenv local 3.1.3`
* install bundler: `gem install bundler`
* configure bundler to skip production gems: `bundle config set --local without 'production'`
* install dependencies: `bundle install`
* setup the database: `rails db:migrate`
* prepare the test database: `rails db:test:prepare`
* run rspec tests: `rails spec`
* run cucumber tests: `rails cucumber`
* assert that all tests are passing.  if they are not, find out which are failing and fix them and/or contact the previous team for help in fixing them.  possibly, the failing tests are themselves invalid and can be safely skipped?
* install heroku cli: `curl https://cli-assets.heroku.com/install-ubuntu.sh | sh`
* login to heroku: `heroku login -i`
  * `username: <your username>`
  * `password: <your API key>`
    * [get your API key from your heroku account](https://dashboard.heroku.com/account)
* create an app on heroku: `heroku create [appname]`, where `[appname]` is an optional name for the app
* [create an s3 bucket](https://s3.console.aws.amazon.com/s3/buckets)
* [create iam role for app to access s3 bucket](https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1)
  * take note of the access key id and secret access key
  * create access policy: in your iam s3 user, under permissions, click add permission, then create inline policy
    * choose `s3` as the service
    * specify the actions allowed:
      * `ListBucket`
      * `PutObject`
      * `GetObject`
      * `DeleteObject`
    * specify bucket resource ARN for the ListBucket action: click add ARN to restrict access
      * put name of your s3 bucket in the bucket name field
    * specify object resource ARN for the PutObject and 2 more actions:
      * put name of your s3 bucket in the bucket name field
      * click any next to object
    * click review policy at the bottom
    * make sure it looks right and then create it
* in `config/storage.yml`, make syre `region` and `bucket` fields match yourt bucket's region and name
* create google oauth2 client id:
  * [go to google cloud apis & services](https://console.cloud.google.com/apis)
  * if you've never been here before, you'll need to make a project first and congifure your oauth consent screen
    * make the project internal
    * only fill in the required fields:
      * name: your app's name
      * email: your email
      * authorized domains: your apps domain, e.g. `appname.herokuapp.com`
      * developer contact info: your email
  * go to credentials, then click create credentials at the top and select oauth client id
    * application type: web application
    * name: your app's name
    * authorized redirect uris, add: `https://appname.herokuapp.com/auth/google_oauth2/callback`
    * take note of the client id and client secret
* remove encrypted credentials that you cannot decrypt: `rm -f config/credentials.yml.enc`
* create and edit new credentials: `EDITOR=nano rails credentials:edit`
  * add AWS access key and secret (the iam s3 user access key id and secret access key)
    ```
      aws:
        access_key_id: ...
        secret_access_key: ...
    ```
  * add google oauth client id and secret
    ```
      GOOGLE_CLIENT_ID: ...
      GOOGLE_CLIENT_SECRET: ...
    ```
  * save and exit: `ctrl+o`, `ctrl+x`
  * take note of the master key in the console
* save master key to heroku as config var (for security): `heroku config:set RAILS_MASTER_KEY=...`
* configure email account for sending emails (e.g. one-time magic links)
  * use gmail (because why not?)
  * [create an app password](https://support.google.com/mail/answer/185833?hl=en)
* set sendmail config vars on heroku
  * `heroku config:set SENDMAIL_USERNAME=the email address you just created/configured`
  * `heroku config:set SENDMAIL_PASSWORD=the app password you just created`
  * `heroku config:set MAIL_HOST=https://appname.herokuapp.com`
* stage changes: `git add .`
* commit changes: `git commit -m "ready to push to heroku"`
* deploy to heroku: `git push heroku master`
* run migrations on heroku: `heroku run rails db:migrate`
* seed database on heroku: `heroku run rails db:seed`
* poke around the deployed app
* don't forget to also push to your github repo: `git push`

## Previous Teams
### Team Cluck - CSCE 431 2023A
* [Harshitha Dhulipala](mailto:hdhulipala02@tamu.edu)
* [Neha Manuel](mailto:nehaam02@tamu.edu)
* [Ethan Novicio](mailto:ethannovicio@tamu.edu)
* [Caleb Oliphant](mailto:oliphcal000@tamu.edu)

### Shockwave Kickers - CSCE 606 2022C
* [Jacob Kelly](mailto:jrkelly08@tamu.edu)
* [Stuart Nelson](mailto:s.s.nelson@tamu.edu)
* [Rahul Shah](mailto:rahulshah521@tamu.edu)
* [Colton Simpson](mailto:csimpson2018@tamu.edu)
* [Kunal Vudathu](mailto:kvudathu@tamu.edu)


## User Documentation

[CSCE 431 2023A](https://docs.google.com/document/d/13YEn9vxi73LRq51pw2A23WnFRuGfTe4LMNbsMm7367E/edit#)

[CSCE 606 2022C](https://docs.google.com/document/d/1ATG78_72BFUqlMq_9StImvI8vVKKumL87lb0Caz3JoQ/edit?usp=sharing)

This document should include startup guide for both heroku and local setup (windows and mac user). This also contains other instructions to store s3 and send confirmation emails when running locally

Doc version also exists under documentation folder.
