require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file('table')
require LibDirectory.file('calculation_details')
require LibDirectory.file('cell')


class TableTest < Test::Unit::TestCase
  def setup
    @mql_results = [{"Column A"=> "Row 1A", "Column B" => "Row 1B"},
                    {"Column A"=> "Row 2A", "Column B" => "Row 2B"}]
    @project = mock
    @property_definition_loader = mock
  end

  def test_should_give_back_array_of_cells_representing_table_rows
    default_expectations_for_property_definition_loader()
    @table = Table.new(@mql_results, @project)

    expected_rows = [[Cell.new("Column A", "Row 1A", "color 1A"), Cell.new("Column B", "Row 1B", "color 1B")],
                     [Cell.new("Column A", "Row 2A", "color 2A"), Cell.new("Column B", "Row 2B", "color 2B")]]

    assert_equal expected_rows,  @table.rows
  end

  def test_should_format_dates_and_number_when_getting_back_rows
    default_expectations_for_property_definition_loader()
    @table = Table.new(@mql_results, @project)

    ["Row 1A", "Row 1B", "Row 2A", "Row 2B"].each do |value|
      ResultFormatter.expects(:format_value).with(value).returns(value + " formatted")
    end

    expected_rows = [[Cell.new("Column A", "Row 1A formatted", "color 1A"), Cell.new("Column B", "Row 1B formatted", "color 1B")],
                     [Cell.new("Column A", "Row 2A formatted", "color 2A"), Cell.new("Column B", "Row 2B formatted", "color 2B")]]

    assert_equal expected_rows, @table.rows
  end

  def test_should_format_date_value_based_on_project_date_format
    date_as_string = "2008-01-01"
    date = Date.parse(date_as_string)
    mql_results = [{"Date Column" => date_as_string}]
    formatted_date = "01 Jan 2008"

    PropertyDefinitionLoader.expects(:new).with(@project, ["Date Column"]).returns(@property_definition_loader)
    ResultFormatter.expects(:format_value).with(date_as_string).returns(date)
    @project.expects(:format_date_with_project_date_format).with(date).returns(formatted_date)
    @property_definition_loader.expects(:get_color_for).with("Date Column", date_as_string).returns("a color")

    @table = Table.new(mql_results, @project)

    expected_rows = [[Cell.new("Date Column", "01 Jan 2008", "a color")]]
    assert_equal expected_rows, @table.rows
  end

  private

  def default_expectations_for_property_definition_loader()
    PropertyDefinitionLoader.expects(:new).with(@project, ['Column A', 'Column B']).returns(@property_definition_loader)
    @property_definition_loader.expects(:get_color_for).with("Column A", "Row 1A").returns("color 1A")
    @property_definition_loader.expects(:get_color_for).with("Column B", "Row 1B").returns("color 1B")
    @property_definition_loader.expects(:get_color_for).with("Column A", "Row 2A").returns("color 2A")
    @property_definition_loader.expects(:get_color_for).with("Column B", "Row 2B").returns("color 2B")
  end
end

class TableRenameColumnsTest < Test::Unit::TestCase

  def setup
    mql_results = [{"Column A"=> "Row 1A", "Column B" => "Row 1B"},
                   {"Column A"=> "Row 2A", "Column B" => "Row 2B"}]
    column_names = ['Column A', 'Column B']
    @project = mock
    @property_definition_loader = mock
    PropertyDefinitionLoader.expects(:new).with(@project, column_names).returns(@property_definition_loader)
    @table = Table.new(mql_results, @project)
  end

  def test_should_rename_column_when_column_name_exist_in_renaming_map
    renaming_map = {"Column A" => "Column A renamed", "Column B" => "Column B renamed"}

    expected_records = [{"Column A renamed" => "Row 1A", "Column B renamed" => "Row 1B"},
                        {"Column A renamed" => "Row 2A", "Column B renamed" => "Row 2B"}]

    @table.rename_columns(renaming_map)

    assert_equal expected_records, @table.records

  end

  def test_should_not_rename_column_when_column_name_does_not_exist_in_renaming_map
    renaming_map = {"Column A" => "Column A renamed"}

    expected_records = [{"Column A renamed" => "Row 1A", "Column B" => "Row 1B"},
                        {"Column A renamed" => "Row 2A", "Column B" => "Row 2B"}]

    @table.rename_columns(renaming_map)

    assert_equal expected_records, @table.records
  end

