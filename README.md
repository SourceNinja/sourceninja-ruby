Note
----
This gem is currently alpha. __You need to be invited to [SourceNinja Alpha](http://www.sourceninja.com/sign-up.html) in order to use this gem__.

What is SourceNinja
-------------------
SourceNinja is an awesome service that allows you to stay informed of updates to the open source packages that your application uses. When a newer version of a package is released, SourceNinja gives you actionable information to help you determine whether you should upgrade to the newer package.

Visit [SourceNinja](http://sourceninja.com) to learn more.

What is sourceninja-ruby
------------------------
sourceninja-ruby is a gem that can be included in your rails application to allow seamless integration with SourceNinja. sourceninja-ruby will send all of your gem files and versions to SourceNinja to begin managing your open source libraries.

Getting Started
---------------
First of all, you'll need the gem. It's at `http://github.com/SourceNinja/sourceninja-ruby`. If you're using Bundler, just add the following to your Gemfile.
    
  gem 'sourceninja-ruby', :git => 'https://github.com/SourceNinja/sourceninja-ruby'

Before you can do anything with the sourceninja-ruby gem, you'll need to create your very own SourceNinja account (please read the notice above). Go ahead and do so at [http://sourceninja.com](http://sourceninja.com). Once created, you will need to create a product. This is the application you want SourceNinja to track. Once your create a product, you will notice two keys on the right hand column that you will need `ID` and the `PRODUCT API TOKEN`.

Next, create an initializer script in your application in `config/initializers`. There are two environment variables you will need to initialize, `SOURCENINJA_TOKEN` and `SOURCENINJA_PRODUCT_ID`.

### Contents of `config/initializers/sourceninja.rb`
	ENV["SOURCENINJA_TOKEN"]      ||= "2cea0be98caf02e830ac2aadbe44e4ee"
	ENV["SOURCENINJA_PRODUCT_ID"] ||= "fb89e066-b48c-40c3-81b4-a34a5b60a654"

Updated Magically
-----------------
Each time your rails app is restarted, the sourceninja-ruby gem will run and data will be populated back to SourceNinja. If you visit your SourceNinja page you will be given a list of outdated gems.

Support
-------
Feel free to email us at support at sourceninja dot com if you have any questions or issues.
