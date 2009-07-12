# Testing process inspired by will_paginate
$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'rubygems'
require 'activerecord'
require 'activesupport'
require 'actionpack'
require 'action_controller'
require 'action_controller/test_process'
require 'action_view'
require 'sort_by'
require 'spec'
require 'will_paginate'
WillPaginate.enable

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)
# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = zone

load File.dirname(__FILE__) + "/fixtures/schema.rb"
load File.dirname(__FILE__) + "/fixtures/models.rb"

# bootstraping the plugin through init.rb
# tests how it would load in a real application
load File.dirname(__FILE__) + "/../rails/init.rb"
