Note
----
* This gem is currently alpha. __You need to be invited to [SourceNinja Alpha](http://www.sourceninja.com/sign-up.html) in order to use this gem__.

What is SourceNinja
-------------------
SourceNinja is an awesome service that allows you to stay informed of updates to the open source packages that your application uses. When a newer version of a package is released, SourceNinja alerts you and gives you actionable information to help you determine whether you should upgrade to the newer package.

Visit [SourceNinja](http://sourceninja.com) to learn more.

What is the sourceninja gem
---------------------------
The sourceninja gem is a gem that can be included in your rails application to allow seamless integration with SourceNinja. The sourceninja gem will send all of your gem files and versions to SourceNinja to begin managing your open source libraries.

Getting Started
---------------
1. Create a [SourceNinja](http://sourceninja.com) account. Currently, you need to be part of our [alpha](http://www.sourceninja.com/sign-up.html).

2. Log into SourceNinja and create a product. The product you create will be paired with your application.

3. After you create a product, you will be directed to a page asking what language your application is running. Select `Rails` from the menu on the left side. 

4. You will be presented with two values, you'll need these two values later.
    ```
    SOURCENINJA_TOKEN="50a336d92da8ddea1ae0a6c0d06a172"
    SOURCENINJA_PRODUCT_ID="477fcfa7-765a-4b91-b6a5-2ebe4c4f9d58"
    ```

5. Install the [sourceninja gem](http://github.com/SourceNinja/sourceninja-ruby). You can do this by adding the following line to your Gemfile.
    ```
    gem "sourceninja", "~> 0.0.6"
    ```

6. Run `bundle install`.

7. Set the environment variables ```SOURCENINJA_TOKEN``` and ```SOURCENINJA_PRODUCT_ID``` using the values from step 4.

Updated Magically in Production
-----------------
Now each time you push to production the sourceninja gem will be run and data will be populated back to SourceNinja. If you visit your SourceNinja page you will be given a list of outdated gems.

The sourceninja data is populated whenever the app is initialized.

Testing Locally
---------------
If you would like to test sourceninja gem locally, you will want to create an initializer script to set the variables.

### Contents of `config/initializers/sourceninja.rb`
	ENV["SOURCENINJA_TOKEN"]      ||= "1cea0be98caf02e830ac2aadbe44e4ee"
	ENV["SOURCENINJA_PRODUCT_ID"] ||= "fb89e064-b48c-d0c3-81x4-a34a5b60a654"

Upon doing this, each time you start the rails server locally the data will be pushed. You could also use these steps if you want to manage a production instance and a development instance.

__Note: DO NOT DO THIS FOR PRODUCTION: No configuration files with sensitive information should ever be required within the application source and required config values should be read in from the ENV by supported libraries.__

Support
-------
Feel free to email us at support at sourceninja dot com if you have any questions or issues.

![sourceninja-ruby](http://cl.ly/2x001f2y042U3b05143Z/Screen%20shot%202012-03-16%20at%202.51.05%20PM.png)