require 'test/unit'
require 'rubygems'
require 'mocha'
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'result_formatter')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'mql_date_formatter')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'number_formatter')

class ResultFormatterTest < Test::Unit::TestCase

  def test_iterates_over_results_and_calls_formatters_for_each_value
    query_results = [{"Name" => "Row 1", "Date" => "Date 1"},
                     {"Name" => "Row 2", "Date" => "Date 2"}]

    ["Row 1", "Date 1", "Row 2", "Date 2"].each do |value|
      formatted_value = value + " Formatted"
      MqlDateFormatter.expects(:format_value).with(value).returns(formatted_value)
      NumberFormatter.expects(:format_value).with(formatted_value).returns(formatted_value)
    end

    expected_formatted_results = [{"Name" => "Row 1 Formatted", "Date" => "Date 1 Formatted"},
                                  {"Name" => "Row 2 Formatted", "Date" => "Date 2 Formatted"}]

    formatted_results = ResultFormatter.format_result(query_results)

    assert_equal expected_formatted_results, formatted_results
  end
  
end