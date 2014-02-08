require 'rspec'
require 'simplecov'

if ENV['COVERAGE'] == 'true'
  SimpleCov.start do
    add_filter '/spec/'
  end
end
