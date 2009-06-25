require 'test/unit'
require LibDirectory.file('init.rb')
require LibDirectory.file('enhanced_table')
require File.join(File.dirname(__FILE__), 'rest_loader')

class Test::Unit::TestCase

  def project(name)
    @project ||= RESTfulLoaders::ProjectLoader.new(name, nil, self).project
  end  

  def errors
    @errors ||= []
  end  
  
  def alert(message)
    errors << message
  end
end  
