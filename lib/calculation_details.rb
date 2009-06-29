class CalculationDetails

  attr_reader :new_column_name, :formula

  def initialize(new_column_name, formula)
    @new_column_name = new_column_name
    @formula = formula
  end

  def == (other)
      other.kind_of?(self.class) && other.new_column_name == @new_column_name && other.formula == @formula
  end
end