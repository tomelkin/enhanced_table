require File.join(File.dirname(__FILE__), 'column_name_parser')
require File.join(File.dirname(__FILE__), 'result_formatter')
require File.join(File.dirname(__FILE__), 'row_parser')

class HtmlTableBuilder
  def self.build_html_table_from(table, mingle_project)
    html_table = "<table>"
    html_table << ColumnNameParser.build_html_table_header_from(table.column_names)
    html_table << RowParser.build_html_table_rows_from(table.rows, mingle_project)
    html_table << "</table>"
    return html_table
  end
end