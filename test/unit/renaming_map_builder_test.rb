require "unit_test_helper"
require LibDirectory.file('renaming_map_builder')

class RenamingMapBuilderTest < Test::Unit::TestCase
  def test_should_parse_single_renaming_param_into_a_map
    renaming_param = "name as FooBar"
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {'name' => 'FooBar'}
    assert_equal expected_map, renaming_map
  end

  def test_should_parse_multiple_renaming_param_into_a_map
    renaming_param = "name as Foobar, Date as Start Date"
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {'name' => 'Foobar', 'Date' => 'Start Date'}
    assert_equal expected_map, renaming_map
  end

  def test_should_treat_keywords_as_case_insensitive
    renaming_param = "name AS Foobar, Date aS Start Date"
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {'name' => 'Foobar', 'Date' => 'Start Date'}
    assert_equal expected_map, renaming_map
  end

  def test_should_raise_exception_if_comma_is_missing
    renaming_param = "name as Foobar Date as Start Date"
    exception = nil
    begin
      RenamingMapBuilder.build_renaming_map_from(renaming_param)
    rescue ArgumentError => exception
    end

    assert exception.is_a?(ArgumentError)
    assert_equal RenamingMapBuilder::INVALID_RENAMING_PARAM_MESSAGE, exception.message
  end

  def test_should_raise_exception_if_as_keyword_is_missing
    renaming_param = "name as Foobar, blah = ''"
    exception = nil
    begin
      RenamingMapBuilder.build_renaming_map_from(renaming_param)
    rescue ArgumentError => exception
    end

    assert exception.is_a?(ArgumentError)
    assert_equal RenamingMapBuilder::INVALID_RENAMING_PARAM_MESSAGE, exception.message
  end

  def test_should_handle_quote_marks_surrounding_column_names
    renaming_param = %q/name as 'Foobar', 'date' as "Start Date"/
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {'name' => 'Foobar', 'date' => 'Start Date'}
    assert_equal expected_map, renaming_map
  end

  def test_should_handle_empty_new_name
    renaming_param = "name as , date as start date"
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {'name' => '', 'date' => 'start date'}
    assert_equal expected_map, renaming_map
  end

  def test_should_handle_empty_renaming_param
    renaming_param = "  "
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {}
    assert_equal expected_map, renaming_map
  end

  def test_should_handle_nil_renaming_param
    renaming_param = nil
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    expected_map = {}
    assert_equal expected_map, renaming_map
  end
end