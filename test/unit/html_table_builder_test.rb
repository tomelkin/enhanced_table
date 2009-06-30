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
    @table = Table.new(@mql_results)


  end

  def test_should_parse_column_and_row_from_query_results_and_produce_html_table
    html_header = "<header>"
    html_rows = "<rows>"
    renaming_map = {}
    records = @table.records

    ColumnNameParser.expects(:build_html_table_header_from).with(@table.column_names).returns(html_header).once
    RowParser.expects(:build_html_table_rows_from).with(@table.rows, @project).returns(html_rows).once

    expected_html = "<table>" + html_header + html_rows + "</table>"

    html = HtmlTableBuilder.build_html_table_from(@table, @project)

    assert_equal expected_html, html
  end

end