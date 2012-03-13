Note
----
* This gem is currently alpha. __You need to be invited to [SourceNinja Alpha](http://www.sourceninja.com/sign-up.html) in order to use this gem__.
* If you are using Heroku, please refer to the [Heroku Documentation](heroku-addon) and please ignore this documentation.

What is SourceNinja
-------------------
SourceNinja is an awesome service that allows you to stay informed of updates to the open source packages that your application uses. When a newer version of a package is released, SourceNinja alerts you and gives you actionable information to help you determine whether you should upgrade to the newer package.

Visit [SourceNinja](http://sourceninja.com) to learn more.

What is the sourceninja gem
------------------------
The sourceninja gem is a gem that can be included in your rails application to allow seamless integration with SourceNinja. The sourceninja gem will send all of your gem files and versions to SourceNinja to begin managing your open source libraries.

Getting Started
---------------
First of all, you'll need the gem. If you're using Bundler, just add the following to your `Gemfile`.
    
	gem 'sourceninja'

Of course, as always, when you edit your Gemfile:
	
	bundle install

Before you can do anything with the sourceninja gem, you'll need to create your very own SourceNinja account (please read the notice above). Go ahead and do so at [http://sourceninja.com](http://sourceninja.com). Once created, you will need to create a product. This is the application you want SourceNinja to track. 

Once your create a product, you will be directed to a page asking what language your application is running. Select `Rails` from the menu on the left side. You will be presented with two keys that you will need for the rest of the installation.

You will then need to setup two environement variables in production, `ENV["SOURCENINJA_TOKEN"]` and `ENV["SOURCENINJA_PRODUCT_ID"]`. You could set these up in a configuration file that is only used in production, however, that is not suggested. You should setup the enviornement variables according to your hosting documentation.

Updated Magically in Production
-----------------
Now each time you push to production the sourceninja gem will be run and data will be populated back to SourceNinja. If you visit your SourceNinja page you will be given a list of outdated gems.

The sourceninja data is populated whenever the app is initilized.

Testing Locally
---------------
If you would like to test sourceninja gem locally, you will want to create an initializer script to set the variables.

### Contents of `config/initializers/sourceninja.rb`
	ENV["SOURCENINJA_TOKEN"]      ||= "1cea0be98caf02e830ac2aadbe44e4ee"
	ENV["SOURCENINJA_PRODUCT_ID"] ||= "fb89e064-b48c-d0c3-81x4-a34a5b60a654"

Upon doing this, each time you start the rails server locally the data will be pushed. 

You could also use these steps if you want to manage a production instance and a developement instance.

Support
-------
Feel free to email us at support at sourceninja dot com if you have any questions or issues.