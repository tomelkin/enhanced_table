require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('mql_date_formatter')


class MqlDateFormatterTest < Test::Unit::TestCase
  def test_converts_valid_date_string_to_date  
    assert_equal Date.civil(2008, 1, 2), MqlDateFormatter.format_value("2008-01-02")
    
  end

  def test_should_return_original_value_when_date_string_is_not_in_mql_date_format
    non_mql_date = "01-01-2008"
    assert_equal non_mql_date, MqlDateFormatter.format_value(non_mql_date)
  end

  def test_should_return_original_value_if_non_string_is_passed_in
    number = 45
    assert_equal number, MqlDateFormatter.format_value(number)
  end

  def test_should_return_original_value_if_some_random_string_is_passed_in
    some_random_string = "some random string"
    assert_equal some_random_string, MqlDateFormatter.format_value(some_random_string)
  end
end