require "unit_test_helper"
require LibDirectory.file("result_manipulator")
require LibDirectory.file("column_renamer")
require LibDirectory.file("renaming_map_builder")
require LibDirectory.file("new_column_calculator")


class ResultManipulatorTest < Test::Unit::TestCase

  def setup
    @renaming_param = "some param as other name"
    @calculate_param = "'some column' + 'some other column' as Total"
    @mql_results = "some array of results"
    @renamed_results = "some processed results"
    @renaming_map = "some map"
    @final_results = "final results"
  end
  
  def test_should_rename_and_create_calculated_column
    RenamingMapBuilder.expects(:build_renaming_map_from).with(@renaming_param).returns(@renaming_map)
    ColumnRenamer.expects(:rename).with(@mql_results, @renaming_map).returns(@renamed_results)
    NewColumnCalculator.expects(:add_calculated_columns!).with(@renamed_results, @calculate_param)
    
    assert_equal @renamed_results, ResultManipulator.process(@mql_results, @renaming_param, @calculate_param)
  end
end