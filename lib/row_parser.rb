class RowParser
  def self.build_html_table_rows_from(table_rows, mingle_project)
    html = ""
    table_rows.each do |row|
      row_string = "<tr>"
      row.each do |value|
        value = mingle_project.format_date_with_project_date_format(value) if value.is_a?(Date)
        row_string << "<td>#{value}</td>"
      end
      row_string << "</tr>"
      html << row_string
    end
    return html
  end
end