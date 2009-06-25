require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('number_formatter')


class NumberFormatterTest < Test::Unit::TestCase

  def test_should_trims_trailing_zeros_from_numeric_values
    assert_equal "5", NumberFormatter.format_value("5.00")
    assert_equal "5.1", NumberFormatter.format_value("5.10")
    assert_equal "-50.01", NumberFormatter.format_value("-50.01")
    assert_equal "0", NumberFormatter.format_value("0")
    assert_equal "0", NumberFormatter.format_value("0.0")
    assert_equal "0.1", NumberFormatter.format_value("0.100000")
  end
  
  def test_should_return_original_value_when_passed_non_numeric_value
    assert_equal "something", NumberFormatter.format_value("something")
  end
  
  def test_should_return_nil_when_passed_nil_value
    assert_nil NumberFormatter.format_value(nil)
  end

end