require 'test/unit'
require 'rubygems'
require 'mocha'
require 'lib_directory'
require File.join(File.dirname(__FILE__), '..', '..', 'init.rb')
require LibDirectory.file('enhanced_table')
require File.join(File.dirname(__FILE__), 'fixture_loader')

class Test::Unit::TestCase

  def project(name)
    @project ||= FixtureLoaders::ProjectLoader.new(name).project
  end

end

module Mingle

  class PropertyDefinition
    MANAGED_TEXT_TYPE = "Managed text list"
    MANAGED_NUMBER_TYPE = "Managed number list"
  end

end