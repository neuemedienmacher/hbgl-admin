export default {
  index: {
    assignable: {
      assignment_actions: [
        'reply_to_assignment', 'assign_from_system', 'assign_to_current_user'
      ]
    },

    offer_translations: {
      fields: [
        'id', 'offer_id', 'locale', 'source', 'name',
        'possibly_outdated', {offer: ['approved_at', 'created_by']}
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'edit'
      ]
    },

    organization_translations: {
      fields: [
        'id', 'organization_id', 'locale', 'source', 'description',
        'possibly_outdated', {organization: ['approved_at']}
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'edit'
      ]
    },

    productivity_goals: {
      fields: [
        'id', 'title', 'ends_at', 'target_model', 'target_field_name'
      ],
      general_actions: [
        'index', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    offers: {
      fields: [
        'id', 'name', 'aasm_state', 'created_by', 'expires_at',
        'logic_version_id'
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'show'
      ]
    },

    users: {
      fields: [
        'id', 'name', 'email', 'user_teams'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },

    user_teams: {
      fields: [
        'id', 'name', 'users'
      ],
      general_actions: [
        'index', 'new',
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    assignments: {
      fields: [
        'id', 'assignable_id', 'assignable_type', 'creator_id', 'creator_team_id',
        'reciever_id', 'reciever_team_id', 'aasm_state', 'created_at'
      ],
      inline_fields: [
        'id', 'assignable_type', 'assignable_id', 'message', 'reciever_id',
        'reciever_team_id', 'aasm_state', 'created_at'
      ],
      general_actions: [
        'index', 'new'
      ],
      member_actions: [
        'show', 'edit_assignable'
      ]
    },
  }
}
