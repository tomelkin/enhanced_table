require 'test/unit'
require 'rubygems'
require 'mocha'
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'html_table_builder')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'row_parser')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'column_name_parser')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'row_parser')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'result_formatter')

class HtmlTableBuilderTest < Test::Unit::TestCase

  def test_should_parse_column_and_row_from_query_results_and_produce_html_table
    mql_results = [{"Name" => "Row 1", "Something" => "Something One"},
                   {"Name" => "Row 2", "Something" => "Something Two"}]
    html_header = "<header>"
    html_rows = "<rows>"
    project = mock()

    ColumnNameParser.expects(:parse_table_header_from).with(mql_results).returns(html_header).once
    ResultFormatter.expects(:format_result).with(mql_results).returns(mql_results).once
    RowParser.expects(:parse_rows_from).with(mql_results, project).returns(html_rows).once

    expected_html = "<table>" + html_header + html_rows + "</table>"

    html = HtmlTableBuilder.build_table_from(mql_results, project)

    assert_equal expected_html, html
  end

end