require File.dirname(__FILE__) + '/integration_test_helper.rb'

# The Mingle API supports basic authentication and must be used in order to run integration tests. However it is disabled in the default configuration. To enable basic authentication, you need set the basic_authentication_enabled configuration option to true in the Mingle data directory/config/auth_config.yml file where Mingle data directory is the path to the mingle data directory on your installation e.g.basic_authentication_enabled: true.

class NewTableIntegrationTest < Test::Unit::TestCase
  
  PROJECT_RESOURCE = 'http://username:password@your.mingle.server:port/lightweight_projects/your_project_identifier.xml'

  def test_macro_contents
    enhanced_table = EnhancedTable.new(nil, project(PROJECT_RESOURCE), nil)
    result = enhanced_table.execute
    assert result
  end

end