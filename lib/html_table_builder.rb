class HtmlTableBuilder
  def self.build_table_from(mql_result, mingle_project)
    column_string = ColumnNameParser.parse_table_header_from(mql_result)

    table = "<table>"
    table << column_string

    formatted_result = ResultFormatter.format_result(mql_result)

    table << RowParser.parse_rows_from(formatted_result, mingle_project)
    table << "</table>"
    return table
  end
end