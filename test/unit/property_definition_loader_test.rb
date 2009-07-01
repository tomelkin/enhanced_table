require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('property_definition_loader')

class PropertyDefinitionLoaderTest < Test::Unit::TestCase

  MANAGED_TEXT_TYPE = Mingle::PropertyDefinition::MANAGED_TEXT_TYPE
  MANAGED_NUMBER_TYPE = Mingle::PropertyDefinition::MANAGED_NUMBER_TYPE
  DATE = "Date"

  def setup
    @project = mock
  end

  def test_should_not_load_properties_that_are_not_managed_text_types_or_managed_number_type
    managed_text_type_property = build_managed_text_type_property
    managed_number_type_property = build_managed_number_type_property
    property_definitions = [build_irrelevent_property_definition, managed_text_type_property, managed_number_type_property]

    @project.expects(:property_definitions).returns(property_definitions)
    @property_definition_loader = PropertyDefinitionLoader.new(@project)

    assert_nil @property_definition_loader.load_property_for("Development Completed On")
    assert_equal managed_text_type_property, @property_definition_loader.load_property_for("text")
    assert_equal managed_number_type_property, @property_definition_loader.load_property_for("number")
  end

  def build_managed_text_type_property
    values = [stub(:color => "red", :db_identifier => 'RedThing')]
    stub(:name => "text",
         :type_description => MANAGED_TEXT_TYPE,
         :values => values)
  end

  def build_managed_number_type_property
    stub(:name => "number",
         :type_description => MANAGED_NUMBER_TYPE,
         :values => [])
  end

  def build_irrelevent_property_definition
    stub(:name => "Development Completed On",
         :type_description => DATE)
  end

end