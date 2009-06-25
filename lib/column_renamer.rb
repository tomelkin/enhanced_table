class ColumnRenamer
  def self.rename(mql_results, renaming_map)
    renamed_results = []
    mql_results.each do |row|
      renamed_row = {}
      row.keys.each do |column_name|
        if renaming_map.has_key? column_name
          renamed_row[renaming_map[column_name]] = row[column_name]
        else
          renamed_row[column_name] = row[column_name]
        end
      end
      renamed_results << renamed_row
    end
    return renamed_results
  end
end