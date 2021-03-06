# frozen_string_literal: true

module Hyrax
  class PermissionTemplateAccess < ActiveRecord::Base
    self.table_name = 'permission_template_accesses'
    belongs_to :permission_template
    before_destroy :check_if_admin_group

    VIEW = 'view'.freeze
    DEPOSIT = 'deposit'.freeze
    MANAGE = 'manage'.freeze

    enum(
      access: {
        VIEW => VIEW,
        DEPOSIT => DEPOSIT,
        MANAGE => MANAGE
      }
    )

    def label
      return agent_id unless agent_type == 'group'
      case agent_id
      when 'registered'
        I18n.t('hyrax.admin.admin_sets.form_participant_table.registered_users')
      when ::Ability.admin_group_name
        I18n.t('hyrax.admin.admin_sets.form_participant_table.admin_users')
      else
        agent_id
      end
    end

    def admin_group?
      agent_type == 'group' && agent_id == ::Ability.admin_group_name
    end

    private

      def check_if_admin_group
        return true unless admin_group?
        errors[:base] << I18n.t('hyrax.admin.admin_sets.form.permission_destroy_errors.admin_group')
        throw :abort
      end
  end
end
