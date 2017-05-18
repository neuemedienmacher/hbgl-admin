export default {
  index: {
    assignable: {
      'assignment-actions': [
        'assign-someone-else', 'retrieve-assignment', 'assign-to-system',
        'assign-to-current-user'
      ]
    },

    'offer-translations': {
      fields: [
        'id', 'offer-id', 'locale', 'source', 'name',
        'possibly-outdated', {offer: ['approved-at', 'created-by']}
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    'organization-translations': {
      fields: [
        'id', 'organization_id', 'locale', 'source', 'description',
        'possibly-outdated', {organization: ['approved-at']}
      ],
      general_actions: [
        'index', 'export'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    'statistic-charts': {
      fields: [
        'id', 'title', 'ends-at', 'target-model', 'target-field-name'
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
        'id', 'name', 'aasm-state', 'created-by', 'expires-at',
        'logic-version-id', { section: ['name'] }
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
        'id', 'name', 'email', { 'user-teams': ['name'] }
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },

    organizations: {
      fields: [
        'id', 'offers-count', 'name', 'aasm-state', 'locations-count'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    divisions: {
      fields: [
        'id', 'name', { organization: ['name'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    'user-teams': {
      fields: [
        'id', 'name', 'classification', { users: ['name'] }
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
        'id', 'assignable-id', 'assignable-type', 'creator-id', 'creator-team-id',
        'receiver-id', 'receiver-team-id', 'message', 'topic', 'aasm-state',
        'created-at'
      ],
      inline_fields: [
        'assignable-type', 'assignable-id', 'topic',
        {assignable: ['label', 'created-at']},
        {creator: ['name']}, 'message', 'created-at'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'edit_assignable'
      ]
    },
  },

  OPERATORS: ['=', '!=', '<', '>'],

  SECTIONS: ['family', 'refugees'],
}
