class NumberFormatter
  def self.format_value(value)
    if value =~ /^[+-]?\d+?(\.\d+)?$/
      "%g" % value
    else
      value
    end
  end
end