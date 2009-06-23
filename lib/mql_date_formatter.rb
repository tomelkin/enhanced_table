class MqlDateFormatter

  def self.format_value(value)
    if value =~ /^\d{4}-\d{2}-\d{2}$/
      Date.parse(value)
    else
      value
    end
  end

end