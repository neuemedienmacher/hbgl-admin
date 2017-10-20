# frozen_string_literal: true

class Definition::LinkAndInfuse < Trailblazer::Operation
  step :link_definition_to_object
  step :infuse_object_description

  def link_definition_to_object(options)
    found_definitions = []
    key_occurence = []
    string = options['string_to_infuse']
    Definition.select(:id, :key).find_each do |definition|
      # go through the set of keys for this definition
      occurences = key_occurrences_in string, definition.key
      # find the key that occurs first in the description and link models
      first_key, _first_index = occurences.min_by { |_key, index| index }
      if first_key
        found_definitions.push(definition)
        key_occurence.push(id: definition.id, key: first_key)
      end
    end
    options['object_to_link'].definitions = found_definitions
    options['definition_positions'] = key_occurence
  end

  def infuse_object_description(options)
    string = options['string_to_infuse']
    # infuse string
    options['definition_positions'].each do |occurence|
      regex = /\b(#{occurence[:key]})\b/i
      string.sub! regex,
                  "<dfn class='JS-tooltip' data-id='#{occurence[:id]}'>"\
                  '\1</dfn>'
    end
    options['infused_description'] = string
  end

  # helper functions

  def key_occurrences_in string, def_key
    occurences = {}
    keys(def_key).each do |key|
      occurence = string.downcase.index(/\b(#{key.downcase})\b/i)
      occurences[key] = occurence if occurence
    end
    occurences
  end

  # A definition can have multiple comma seperated keys. This method returns all
  # keys in an array.
  def keys(def_key)
    def_key.split(',').map(&:strip)
  end
end
