require "unit_test_helper"
require LibDirectory.file('result_formatter')
require LibDirectory.file('mql_date_formatter')
require LibDirectory.file('number_formatter')

class ResultFormatterTest < Test::Unit::TestCase

  def test_should_format_date_and_number
      unformatted_value = "unformatted"
      date_formatted_value = "date_formatted"
      number_formatted_value = "number_formatted"
      MqlDateFormatter.expects(:format_value).with(unformatted_value).returns(date_formatted_value)
      NumberFormatter.expects(:format_value).with(date_formatted_value).returns(number_formatted_value)
      
       assert_equal number_formatted_value, ResultFormatter.format_value(unformatted_value)
    end
end