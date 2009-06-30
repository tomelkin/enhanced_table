require File.join(File.dirname(__FILE__), 'mql_date_formatter')
require File.join(File.dirname(__FILE__), 'number_formatter')

class ResultFormatter

  def self.format_value(value)
    value = MqlDateFormatter.format_value(value)
    value = NumberFormatter.format_value(value)
  end
end