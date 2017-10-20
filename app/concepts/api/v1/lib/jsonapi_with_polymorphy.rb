# frozen_string_literal: true

module API::V1
  module Lib
    module JsonapiWithPolymorphy
      def to_hash(_options = {})
        hash = super
        return hash if !hash['relationships'] && !hash['data']['relationships']

        scan_and_modify_relationships_for_polymorphy!(hash) do |rel, id|
          hash['included'].map! do |e|
            if e['type'] == 'polymorphic' && e['id'] == id
              e['type'] = relationship_type(rel)
            end
            e
          end
          relationship_type(rel)
        end
      end

      private

      def scan_and_modify_relationships_for_polymorphy!(hash, &block)
        modify_each_relationship(hash) do |rel, data|
          {
            'data' =>
              if data['data'].is_a?(Array)
                data['data'].map { |datum| modify_type(datum, rel, &block) }
              elsif data['data'].is_a?(Hash)
                modify_type(data['data'], rel, &block)
              end
          }
        end
      end

      def modify_each_relationship(hash)
        if hash['data'] && hash['data']['relationships']
          hash['data']['relationships'].each do |rel, data|
            hash['data']['relationships'][rel] = yield rel, data
          end
        elsif hash['relationships']
          hash['relationships'].each do |rel, data|
            hash['relationships'][rel] = yield rel, data
          end
        end
        hash
      end

      def modify_type(data, relationship_name)
        if data['type'] == 'polymorphic'
          data['type'] = yield relationship_name, data['id']
        end
        data
      end

      def relationship_type(name)
        relationship_result = represented.send(name)
        if relationship_result.is_a?(Array)
          relationship_result = relationship_result.first
        end
        relationship_result.class.table_name.dasherize
      end
    end
  end
end
