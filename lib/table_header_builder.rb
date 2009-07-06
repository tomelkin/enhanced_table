class TableHeaderBuilder
  def self.build_html_table_header_from(table)
    column_string = "<tr>"
    table.column_names.each do |column|
      column_string << "<th>#{column}</th>"
    end
    column_string << "</tr>"
    return column_string
  end
end