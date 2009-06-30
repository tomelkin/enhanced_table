class Table

  NUMBER_REGEX = /^[+-]?\d+?(\.\d+)?$/

  attr_reader :records

  def initialize mql_results
    @records = mql_results
  end

  def column_names
    @records.first.keys
  end

  def rows
    rows = []

    @records.each do |record|
      row = []
      record.keys.each do |column|
        row << ResultFormatter.format_value(record[column])
      end
      rows << row
    end

    return rows
  end

  def rename_columns(renaming_map)
    renamed_results = []
    @records.each do |row|
      renamed_row = {}
      row.keys.each do |column_name|
        if renaming_map.has_key? column_name
          renamed_row[renaming_map[column_name]] = row[column_name]
        else
          renamed_row[column_name] = row[column_name]
        end
      end
      renamed_results << renamed_row
    end

    @records = renamed_results
  end

  def add_calculated_column(calculation_details)
    formula = calculation_details.formula
    identifiers = get_identifiers(formula)

    @records.each do |record|
      expression = formula.dup
      identifiers.each do |identifier|
        if (is_not_a_number?(identifier))
          verify_column_exists(record, formula, identifier)
          row_value = record[identifier] || 0.0
          validate_row_value(identifier, row_value)

          pattern = Regexp.new('\b' + identifier+ '\b')
          expression.gsub!(pattern, row_value.to_f.to_s)
        end
      end
      record[calculation_details.new_column_name] = eval expression
    end
  end

  def eval expression
    validate_is_numeric expression
    super expression
  end

  private

  def validate_is_numeric(expression)
    if !expression.match(/^[\s\+\*\-\/%0123456789\.\(\)]*$/)
      raise ArgumentError.new("Trying to evaluate a non-numeric expression! '#{expression}'")
    end
  end

  def get_identifiers(equation)
    identifiers = equation.split(/\+|-|\*|\//)
    identifiers.each do |identifier|
      identifier.strip!
      identifier.delete!('()')
    end
  end

  def is_not_a_number?(value)
    return !(value =~ NUMBER_REGEX)
  end

  def verify_column_exists(record, formula, identifier)
    raise ArgumentError.new("No such column: '#{identifier}' in #{formula}") if not record.has_key? identifier
  end

  def validate_row_value(identifier, row_value)
    if is_not_a_number? row_value.to_s
      raise ArgumentError.new("#{identifier} contains a non-numeric value, '#{row_value}'")
    end
  end
end
