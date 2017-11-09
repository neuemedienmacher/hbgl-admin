# frozen_string_literal: true

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Delete < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :route_fragment do
          'delete'
        end

        register_instance_option :http_methods do
          %i[get delete]
        end

        register_instance_option :authorization_key do
          :destroy
        end

        register_instance_option :controller do
          proc do
            if request.get? # DELETE

              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, layout: false }
              end

            elsif request.delete? # DESTROY

              redirect_path = nil
              # NOTE Hacky hack: change redirect path for
              # TargetAudienceFiltersOffer (redirect to connected offer)
              redirect_to_special_path =
                @object.class == TargetAudienceFiltersOffer
              @auditing_adapter && @auditing_adapter.delete_object(
                @object, @abstract_model, _current_user
              )
              if @object.destroy
                flash[:success] = t(
                  'admin.flash.successful', name: @model_config.label,
                                            action: t(
                                              'admin.actions.delete.done'
                                            )
                )
                if redirect_to_special_path && @object.offer_id.present?
                  redirect_path = "/offers/#{@object.offer_id}/edit"
                else
                  redirect_path = index_path
                end
              else
                flash[:error] = t(
                  'admin.flash.error', name: @model_config.label, action: t(
                    'admin.actions.delete.done'
                  )
                )
                redirect_path = back_or_index
              end

              redirect_to redirect_path

            end
          end
        end

        register_instance_option :link_icon do
          'icon-remove'
        end
      end
    end
  end
end
