require File.join(File.dirname(__FILE__), 'table_header_builder')
require File.join(File.dirname(__FILE__), 'result_formatter')
require File.join(File.dirname(__FILE__), 'table_rows_builder')

class HtmlTableBuilder
  def self.build_html_table_from(table)
    html_table = "<table>"
    html_table << TableHeaderBuilder.build_html_table_header_from(table)
    html_table << TableRowsBuilder.build_html_table_rows_from(table)
    html_table << "</table>"
    return html_table
  end
end