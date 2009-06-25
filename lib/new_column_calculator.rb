class NewColumnCalculator
  NUMBER_REGEX = /^[+-]?\d+?(\.\d+)?$/
  
  def self.add_calculated_columns!(results, calculate_param)
    if calculate_param != nil
      calculations = calculate_param.split(',')
      calculations.each do |calculation|
        process_calculation(calculation, results)
      end
    end
  end

  def self.validate_is_numeric(equation)
    if !equation.match(/^[\s\+\*\-\/%0123456789\.\(\)]*$/)
      raise ArgumentError.new("Trying to evaluate a non-numeric expression! '#{equation}'")
    end
  end


  private

  def self.process_calculation(calculate_param, results)
    equation = get_equation(calculate_param)
    calculated_column_name = get_calculated_column_name(calculate_param)
    identifiers = get_identifiers(equation)

    results.each do |row|
      expression = equation.dup
      identifiers.each do |identifier|
        if (is_not_a_number?(identifier))
          if !row.has_key? identifier
            raise ArgumentError.new("No such column: '#{identifier}' in #{calculate_param}")
          end

          row_value = row[identifier]
          row_value = 0 if row_value == nil

          validate_row_value(identifier, row_value)

          pattern = Regexp.new('\b' + identifier+ '\b')
          expression.gsub!(pattern, row_value.to_f.to_s)
        end
      end

      validate_is_numeric(expression)
      calculated_value = eval expression
      row[calculated_column_name] = calculated_value
    end
  end

  def self.is_not_a_number?(value)
    return !(value =~ NUMBER_REGEX)
  end


  def self.get_calculated_column_name(calculate_param)
    calculate_tokens = calculate_param.split(/\bas\b/i)
    raise "No alias found for equation: #{calculate_param}" if calculate_tokens.size == 1
    column_name = calculate_tokens[1]
    column_name.delete!(%q/'"/)
    column_name.strip!

    return column_name;
  end

  def self.get_equation(calculate_param)
    result = calculate_param.split(/\bas\b/i).first
    result.delete!(%q/'"/)
    result.strip!

    return result
  end

  def self.get_identifiers(equation)
    identifiers = equation.split(/\+|-|\*|\//)
    identifiers.each do |identifier|
      identifier.delete!('()')
      identifier.strip!
    end

    return identifiers
  end


  def self.validate_row_value(identifier, row_value)
    if is_not_a_number? row_value.to_s
      raise ArgumentError.new("#{identifier} contains a non-numeric value, '#{row_value}'")
    end
  end
end
