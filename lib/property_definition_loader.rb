class PropertyDefinitionLoader

  INCLUDED_PROPERTY_TYPES = [Mingle::PropertyDefinition::MANAGED_TEXT_TYPE,
                             Mingle::PropertyDefinition::MANAGED_NUMBER_TYPE]


  def initialize project, column_names
    @property_definition_map = {}

    project.property_definitions.each do |property|
      if column_names.include?(property.name) && INCLUDED_PROPERTY_TYPES.include?(property.type_description)
        value_color_map = create_value_color_map(property)
        @property_definition_map[property.name] = value_color_map
      end
    end
  end

  def get_color_for(property_name, value)
    value_color_map = @property_definition_map[property_name]
    value_color_map ? value_color_map[value] || "" : ""
  end

  private

  def create_value_color_map(property)
    value_color_map = {}
    property.values.each do |value|
      begin
        value_color_map[value.db_identifier] = value.color
      rescue Exception
        raise Exception.new("Color for Property : '#{property.name}' and Value : '#{value.db_identifier}' is not set")
        end

    end

    return value_color_map
  end


end