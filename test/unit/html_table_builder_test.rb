require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('html_table_builder')
require LibDirectory.file('table_header_builder')
require LibDirectory.file('table_rows_builder')
require LibDirectory.file('result_formatter')
require LibDirectory.file('renaming_map_builder')

class HtmlTableBuilderTest < Test::Unit::TestCase

  def setup
    @table = stub(:rows => "rows", :column_names => "some column names")
  end

  def test_should_parse_column_and_row_from_query_results_and_produce_html_table
    html_header = "<header>"
    html_rows = "<rows>"
    TableHeaderBuilder.expects(:build_html_table_header_from).with(@table).returns(html_header).once
    TableRowsBuilder.expects(:build_html_table_rows_from).with(@table).returns(html_rows).once

    expected_html = "<table>" + html_header + html_rows + "</table>"

    html = HtmlTableBuilder.build_html_table_from(@table)

    assert_equal expected_html, html
  end

end