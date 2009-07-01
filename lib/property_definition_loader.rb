class PropertyDefinitionLoader

  INCLUDED_PROPERTY_TYPES = [Mingle::PropertyDefinition::MANAGED_TEXT_TYPE,
                             Mingle::PropertyDefinition::MANAGED_NUMBER_TYPE]

  def initialize project
    @property_definition_map = {}
    project.property_definitions.each do |property|
      puts "property name: #{property.name}"
      if INCLUDED_PROPERTY_TYPES.include? property.type_description
        property.values.each do |value|
          puts "Value db_identifier: #{value.db_identifier}, color: #{value.color}"
        end

        @property_definition_map[property.name] = property
      end
    end
  end

  def load_property_for(identifier)
    @property_definition_map[identifier]
  end
end