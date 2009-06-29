require File.join(File.dirname(__FILE__), 'column_name_parser')
require File.join(File.dirname(__FILE__), 'result_formatter')
require File.join(File.dirname(__FILE__), 'row_parser')

class HtmlTableBuilder
  def self.build_html_table_from(table, mingle_project)
    records = table.records
    html_table = "<table>"

    html_table << ColumnNameParser.build_html_table_header_from(table.column_names)
    formatted_result = ResultFormatter.format_result(records)
    html_table << RowParser.parse_rows_from(formatted_result, mingle_project)

    html_table << "</table>"
    return html_table
  end
end