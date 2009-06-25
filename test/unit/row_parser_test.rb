require "unit_test_helper"
require LibDirectory.file('row_parser')

class RowParserTest < Test::Unit::TestCase

  def setup
    @project = mock()
  end

  def test_should_produce_html_rows_from_mql_result
    mql_result = [{"Header A" => "Row 1A", "Header B" => "Row 1B"},
                  {"Header A" => "Row 2A", "Header B" => "Row 2B"}]

    expected_html = "<tr><td>Row 1A</td><td>Row 1B</td></tr>" +
            "<tr><td>Row 2A</td><td>Row 2B</td></tr>"

    assert_equal expected_html, RowParser.parse_rows_from(mql_result, @project)
  end

  def test_should_create_empty_cell_when_a_value_is_nil
    mql_result = [{"Header A" => "Row 1A", "Header B" => nil}]
    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, RowParser.parse_rows_from(mql_result, @project)
  end

  def test_should_create_empty_cell_when_a_value_is_an_empty_string
    mql_result = [{"Header A" => "Row 1A", "Header B" => ""}]
    expected_html = "<tr><td>Row 1A</td><td></td></tr>"

    assert_equal expected_html, RowParser.parse_rows_from(mql_result, @project)
  end
  
  def test_should_format_date_value_based_on_project_date_format
    date = Date.new(2008, 1, 1)
    mql_result = [{"Date" => date}]

    @project.expects(:format_date_with_project_date_format).with(date).returns("01 Jan 2008")

    expected_html = "<tr><td>01 Jan 2008</td></tr>"
    assert_equal expected_html, RowParser.parse_rows_from(mql_result, @project)
  end


end