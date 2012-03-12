Rails.logger.debug "Sourceninja: loading..."

require "sourceninja/version"

Rails.logger.debug "Sourceninja: version successfully loaded."

Rails.logger.debug "Sourceninja: loading main code if in Rails"
Rails.logger.debug "Sourceninja: in Rails" if defined? Rails
# only allow this to be run under rails for the time being.
require "sourceninja/sourceninja.rb" if defined? Rails
Rails.logger.debug "Sourceninja: attempted to load code" if defined? Rails