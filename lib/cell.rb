class Cell

  attr_reader :value, :color
  
  def initialize value, color
    @value = value
    @color = color
  end

  def == other
    other.kind_of?(self.class) && other.value == @value && other.color == @color
  end
  #Code here
end