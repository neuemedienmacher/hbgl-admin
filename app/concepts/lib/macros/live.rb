# frozen_string_literal: true

module Lib
  module Macros
    module Live
      def self.SendChanges
        step = ->(_, model:, **) do
          broadcast_change(model, changes(model))

          true
        end

        [step, name: 'live.send_changes']
      end

      def self.SendCreation
        step = ->(_, model:, **) do
          broadcast_to_changes_channel(
            'addition', model, json: show_representer(model).to_hash
          )

          true
        end

        [step, name: 'live.send_creation']
      end

      def self.SendDeletion
        step = ->(_, model:, **) do
          broadcast_to_changes_channel('deletion', model, id: model.id)

          true
        end

        [step, name: 'live.send_deletion']
      end

      def self.broadcast_change model, data
        broadcast_to_changes_channel(
          'change', model, id: model.id, changes: data
        )
      end

      def self.broadcast_to_changes_channel action, model, options
        ActionCable.server.broadcast(
          'changes',
          options.merge(
            model: model.class.table_name.dasherize, action: action
          )
        )
      end

      private_class_method

      def self.changes(model)
        model.saved_changes.map do |attribute, change|
          [attribute.dasherize, change[1]]
        end.to_h
      end

      def self.show_representer model
        "API::V1::#{model.class.name}::Representer::Show".constantize.new model
      end
    end
  end
end
