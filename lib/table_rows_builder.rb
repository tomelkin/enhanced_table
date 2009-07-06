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
    cell_html = ""
    if (table.bg_color_enabled? && !cell.color.empty?)
      cell_html << "<td style='background-color:\##{cell.color}'>#{cell.value}</td>"
    elsif table.text_color_enabled? && !cell.color.empty?
      cell_html << "<td style='color:\##{cell.color}'>#{cell.value}</td>"
    else
      cell_html << "<td>#{cell.value}</td>"
    end

    return cell_html
  end
end