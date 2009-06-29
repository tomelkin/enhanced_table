require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('html_table_builder')

class EnhancedTableTest < Test::Unit::TestCase

  QUERY = "some query"
  MQL_QUERY_RESULTS = [{"Header A" => "10", "Header B" => "30"},
                       {"Header A" => "100", "Header B" => "13"}]
  RENAMING_PARAM = "Header A as Header A Renamed, 'Header B' as 'Header B Renamed'"
  CALCULATION_PARAM = "Header A + Header B as Header C"
  MULTIPLE_CALCULATION_PARAM = "Header A + Header B as Header C, Header A * Header B + 2 as Header D"


  PARAMS = {'query' => "#{QUERY}", 'rename' => "#{RENAMING_PARAM}", 'calculate' => "#{CALCULATION_PARAM}"}

  def setup
    @project = mock()
    @project.expects(:execute_mql).with(QUERY).returns(MQL_QUERY_RESULTS)
  end

  def test_should_execute_query_and_produce_html_table
    parameters = {"query" => QUERY}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A</th><th>Header B</th></tr>" +
            "<tr><td>10</td><td>30</td></tr>" +
            "<tr><td>100</td><td>13</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_rename_table_columns_based_on_rename_parameter
    parameters = {'query' => QUERY, 'rename' => RENAMING_PARAM}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A Renamed</th><th>Header B Renamed</th></tr>" +
            "<tr><td>10</td><td>30</td></tr>" +
            "<tr><td>100</td><td>13</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_calculate_new_columns_based_on_calculate_parameter
    parameters = {'query' => QUERY, 'calculate' => CALCULATION_PARAM}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A</th><th>Header B</th><th>Header C</th></tr>" +
            "<tr><td>10</td><td>30</td><td>40</td></tr>" +
            "<tr><td>100</td><td>13</td><td>113</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_handle_multiple_rows_and_multiple_new_column_calculations
    parameters = {'query' => QUERY, 'calculate' => MULTIPLE_CALCULATION_PARAM}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A</th><th>Header B</th><th>Header C</th><th>Header D</th></tr>" +
            "<tr><td>10</td><td>30</td><td>40</td><td>302</td></tr>" +
            "<tr><td>100</td><td>13</td><td>113</td><td>1302</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end


end
