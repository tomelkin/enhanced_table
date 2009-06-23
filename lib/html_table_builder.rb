class HtmlTableBuilder
  def self.build_table_from(mql_result, mingle_project, renaming_param)
    exception = nil
    begin
      renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    rescue ArgumentError => exception
      return "<p>" + exception.message + "</p>"
    end

    table = "<table>"

    table << ColumnNameParser.parse_table_header_from(mql_result, renaming_map)
    formatted_result = ResultFormatter.format_result(mql_result)
    table << RowParser.parse_rows_from(formatted_result, mingle_project)

    table << "</table>"
    return table
  end
end