end

class TableAddCalculatedColumnTest < Test::Unit::TestCase

  def setup
    @mql_results = [{"Column A"=> "3", "Column B" => "2"}]
    @project = mock
    @property_definition_loader = mock 
    PropertyDefinitionLoader.stubs(:new).returns(@property_definition_loader)
    @table = Table.new(@mql_results, @project)
  end

  def test_should_add_columns_value_and_add_a_new_column
    calculation_details = CalculationDetails.new("Column C", "Column A + Column B")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 5)
  end

  def test_should_subtract_column_values_and_add_a_new_column
    calculation_details = CalculationDetails.new("Column C", "Column A - Column B")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 1)
  end

  def test_should_multiply_column_values_and_add_a_new_column
    calculation_details = CalculationDetails.new("Column C", "Column A * Column B")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 6)
  end

  def test_should_divide_column_values_and_add_a_new_column
    calculation_details = CalculationDetails.new("Column C", "Column A / Column B")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 1.5)
  end

  def test_should_support_brackets_in_equations
    calculation_details = CalculationDetails.new("Column C", "Column A * (Column A + Column B)")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 15)
  end

  def test_should_treat_nil_values_as_zero_for_calculations
    @mql_results = [{"Column A" => 10, "Column B" => nil}]
    @table = Table.new(@mql_results, @project)

    calculation_details = CalculationDetails.new("Column C", "Column A + Column B")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 10)
  end

  def test_should_handle_formulas_containing_numeric_literals
    calculation_details = CalculationDetails.new("Column C", "Column A * 10 / 2")
    calculate_and_verify_new_column_added(calculation_details, "Column C", 15)
  end

  def test_handle_column_names_with_other_column_names_embedded_in_them
    @mql_results = [{'table' => 5, 'stable' => 7}]
    @table = Table.new(@mql_results, @project)
    calculation_details = CalculationDetails.new("answer", "table * stable")
    calculate_and_verify_new_column_added(calculation_details, "answer", 35)
  end

  def test_should_handle_multiple_rows
    @mql_results = [{"Column A" => 2, "Column B" => 1},
                    {"Column A" => 4, "Column B" => 3}]

    calculation_details = CalculationDetails.new("Column C", "Column A + Column B")
    expected_results = [{"Column A" => 2, "Column B" => 1, "Column C" => 3},
                        {"Column A" => 4, "Column B" => 3, "Column C" => 7}]

    @table = Table.new(@mql_results, @project)
    @table.add_calculated_column(calculation_details)

    assert_equal expected_results, @table.records
  end


  def test_should_raise_exception_if_formula_contains_nonexistent_column_name
    calculation_details = CalculationDetails.new("Column C", "Column A + Misspelt Column B")
    exception_message = "No such column: 'Misspelt Column B' in #{calculation_details.formula}"

    begin
      @table.add_calculated_column(calculation_details)
    rescue => exception
    end

    assert exception
    assert_equal exception_message, exception.message
  end

  def test_should_raise_exception_when_a_formula_uses_column_with_non_numeric_values
    @mql_results = [{"Column A" => "string", "Column B" => 2}]
    @table = Table.new(@mql_results, @project)
    calculation_details = CalculationDetails.new("Column C", "Column A + Column B")
    exception_message = "Column A contains a non-numeric value, 'string'"

    begin
      @table.add_calculated_column(calculation_details)
    rescue => exception
    end

    assert exception
    assert_equal exception_message, exception.message
  end


  def test_should_raise_exception_when_trying_to_evaluate_a_non_numeric_expression
    Dir.expects(:pwd).never

    begin
      @table.eval 'Dir.pwd'
    rescue => exception
    end

    assert exception
    assert_equal "Trying to evaluate a non-numeric expression! 'Dir.pwd'", exception.message
  end


  private

  def calculate_and_verify_new_column_added(calculation_details, new_column_name, new_column_value)
    expected_records = duplicate_original_records_and_add_new_column(new_column_name, new_column_value)
    @table.add_calculated_column(calculation_details)
    assert_equal expected_records, @table.records
  end

  def duplicate_original_records_and_add_new_column(column_name, column_value)
    expected_results = []
    row = @mql_results.first.dup
    row[column_name] = column_value
    expected_results << row
    return expected_results
  end

end