# frozen_string_literal: true
module API::V1
  module Lib
    module Populators
      Find = ->(input, options) do
        bind = options[:binding]

        object_class = bind[:class].(input, options)
        object       = object_class.find(input['id'])
        if options[:binding].array?
          # represented.songs[i] = model
          new_array = options[:represented].send(bind.getter).to_a
          new_array.push(object)
          options[:represented].send(bind.setter, new_array)
        else
          # represented.song = model
          options[:represented].send(bind.setter, object)
        end

        object
      end
    end
  end
end
