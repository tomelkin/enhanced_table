require "unit_test_helper"
require LibDirectory.file('table_rows_builder')

class TableRowsBuilderTest < Test::Unit::TestCase

  def setup
    @project = mock()
  end

  def test_should_produce_html_rows_from_mql_result
    table_rows = [["Row 1A", "Row 1B"], ["Row 2A", "Row 2B"]]

    expected_html = "<tr><td>Row 1A</td><td>Row 1B</td></tr>" +
            "<tr><td>Row 2A</td><td>Row 2B</td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(table_rows)
  end

  def test_should_create_empty_cell_when_a_value_is_nil
    table_rows = [["Row 1A", nil]]
    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(table_rows)
  end

  def test_should_create_empty_cell_when_a_value_is_an_empty_string
    table_rows = [["Row 1A", ""]]
    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(table_rows)
  end
  
end