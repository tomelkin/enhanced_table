class Cell

  attr_reader  :column, :value, :color
  
  def initialize column, value, color
    @column = column
    @value = value
    @color = color
  end

  def == other
    other.kind_of?(self.class) && other.column == @column && other.value == @value && other.color == @color 
  end
  #Code here
end