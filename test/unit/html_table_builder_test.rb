require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('html_table_builder')
require LibDirectory.file('row_parser')
require LibDirectory.file('column_name_parser')
require LibDirectory.file('row_parser')
require LibDirectory.file('result_formatter')
require LibDirectory.file('renaming_map_builder')

class HtmlTableBuilderTest < Test::Unit::TestCase

  def setup
    @mql_results = [{"Name" => "Row 1", "Something" => "Something One"},
                   {"Name" => "Row 2", "Something" => "Something Two"}]
    @project = mock
    @renaming_param = "Something as Something renamed"

  end

  def test_should_parse_column_and_row_from_query_results_and_produce_html_table
    html_header = "<header>"
    html_rows = "<rows>"
    renaming_map = {}

    ColumnNameParser.expects(:parse_table_header_from).with(@mql_results).returns(html_header).once
    ResultFormatter.expects(:format_result).with(@mql_results).returns(@mql_results).once
    RowParser.expects(:parse_rows_from).with(@mql_results, @project).returns(html_rows).once

    expected_html = "<table>" + html_header + html_rows + "</table>"

    html = HtmlTableBuilder.build_table_from(@mql_results, @project)

    assert_equal expected_html, html
  end

end