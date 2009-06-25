require File.join(File.dirname(__FILE__), 'unit_test_helper')
require LibDirectory.file("column_renamer")

class ColumnRenamerTest < Test::Unit::TestCase
  def setup
    @mql_results = [{"Header A"=> "Row 1A", "Header B" => "Row 1B"},
                    {"Header A"=> "Row 2A", "Header B" => "Row 2B"}]
  end

  def test_should_rename_column_when_column_name_exist_in_renaming_map
    renaming_map = {"Header A" => "Header A renamed", "Header B" => "Header B renamed"}

    expected_results = [{"Header A renamed" => "Row 1A", "Header B renamed" => "Row 1B"},
                        {"Header A renamed" => "Row 2A", "Header B renamed" => "Row 2B"}]
    results = ColumnRenamer.rename(@mql_results, renaming_map)

    assert_equal expected_results, results

  end

  def test_should_not_rename_column_when_column_name_does_not_exist_in_renaming_map
    renaming_map = {"Header A" => "Header A renamed"}
    
    expected_results = [{"Header A renamed" => "Row 1A", "Header B" => "Row 1B"},
                        {"Header A renamed" => "Row 2A", "Header B" => "Row 2B"}]
    results = ColumnRenamer.rename(@mql_results, renaming_map)

    assert_equal expected_results, results
  end
end