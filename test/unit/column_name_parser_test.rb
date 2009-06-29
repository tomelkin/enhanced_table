require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('column_name_parser')

class ColumnNameParserTest < Test::Unit::TestCase

  def setup
    @column_names = ["Header 1", "Header 2"]
  end

  def test_should_parse_table_header_from_mql_result
    expected_results = "<tr><th>Header 1</th><th>Header 2</th></tr>"
    assert_equal expected_results, ColumnNameParser.build_html_table_header_from(@column_names)
  end

end