class ResultManipulator
  def self.process(mql_results, renaming_param, calculate_param)
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    results = ColumnRenamer.rename(mql_results, renaming_map)
    new_results = NewColumnCalculator.add_calculated_columns!(results, calculate_param)
    return results
  end
end