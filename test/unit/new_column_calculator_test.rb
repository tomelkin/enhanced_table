require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('new_column_calculator')


class NewColumnCalculatorTest < Test::Unit::TestCase

  def setup
    @query_results = [{"Column A" => 1, "Column B" => 2}]
  end

  def test_should_add_columns_value_and_add_a_new_column_to_the_results
    calculate_param = "'Column A' + 'Column B' as 'Column C'"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 3)
  end

  def test_should_subtract_column_values_and_add_a_new_column_to_the_results
    calculate_param = "'Column A' -'Column B' as 'Column C'"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", -1)
  end

  def test_should_multiply_column_values_and_add_a_new_column_to_the_results
    calculate_param = "'Column A' * 'Column B' as 'Column C'"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 2)
  end

  def test_should_divide_column_values_and_add_new_column_to_the_results
    calculate_param = "'Column A' / 'Column B' as 'Column C'"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 0.5)
  end

  def test_should_support_brackets_in_equations
    calculate_param = "Column A * (Column A + Column B) as Column C"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 3)
  end

  def test_should_raise_exception_when_as_keyword_does_not_exist
    calculate_param = "'Column A' + 'Column B'"
    exception_message = "No alias found for equation: 'Column A' + 'Column B'"

    calculate_new_column_expecting_exception(calculate_param, exception_message)
  end

  def test_should_raise_exception_if_equation_contains_nonexistent_column_name
    calculate_param = "'Column A' + 'Misspelt Column B' as 'Column C'"
    exception_message = "No such column: 'Misspelt Column B' in #{calculate_param}"

    calculate_new_column_expecting_exception(calculate_param, exception_message)
  end

  def test_handle_column_names_with_as_keyword_embedded_in_them
    @query_results = [{'Base' => 7, 'Column B' => 2}]
    calculate_param = "'Base' + 'Column B' as 'Column C'"

    calculate_and_verify_producing_new_column(calculate_param, "Column C", 9)
  end

  def test_handle_column_names_with_other_column_names_embedded_in_them
    @query_results = [{'table' => 5, 'stable' => 7}]
    calculate_param = "table * stable as answer"

    calculate_and_verify_producing_new_column(calculate_param, "answer", 35)
  end

  def test_should_process_calculation_when_column_name_does_not_have_quotes
    calculate_param = "Column A + 'Column B' as 'Column C'"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 3)
  end

  def test_should_calculate_new_column_given_a_multiple_operator_in_param
    calculate_param = "Column A - Column B + Column A as Column C"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 0)
  end

  def test_should_raise_exception_when_an_equation_uses_column_with_non_numeric_values
    @query_results = [{"Column A" => "string", "Column B" => 2}]
    calculate_param = "Column A + Column B as Column C"
    exception_message = "Column A contains a non-numeric value, 'string'"

    calculate_new_column_expecting_exception(calculate_param, exception_message)
  end

  def test_should_return_original_results_when_calculate_params_is_nil
    calculate_param = nil
    NewColumnCalculator.add_calculated_columns!(@query_results, calculate_param)

    assert_equal [{"Column A" => 1, "Column B" => 2}], @query_results
  end

  def test_should_calculate_new_column_given_multiple_equations
    expected_results = [{"Column A" => 1, "Column B" => 2, "Column C" => 3, "Column D" => -1}]
    calculate_param = "Column A + Column B as Column C, Column A - Column B as Column D"

    NewColumnCalculator.add_calculated_columns!(@query_results, calculate_param)
    assert_equal expected_results, @query_results
  end

  def test_should_handle_multiple_rows
    @query_results = [{"Column A" => 2, "Column B" => 1},
                      {"Column A" => 4, "Column B" => 3}]
    calculate_param = "Column A + Column B as Column C"

    expected_results = [{"Column A" => 2, "Column B" => 1, "Column C" => 3},
                        {"Column A" => 4, "Column B" => 3, "Column C" => 7}]

    NewColumnCalculator.add_calculated_columns!(@query_results, calculate_param)
    assert_equal expected_results, @query_results
  end

  def test_should_handle_multiple_rows_with_multiple_equations
    @query_results = [{"Column A" => 2, "Column B" => 1},
                      {"Column A" => 4, "Column B" => 3}]
    calculate_param = "Column A + Column B as Column C, Column A * Column B as Column D"

    expected_results = [{"Column A" => 2, "Column B" => 1, "Column C" => 3, "Column D" => 2},
                        {"Column A" => 4, "Column B" => 3, "Column C" => 7, "Column D" => 12}]

    NewColumnCalculator.add_calculated_columns!(@query_results, calculate_param)
    assert_equal expected_results, @query_results
  end

  def test_should_treat_nil_values_as_zero_for_calculations
    @query_results = [{"Column A" => 10, "Column B" => nil}]
    calculate_param = "Column A + Column B as Column C"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 10)
  end

  def test_should_raise_exception_when_trying_to_evaluate_a_non_numeric_expression
    begin
      NewColumnCalculator.validate_is_numeric('Dir.pwd')
    rescue => exception
    end

    assert exception
    assert_equal "Trying to evaluate a non-numeric expression! 'Dir.pwd'", exception.message
  end

  def test_should_handle_different_keyword_capitalizations
    fully_capitalized_param = "Column A + Column B AS Column C"
    calculate_and_verify_producing_new_column(fully_capitalized_param, "Column C", 3)
  end

  def test_should_handle_equations_containing_numeric_literals
    calculate_param = "Column A * 10 / 2 as Column C"
    calculate_and_verify_producing_new_column(calculate_param, "Column C", 5)
  end

  private

  def calculate_and_verify_producing_new_column(calculate_param, new_column_name, new_column_value)
    expected_results = duplicate_original_results_and_add_new_column(new_column_name, new_column_value)
    NewColumnCalculator.add_calculated_columns!(@query_results, calculate_param)

    assert_equal expected_results, @query_results
  end

  def duplicate_original_results_and_add_new_column(column_name, column_value)
    expected_results = []
    row = @query_results.first.dup
    row[column_name] = column_value
    expected_results << row
    return expected_results
  end

  def calculate_new_column_expecting_exception(calculate_param, exception_message)
    begin
      results = NewColumnCalculator.add_calculated_columns!(@query_results, calculate_param)
    rescue => exception
    end

    assert exception
    assert_equal exception_message, exception.message
  end

end