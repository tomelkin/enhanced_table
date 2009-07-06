require "unit_test_helper"
require LibDirectory.file('table_rows_builder')

class TableRowsBuilderTest < Test::Unit::TestCase

  RED = "ff0000"
  BLUE = "ff1111"

  def setup
    @project = mock
    @table = mock
    @table.stubs(:text_color_enabled?).returns(false)
    @table.stubs(:bg_color_enabled?).returns(false)
  end

  def test_should_produce_html_rows_from_array_of_cells
    table_rows = [[Cell.new("Row 1A", RED), Cell.new("Row 1B", BLUE)], [Cell.new("Row 2A", ""), Cell.new("Row 2B", "")]]
    @table.expects(:rows).returns(table_rows)

    expected_html = "<tr><td>Row 1A</td><td>Row 1B</td></tr>" +
            "<tr><td>Row 2A</td><td>Row 2B</td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(@table)
  end

  def test_should_produce_colored_html_rows_from_array_of_cells_when_text_color_is_enabled
    table_rows = [[Cell.new("Row 1A", RED), Cell.new("Row 1B", BLUE)], [Cell.new("Row 2A", ""), Cell.new("Row 2B", "")]]
    @table.expects(:rows).returns(table_rows)
    @table.stubs(:text_color_enabled?).returns(true)

    expected_html = "<tr><td style='color:##{RED}'>Row 1A</td><td style='color:##{BLUE}'>Row 1B</td></tr>" +
            "<tr><td>Row 2A</td><td>Row 2B</td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(@table)
  end

  def test_should_produce_html_with_colored_background_when_bg_color_is_enabled
    table_rows = [[Cell.new("Row 1A", RED), Cell.new("Row 1B", BLUE)], [Cell.new("Row 2A", ""), Cell.new("Row 2B", "")]]
    @table.expects(:rows).returns(table_rows)
    @table.stubs(:bg_color_enabled?).returns(true)

    expected_html = "<tr><td style='background-color:##{RED}'>Row 1A</td><td style='background-color:##{BLUE}'>Row 1B</td></tr>" +
            "<tr><td>Row 2A</td><td>Row 2B</td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(@table)
  end

  def test_should_create_empty_cell_when_a_value_is_nil
    table_rows = [[Cell.new("Row 1A", ""), Cell.new(nil, "")]]
    @table.expects(:rows).returns(table_rows)

    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(@table)
  end

  def test_should_create_empty_cell_when_a_value_is_an_empty_string
    table_rows = [[Cell.new("Row 1A", ""), Cell.new("", "")]]
    @table.expects(:rows).returns(table_rows)

    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, TableRowsBuilder.build_html_table_rows_from(@table)
  end

end