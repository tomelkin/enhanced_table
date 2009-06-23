require "test/unit"
require "rubygems"
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'column_name_parser')

class ColumnNameParserTest < Test::Unit::TestCase

  def test_should_parse_table_header_from_mql_result
    mql_result = [{"Header 1" => "Row 1", "Header 2" => "Row 2"}]

    expected_results = "<tr><th>Header 1</th><th>Header 2</th></tr>"
    assert_equal expected_results, ColumnNameParser.parse_table_header_from(mql_result)
  end

end