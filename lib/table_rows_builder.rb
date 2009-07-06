class TableRowsBuilder
  def self.build_html_table_rows_from table
    html = ""
    rows = table.rows
    rows.each do |row|
      row_string = "<tr>"
      row.each do |cell|
        if table.text_color_enabled? && !cell.color.empty?
          row_string << "<td style='color:\##{cell.color}'>#{cell.value}</td>"
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