require 'test/unit'
require 'rubygems'
require 'mocha'
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'html_table_builder')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'row_parser')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'column_name_parser')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'row_parser')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'result_formatter')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'renaming_map_builder')

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


    RenamingMapBuilder.expects(:build_renaming_map_from).with(@renaming_param).returns(renaming_map).once
    ColumnNameParser.expects(:parse_table_header_from).with(@mql_results, renaming_map).returns(html_header).once
    ResultFormatter.expects(:format_result).with(@mql_results).returns(@mql_results).once
    RowParser.expects(:parse_rows_from).with(@mql_results, @project).returns(html_rows).once

    expected_html = "<table>" + html_header + html_rows + "</table>"

    html = HtmlTableBuilder.build_table_from(@mql_results, @project, @renaming_param)

    assert_equal expected_html, html
  end

  def test_should_display_error_if_renaming_map_builder_raises_exception
    exception_error_message = "error message"
    RenamingMapBuilder.expects(:build_renaming_map_from).raises(ArgumentError, exception_error_message)

    expected_html = "<p>#{exception_error_message}</p>"

    html = HtmlTableBuilder.build_table_from(@mql_results, @project, @renaming_param)

    assert_equal expected_html, html
  end

end