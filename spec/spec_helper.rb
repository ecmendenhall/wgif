require 'rspec'
require 'simplecov'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

if ENV['COVERAGE'] == 'true'
  SimpleCov.start do
    add_filter '/spec/'
  end
end
