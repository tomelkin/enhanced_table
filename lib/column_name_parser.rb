class ColumnNameParser
 def self.parse_table_header_from(mql_result)
    column_names = mql_result.first.keys
    column_string = "<tr>"
    column_names.each do |column|
      column_string << "<th>#{column}</th>"
    end
    column_string << "</tr>"
    return column_string
  end
end