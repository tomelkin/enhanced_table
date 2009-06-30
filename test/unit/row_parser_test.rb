require "unit_test_helper"
require LibDirectory.file('row_parser')

class RowParserTest < Test::Unit::TestCase

  def setup
    @project = mock()
  end

  def test_should_produce_html_rows_from_mql_result
    table_rows = [["Row 1A", "Row 1B"], ["Row 2A", "Row 2B"]]

    expected_html = "<tr><td>Row 1A</td><td>Row 1B</td></tr>" +
            "<tr><td>Row 2A</td><td>Row 2B</td></tr>"

    assert_equal expected_html, RowParser.build_html_table_rows_from(table_rows, @project)
  end

  def test_should_create_empty_cell_when_a_value_is_nil
    table_rows = [["Row 1A", nil]]
    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, RowParser.build_html_table_rows_from(table_rows, @project)
  end

  def test_should_create_empty_cell_when_a_value_is_an_empty_string
    table_rows = [["Row 1A", ""]]
    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, RowParser.build_html_table_rows_from(table_rows, @project)
  end

  def test_should_format_date_value_based_on_project_date_format
    date = Date.new(2008, 1, 1)
    table_rows = [[date]]

    @project.expects(:format_date_with_project_date_format).with(date).returns("01 Jan 2008")

    expected_html = "<tr><td>01 Jan 2008</td></tr>"
    assert_equal expected_html, RowParser.build_html_table_rows_from(table_rows, @project)
  end


end