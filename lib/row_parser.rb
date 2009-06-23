class RowParser
  def self.parse_rows_from(formatted_results, mingle_project)
    html = ""
    formatted_results.each do |row|
      row_string = "<tr>"
      row.keys.each do |key|
        value = row[key]
        value = mingle_project.format_date_with_project_date_format(value) if value.is_a?(Date)
        row_string << "<td>#{value}</td>"
      end
      row_string << "</tr>"
      html << row_string
    end
    return html
  end
end