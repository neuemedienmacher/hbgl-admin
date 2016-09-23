export default {
  index: {
    offer_translations: {
      fields: [
        'id', 'offer_id', 'locale', 'source', 'name',
        'possibly_outdated'//, 'updated_at', 'offer_section'
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
        'id', 'offer_id', 'locale', 'source', 'description',
        'possibly_outdated'//, 'updated_at', 'offer_section'
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
        'show', 'edit'
      ]
    },
  }
}
