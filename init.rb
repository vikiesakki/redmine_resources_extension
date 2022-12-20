require 'redmine'
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/"
require 'resource_booking_query_patch'
TEAM_CUSTOM_FIELD_ID = 16
Redmine::Plugin.register :redmine_resources_extension do
  name 'Redmine Resources Extension plugin'
  author 'Vignesh EsakkiMuthu'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  # url 'http://example.com/path/to/plugin'
  # author_url 'http://example.com/about'
end
