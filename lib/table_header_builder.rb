class TableHeaderBuilder
  def self.build_html_table_header_from(column_names)
    column_string = "<tr>"
    column_names.each do |column|
      column_string << "<th>#{column}</th>"
    end
    column_string << "</tr>"
    return column_string
  end
end