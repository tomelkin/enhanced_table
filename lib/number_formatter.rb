class NumberFormatter
  def self.format_value(value)
    value_as_string = value.to_s
    if value_as_string =~ /^[+-]?\d+?(\.\d+)?$/
      "%g" % value_as_string
    else
      value
    end
  end
end