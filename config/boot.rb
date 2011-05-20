PROJECT_PATH =
  File.expand_path( File.join( File.dirname(__FILE__), ".." ) ) unless defined? PROJECT_PATH

ENV["ENVIRONMENT"] ||= "development"

require "rubygems"
require "bundler"
Bundler.setup( :default, ENV["ENVIRONMENT"].to_sym )
puts "Bundler loaded unlocked environment: #{ENV["ENVIRONMENT"]}" if $DEBUG

$LOAD_PATH.unshift( "#{PROJECT_PATH}")
$LOAD_PATH.unshift("#{PROJECT_PATH}/build")

%w[build].each do |path|
  Dir["#{PROJECT_PATH}/#{path}/**/*.rb"   ].each { |lib| require lib }
end
