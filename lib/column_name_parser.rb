class ColumnNameParser
  def self.parse_table_header_from(mql_result, renaming_map = {})
    column_names = mql_result.first.keys
    column_string = "<tr>"
    column_names.each do |column|
      if renaming_map.has_key? column
        column_string << "<th>#{renaming_map[column]}</th>"
      else
        column_string << "<th>#{column}</th>"
      end
    end
    column_string << "</tr>"
    return column_string
  end
end