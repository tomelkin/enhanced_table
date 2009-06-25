require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('html_table_builder')
require LibDirectory.file('result_manipulator')


class EnhancedTableTest < Test::Unit::TestCase

  FIXTURE = 'sample'
  QUERY = "some query"
  RENAMING_PARAM = "something as something else"
  CALCULATION_PARAM = "Column A + Column B as Column C"
  PARAMS = {'query' => "#{QUERY}", 'rename' => "#{RENAMING_PARAM}", 'calculate' => "#{CALCULATION_PARAM}"}
  SOME_HTML_TABLE = "<table><tr><th> some header </th></tr> <tr><td> some row </td></tr>"


  def setup
    @project = project(FIXTURE)
  end

  def test_should_execute_mql_query_process_results_and_produce_html
    @enhanced_table = EnhancedTable.new(PARAMS, @project, nil)

    query_results = [{}]
    manipulated_results = [{}]

    @project.expects(:execute_mql).with(QUERY).returns(query_results)
    ResultManipulator.expects(:process).with(query_results, RENAMING_PARAM, CALCULATION_PARAM).returns(manipulated_results)
    HtmlTableBuilder.expects(:build_table_from).with(manipulated_results, @project).returns(SOME_HTML_TABLE)

    result = @enhanced_table.execute

    assert_equal SOME_HTML_TABLE, result
  end

  def test_should_display_query_and_empty_result_warning_when_query_does_not_give_any_result
    @enhanced_table = EnhancedTable.new(PARAMS, @project, nil)

    query_results = []

    @project.expects(:execute_mql).with(QUERY).returns(query_results)
    HtmlTableBuilder.expects(:build_table_from).never

    expected = "<p>query <pre><code> " + QUERY + " </code></pre> does not return any result</p>"
    result = @enhanced_table.execute

    assert_equal expected, result
  end

  def test_should_not_execute_query_display_error_when_no_query_has_been_specified
    empty_params = {}
    @enhanced_table = EnhancedTable.new(empty_params, @project, nil)

    @project.expects(:execute_mql).with(QUERY).never
    HtmlTableBuilder.expects(:build_table_from).never

    result = @enhanced_table.execute

    assert_equal EnhancedTable::EMPTY_QUERY_ERROR_MESSAGE, result
  end

  def test_should_not_fail_when_no_calculate_param_specified
    params = {'query' => QUERY}
    results = "some_result"

    @enhanced_table = EnhancedTable.new(params, @project, nil)

    @project.expects(:execute_mql).with(QUERY).returns(results)
    ResultManipulator.expects(:process).with(results, nil, nil).returns(results)
    HtmlTableBuilder.expects(:build_table_from).with(results, @project)

    @enhanced_table.execute
  end

  def test_should_display_error_if_exception_is_caught
    query_results = ["Header" => "Row 1"]

    @project.expects(:execute_mql).with(QUERY).returns(query_results)
    @enhanced_table = EnhancedTable.new(PARAMS, @project, nil)

    exception_error_message = "error message"
    ResultManipulator.expects(:process).raises(ArgumentError, exception_error_message)

    expected_html = "<p>#{exception_error_message}</p>"
    html = @enhanced_table.execute

    assert_equal expected_html, html
  end

end
