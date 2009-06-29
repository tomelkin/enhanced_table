require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('calculate_parameter_parser')
require LibDirectory.file('calculation_details')

class CalculateParameterParserTest < Test::Unit::TestCase

  def test_should_parse_calculation_details_from_calculate_parameter
    calculate_param = "Column A + Column B as Column C"
    expected_calculation_details = [CalculationDetails.new("Column C", "Column A + Column B")]

    parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
  end


  def test_should_allow_parsing_parameters_with_quotes
    calculate_param = "'Column A' / 'Column B' as \"Column C\""
    expected_calculation_details = [CalculationDetails.new("Column C", "Column A / Column B")]

    parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
  end

  def test_handle_column_names_with_as_keyword_embedded_in_them
    calculate_param = "'Base' + 'Column B' as 'Column C'"
    expected_calculation_details = [CalculationDetails.new("Column C", "Base + Column B")]

    parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
  end

  def test_should_handle_different_keyword_capitalizations
    fully_capitalized_param = "Column A + Column B AS Column C"
    expected_calculation_details = [CalculationDetails.new("Column C", "Column A + Column B")]
    parse_and_verify_calculation_details(fully_capitalized_param, expected_calculation_details)
  end


  def test_should_raise_exception_when_as_keyword_is_not_found
    calculate_param = "'Column A' + 'Column B'"
    exception_message = "No alias found for equation: 'Column A' + 'Column B'"

    exception = nil
    begin
      CalculateParameterParser.parse(calculate_param)
    rescue => exception
    end

    assert exception
    assert_equal exception_message, exception.message
  end

  def test_should_return_empty_calculation_details_list_when_calculate_param_is_blank
    calculate_param = ""
    expected_calculation_details = []

    parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
  end

  def test_should_return_empty_calculation_details_when_calculate_param_is_null
    calculate_param = nil
    expected_calculation_details = []

    parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
  end

  def test_should_parse_multiple_calculation_details
    calculate_param = "Column A + Column B as Column C, Column A - Column B as Column D"
    expected_calculation_details = [CalculationDetails.new("Column C", "Column A + Column B"),
                                    CalculationDetails.new("Column D", "Column A - Column B")]

    parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
  end


  private

  def parse_and_verify_calculation_details(calculate_param, expected_calculation_details)
    calculation_details = CalculateParameterParser.parse(calculate_param)
    assert_equal expected_calculation_details, calculation_details
  end




end