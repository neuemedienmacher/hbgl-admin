# frozen_string_literal: true
module JsonapiTestUtils
  def to_jsonapi(param_hash, type, id = nil)
    id = param_hash.delete('id') unless id
    id = param_hash.delete(:id) unless id
    relationships = param_hash.delete :rel
    dashed_params = param_hash.map { |k, v| [k.to_s.dasherize, v] }.to_h
    hash = {
      data: {
        type: type,
        attributes: dashed_params
      }
    }
    hash[:data][:id] = id if id

    if relationships
      hash[:data][:relationships] = {}
      relationships.each do |name, id_or_ids|
        hash[:data][:relationships][name.to_s.dasherize.to_sym] =
          { data:
            if id_or_ids.is_a?(Array)
              id_or_ids.map { |rel_id| relationship_object(name, rel_id) }
            else
              relationship_object(name, id_or_ids)
            end
          }
      end
    end

    hash.to_json
  end

  private

  def relationship_object(name, id)
    { type: name.to_s.pluralize.dasherize, id: id.to_s }
  end
end
