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
  RED = "ff0000"
  BLUE = "ff1111"

  def setup
    @project = mock()
    @property_definitions =  [stub(:name => "Header A",
                                   :type_description => Mingle::PropertyDefinition::MANAGED_TEXT_TYPE,
                                   :values => [stub(:color => RED, :db_identifier => '10'),
                                               stub(:color => BLUE, :db_identifier => "100")])]

    @project.expects(:execute_mql).with(QUERY).returns(MQL_QUERY_RESULTS)
    @project.expects(:property_definitions).returns(@property_definitions)
  end

  def test_should_execute_query_and_produce_html_table
    parameters = {"query" => QUERY}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A</th><th>Header B</th></tr>" +
            "<tr><td style='color:##{RED}'>10</td><td>30</td></tr>" +
            "<tr><td style='color:##{BLUE}'>100</td><td>13</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_rename_table_columns_based_on_rename_parameter
    parameters = {'query' => QUERY, 'rename' => RENAMING_PARAM}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A Renamed</th><th>Header B Renamed</th></tr>" +
            "<tr><td style='color:##{RED}'>10</td><td>30</td></tr>" +
            "<tr><td style='color:##{BLUE}'>100</td><td>13</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_calculate_new_columns_based_on_calculate_parameter
    parameters = {'query' => QUERY, 'calculate' => CALCULATION_PARAM}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A</th><th>Header B</th><th>Header C</th></tr>" +
            "<tr><td style='color:##{RED}'>10</td><td>30</td><td>40</td></tr>" +
            "<tr><td style='color:##{BLUE}'>100</td><td>13</td><td>113</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_handle_multiple_rows_and_multiple_new_column_calculations
    parameters = {'query' => QUERY, 'calculate' => MULTIPLE_CALCULATION_PARAM}

    enhanced_table = EnhancedTable.new(parameters, @project, nil)
    html = enhanced_table.execute

    expected_html = "<table>" +
            "<tr><th>Header A</th><th>Header B</th><th>Header C</th><th>Header D</th></tr>" +
            "<tr><td style='color:##{RED}'>10</td><td>30</td><td>40</td><td>302</td></tr>" +
            "<tr><td style='color:##{BLUE}'>100</td><td>13</td><td>113</td><td>1302</td></tr>" +
            "</table>"

    assert_equal(expected_html, html)
  end

  def test_should_give_back_html_with_error_message_when_getting_any_exception
    exception_message = "some message"

    parameters ={'query' => QUERY}
    enhanced_table = EnhancedTable.new(parameters, @project, nil)

    TableProcessor.expects(:process).raises(Exception, exception_message)
    html = enhanced_table.execute

    expected_html = "<p>#{exception_message}</p>"

    assert_equal expected_html, html
  end


end
