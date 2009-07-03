class TableRowsBuilder
  def self.build_html_table_rows_from(table_rows)
    html = ""
    table_rows.each do |row|
      row_string = "<tr>"
      row.each do |cell|
        if not cell.color.empty?
          row_string << "<td style='color:#{cell.color}'>#{cell.value}</td>"
        else
          row_string << "<td>#{cell.value}</td>"
        end
      end
      row_string << "</tr>"
      html << row_string
    end
    return html
  end
end