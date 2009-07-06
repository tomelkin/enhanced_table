require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('table_header_builder')

class TableHeaderBuilderTest < Test::Unit::TestCase

  def setup
    @table = mock
    @table.expects(:column_names).returns(["Header 1", "Header 2"])
  end

  def test_should_parse_table_header_from_mql_result
    expected_results = "<tr><th>Header 1</th><th>Header 2</th></tr>"
    assert_equal expected_results, TableHeaderBuilder.build_html_table_header_from(@table)
  end

end