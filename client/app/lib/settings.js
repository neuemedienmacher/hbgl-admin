export default {
  index: {
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
      member_actions: []
    },
  }
}
