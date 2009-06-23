require "test/unit"
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'column_name_parser')

class ColumnNameParserTest < Test::Unit::TestCase

  def setup
    @mql_result = [{"Header 1" => "Row 1", "Header 2" => "Row 2"}]
  end

  def test_should_parse_table_header_from_mql_result
    expected_results = "<tr><th>Header 1</th><th>Header 2</th></tr>"
    assert_equal expected_results, ColumnNameParser.parse_table_header_from(@mql_result)
  end

  def test_should_rename_table_header_if_the_new_column_name_exist_in_renaming_map
    renaming_map = {"Header 1" => "Header 1 renamed", "Header 2" => "Header 2 renamed"}

    expected_results = "<tr><th>Header 1 renamed</th><th>Header 2 renamed</th></tr>"
    assert_equal expected_results, ColumnNameParser.parse_table_header_from(@mql_result, renaming_map)
  end

  def test_should_not_rename_columns_if_they_arent_in_renaming_map
    renaming_map = {"Header 1" => "Header 1 renamed"}
    expected_results = "<tr><th>Header 1 renamed</th><th>Header 2</th></tr>"
    assert_equal expected_results, ColumnNameParser.parse_table_header_from(@mql_result, renaming_map)
  end

end