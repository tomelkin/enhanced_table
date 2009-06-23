require 'test/unit'
require 'rubygems'
require 'mocha'
require File.join(File.dirname(__FILE__), '..', '..', 'init.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'new_table')
require File.join(File.dirname(__FILE__), 'fixture_loader')

class Test::Unit::TestCase
  
  def project(name)
    @project ||= FixtureLoaders::ProjectLoader.new(name).project
  end  
   
end
