require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('property_definition_loader')

class PropertyDefinitionLoaderTest < Test::Unit::TestCase

  MANAGED_TEXT_TYPE = Mingle::PropertyDefinition::MANAGED_TEXT_TYPE
  MANAGED_NUMBER_TYPE = Mingle::PropertyDefinition::MANAGED_NUMBER_TYPE
  DATE = "Date"

  def setup
    @project = mock

    managed_text_type_property = build_managed_text_type_property
    managed_number_type_property = build_managed_number_type_property
    irrelevent_property_type = build_irrelevent_property_definition
    property_with_unset_color_values = build_property_with_unset_color_values


    mql_results_column_names = []
    property_definitions = [irrelevent_property_type,
                            managed_text_type_property,
                            managed_number_type_property,
                            property_with_unset_color_values]

    default_column_names = ["Column Name"]

    @project.stubs(:property_definitions).returns(property_definitions)
    @property_definition_loader = PropertyDefinitionLoader.new(@project, default_column_names)
  end

  def test_should_map_managed_text_or_number_type_column_values_to_color
    assert_equal "red", @property_definition_loader.get_color_for("Column Name", "RedThing")
    assert_equal "blue", @property_definition_loader.get_color_for("Column Name", "BlueThing")
  end

  def test_should_not_get_map_color_that_is_not_queried_in_table
    empty_column_names = []
    @property_definition_loader = PropertyDefinitionLoader.new(@project, empty_column_names)

    assert_equal "", @property_definition_loader.get_color_for("Column Name", "RedThing")
  end

  def test_should_return_empty_string_when_property_name_does_not_exist
    assert_equal "", @property_definition_loader.get_color_for("unexistent property", "some value")
  end

  def test_should_return_empty_string_when_value_is_not_defined_in_property_color_map
    assert_equal "", @property_definition_loader.get_color_for("Column Name", "YellowThing")
  end

  def test_should_throw_color_not_set_exception_when_trying_to_load_property_with_unset_color
    column_name = "Column with unset color"
    column_names = [column_name]
    begin
      PropertyDefinitionLoader.new(@project, column_names)
    rescue Exception => exception
    end

    assert_equal "Color for Property : '#{column_name}' and Value : 'some value' is not set", exception.message
  end

  private

  def build_managed_text_type_property
    values = [stub(:db_identifier => "RedThing", :color => "red"),
              stub(:db_identifier => "BlueThing", :color => "blue"),
              stub(:db_identifier => "value returning nil color", :color => nil)]
    stub(:name => "Column Name",
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

  def build_property_with_unset_color_values
    value_with_unset_color = stub(:db_identifier => "some value")
    value_with_unset_color.stubs(:color).raises(Exception, "gsub exception")
    values = [value_with_unset_color]

    stub(:name => "Column with unset color",
         :type_description => MANAGED_TEXT_TYPE,
         :values => values)
  end

end
