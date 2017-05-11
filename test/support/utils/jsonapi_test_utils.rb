# frozen_string_literal: true
module JsonapiTestUtils
  def to_jsonapi(param_hash, type, id = nil)
    id = param_hash.delete('id') unless id
    id = param_hash.delete(:id) unless id
    relationships = param_hash.delete :rel
    hash = {
      data: {
        type: type,
        attributes: param_hash
      }
    }
    hash[:data][:id] = id if id

    if relationships
      hash[:data][:relationships] = {}
      relationships.each do |name, ids|
        hash[:data][:relationships][name.to_sym] = { data: [] }
        ids.each do |rel_id|
          hash[:data][:relationships][name.to_sym][:data].push(
            type: name, id: rel_id.to_s
          )
        end
      end
    end

    hash.to_json
  end
end
