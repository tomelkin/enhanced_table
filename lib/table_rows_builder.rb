class TableRowsBuilder
  def self.build_html_table_rows_from(table_rows)
    html = ""
    table_rows.each do |row|
      row_string = "<tr>"
      row.each do |cell|
        row_string << "<td>#{cell.value}</td>"
      end
      row_string << "</tr>"
      html << row_string
    end
    return html
  end
end