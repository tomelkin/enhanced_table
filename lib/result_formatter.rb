require File.join(File.dirname(__FILE__), 'mql_date_formatter')
require File.join(File.dirname(__FILE__), 'number_formatter')

class ResultFormatter

  def self.format_result(rows)

    results = []
    rows.each do |row|
      formatted_row = {}
      row.keys.each do |key|
        formatted_value = row[key]
        formatted_value = MqlDateFormatter.format_value(formatted_value)
        formatted_value = NumberFormatter.format_value(formatted_value)
        formatted_row[key] = formatted_value
      end
      results << formatted_row
    end
    results
  end
end