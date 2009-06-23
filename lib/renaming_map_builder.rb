class RenamingMapBuilder

  INVALID_RENAMING_PARAM_MESSAGE = "Invalid renaming parameter. Correct format: Column Name 1 as New Column Name 1, 'Column2' as 'Column Name 2'"

  def self.build_renaming_map_from(renaming_param)
    return {} if renaming_param == nil

    renaming_map = {}
    renaming_param.strip.split(',').each do |renaming_pair|
      renaming_map.merge!(get_mapping_from_pair renaming_pair)
    end
    
    return renaming_map
  end

  private

  def self.get_mapping_from_pair(renaming_pair)
    renaming_words = renaming_pair.split('as')
      if (renaming_words.size != 2)
        raise ArgumentError.new(INVALID_RENAMING_PARAM_MESSAGE)
      end
      create_map_from(renaming_words)
  end

  def self.create_map_from(renaming_words)
    renaming_map = {}
    renaming_words.each do |word|
      word.strip!
      word.delete!(%q/'"/)
    end
    renaming_map[renaming_words[0]] = renaming_words[1]
    return renaming_map
  end
end