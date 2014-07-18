---
languages: ruby
tags: sinatra, gems, kids
type: live code, code along, lecture, example
resources: 0
---

# HS Summer Sinatra App

we are going to set up our Ruby applicatioen to deploy so that our backend logic will run on its own, and we will also have the option of a pretty front end.

To do this, we are going to use Sinatra.

[Sinatra](http://www.sinatrarb.com/). is a ruby gem that provides a very light-weight framework for building and deploying ruby applications. 

we will need to create a bunch of different files and directories, starting with `app.rb`

this file is responsible for bundling all of the ruby logic you write and passing it to the browser.

its the big communicator of your application

at the top of our app.rb file we are going to need to require a bunch of stuff:
```
require 'bundler' #require bundler
Bundler.require #require everything in bundler in gemfile
require 'pry'
```
bundler is a package for managing gems. 

Let us go ahead and make files to copy and paste our code in from our messaging lab
`mkdir lib`
`touch ./lib/emailer.rb` 
`touch ./lib/scraper.rb`

we will need to require these files in app.rb so that the root of our application knows the files exist
```
require 'bundler' #require bundler
Bundler.require #require everything in bundler in gemfile
require 'pry'
require './lib/scraper.rb'
require './lib/emailer.rb'
```
let us also copy and paste our Rakefile -- we will need to change the path to the files we're requiring because they're now nested in the lib directory

Next we are going to create a Gemfile. A gemfile is basically a Ruby way to manage all the gems used in an application, and keep versions stable within projects

If a new version of Nokogiri comes out and a lot is changed, we do not want our entire app to break just because we wrote it with an older version
```
source 'https://rubygems.org'

gem 'sinatra'
gem 'shotgun'
gem 'rake'
gem 'nokogiri'
gem 'mailgun'
gem 'pry'
```
Once the Gemfile has been created, we will enter `bundle install` in terminal

This will create a Gemfile.lock file which locks in all the proper versions of your gems for this particular project.

So now that we have all our gems set up and our previously written ruby code in the application.

We can work on putting all of this together in sinatra

Becuase app.rb manages the logic that takes your ruby code and passes it to the browser it has special language for managing the routes of your application aka, the url(s) that you use to go to a website
```
get '/' do
  erb :index
end
```
The get method is telling the root directory to go to an .html.erb file called index

The .erb extension allows us to write ruby in the browser we will create that now and put it in a views directory and add some simple HTML to start
`<h1> heyyy! </h1>`

We're using the shotgun gem to run localhost to view our work in the browser.

localhost is the internal server of your computer. It's what we run to execute our code and see how it would work on a remote server
`shotgun app.rb` will start up localhost and then in the browser go to `localhost:` and the port shotgun tells us.

shotgun is a cool and useful gem because it leaves our server running and reloads any changes to our code without us having to do it manually

So because we used MailGun for this project, we'll need to set up SMTP configurations.

SMTP stands for Simple Mail Transfer Protocol. Just like HTTP is the transfer protocol for the browser, SMTP is for sending emails.

we'll create a 'config.ru' file
```
require './app'
run Sinatra::Application

Mail.defaults do
  delivery_method :smtp, {
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :domain => 'localhost:9393',
    :user_name => 'postmaster@sandbox9e40982438de4c218c126056aa8f25ea.mailgun.org',
    :password =>  '7u2yp3x6t6w9',
    :authentication => 'plain',
    :enable_starttls_auto => true
  }
end
```
Here we specified the email address from mailgun and the password that goes along with the account we are setting the domain to localhost because we're just testing this locally (that'll change when we deploy)

If we wanted to display the most recent tweet in the browser, we'll need to put a little more logic in `get '/'` in app.rb

Our index.html.erb doesn't have access to our classes in scraping.rb and messaging.rb without us telling it
```
get '/' do
  scraper = Scraper.new("https://www.twitter.com/jongrover")
  @tweet = scraper.tweet_text
  @time = Time.at(scraper.tweet_time.to_i)
  erb :index #this tells your program to use the html associated with the index.html.erb file in your browser
end 
```
and now in index.html.erb....
```
<h1>Tweet App</h1>
<p><%= @tweet %> - <%= @time %></p>
```
The `<%= %>` are called erb tags. it's how we can embed ruby right into the HTML. 
Our browser will evuluate the ruby code and then write the return value as part of the HTML
Now to see this in the brower if we refesh, the most recent tweet.

We can also check our rake task by entering `rake check_tweet_time`