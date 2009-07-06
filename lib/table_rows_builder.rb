class TableRowsBuilder

  def self.build_html_table_rows_from table
    html = ""
    rows = table.rows
    rows.each do |row|
      row_string = "<tr>"
      row.each do |cell|
        row_string << build_cell_html(cell, table)
      end
      row_string << "</tr>"
      html << row_string
    end
    return html
  end

  def self.build_cell_html(cell, table)
    cell_color_option = table.column_color_options[cell.column] || table.color_option
    if not cell.color.empty?
      case cell_color_option
        when 'off'
          "<td>#{cell.value}</td>"
        when 'text'
          "<td style='color:\##{cell.color}'>#{cell.value}</td>"
        when 'background'
          "<td style='background-color:\##{cell.color}'>#{cell.value}</td>"
      end
    else
      "<td>#{cell.value}</td>"
    end
  end

end