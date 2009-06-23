require File.join(File.dirname(__FILE__), 'unit_test_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'html_table_builder')


class NewTableTest < Test::Unit::TestCase

  FIXTURE = 'sample'
  QUERY = "some query"
  PARAMS = {'query' => "#{QUERY}"}
  SOME_HTML_TABLE = "<table><tr><th> some header </th></tr> <tr><td> some row </td></tr>"


  def setup
    @project = project(FIXTURE)
  end

  def test_should_execute_mql_query_format_results_and_produce_html
    @new_table = NewTable.new(PARAMS, @project, nil)

    query_results = [{"Name" => "Row 1", "Something" => "Something One"},
                     {"Name" => "Row 2", "Something" => "Something Two"}]

    @project.expects(:execute_mql).with(QUERY).returns(query_results).once
    HtmlTableBuilder.expects(:build_table_from).with(query_results, @project).returns(SOME_HTML_TABLE).once

    result = @new_table.execute

    assert_equal SOME_HTML_TABLE, result
  end

  def test_should_display_query_and_empty_result_warning_when_query_does_not_give_any_result
    @new_table = NewTable.new(PARAMS, @project, nil)

    query_results = []

    @project.expects(:execute_mql).with(QUERY).returns(query_results).once
    HtmlTableBuilder.expects(:build_table_from).with(query_results).never

    expected = "<p>query <pre><code> " + QUERY + " </code></pre> does not return any result</p>"
    result = @new_table.execute

    assert_equal expected, result
  end

  def test_should_not_execute_query_display_error_when_no_query_has_been_specified
    empty_params = {}
    @new_table = NewTable.new(empty_params, @project, nil)

    @project.expects(:execute_mql).with(QUERY).never
    HtmlTableBuilder.expects(:build_table_from).never

    result = @new_table.execute

    assert_equal NewTable::EMPTY_QUERY_ERROR_MESSAGE, result
  end

end
