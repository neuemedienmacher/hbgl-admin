# frozen_string_literal: true

module API::V1
  module Lib
    module Populators
      Find = ->(input, options) do
        populate_object(input, options, false)
      end

      FindOrInstantiate = ->(input, options) do
        populate_object(input, options, true)
      end

      private_class_method

      def self.populate_object(input, options, fallback_to_instantiation)
        populatable = object(input, options, fallback_to_instantiation)

        if options[:binding].array?
          # represented.songs[i] = model
          new_array = options[:represented].send(options[:binding].getter).to_a
          new_array.push(populatable)
          set_on_represented(options, new_array)
        else
          # represented.song = model
          set_on_represented(options, populatable)
        end

        populatable
      end

      def self.object_class(input, options)
        options[:binding][:class].(input, options)
      end

      def self.object(input, options, fallback_to_instantiation)
        if fallback_to_instantiation && !input['id']
          object_class(input, options).new
        else
          object_class(input, options).find(input['id'])
        end
      end

      def self.set_on_represented options, settee
        options[:represented].send(options[:binding].setter, settee)
      end
    end
  end
end
