class Cell

  attr_reader :value
  
  def initialize value
    @value = value
  end

  def == other
    other.kind_of?(self.class) && other.value == @value
  end
  #Code here
end