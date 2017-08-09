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
        'id', 'offer-id', 'locale', 'source', 'name', 'offer_stamp',
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
        'id', 'organization-id', 'locale', 'source', 'description',
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
        'show', 'old-backend-edit'
      ]
    },

    locations: {
      fields: [
        'id', 'name', 'street', 'addition', 'zip', 'hq', 'visible', 'in-germany',
        { 'federal-state': ['name'] }, { organization: ['name'] },
        { city: ['name'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    cities: {
      fields: [
        'id', 'name'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    'federal-states': {
      fields: [
        'id', 'name'
      ],
      general_actions: [
        'index', 'export',
      ],
      member_actions: [
        'show'
      ]
    },

    'contact-people': {
      fields: [
        'id', 'first-name', 'last-name', { organization: ['name'] },
        { email: ['address'] }, 'area-code-1', 'local-number-1', 'area-code-2',
        'local-number-2'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    emails: {
      fields: [
        'id', 'address'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show'
      ]
    },

    users: {
      fields: [
        'id', 'name', 'email', { 'user-teams': ['name'] },
        { 'observed-user-teams': ['name'] }
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
        'id', {
          'current-assignment': {
            receiver: ['name'], 'receiver-team': ['name']
          }
        }, 'offers-count', 'name', 'aasm-state', 'pending-reason',
        'locations-count'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    divisions: {
      fields: [
        'id', {
          'current-assignment': {
            receiver: ['name'], 'receiver-team': ['name']
          }
        }, { organization: ['name'] }, { section: ['identifier'] },
        { city: ['name'] }, { area: ['name'] }, 'size', 'done', 'addition'
      ],
      general_actions: [
        'index', 'export', 'new',
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    'user-teams': {
      fields: [
        'id', 'name', 'classification', { users: ['name'] },
        { 'observing-users': ['name'] }
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
        'id', 'assignable-id', 'assignable-type', {assignable: ['label']},
        {creator: ['name']}, {'creator-team': ['name']}, {receiver: ['name']},
        {'receiver-team': ['name']}, 'message', 'topic', 'aasm-state',
        'created-at', 'updated-at'
      ],
      inline_fields: [
        'assignable-type', 'assignable-id', 'topic',
        {assignable: ['label']}, {creator: ['name']},  {receiver: ['name']},
        {'receiver-team': ['name']}, 'message', 'updated-at'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show-assignable', 'edit-assignable'
      ]
    },

    sections: {
      fields: [
        'id', 'name', 'identifier'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ],
    },

    categories: {
      fields: [
        'id', 'name-de', 'sort-order', 'visible', 'parent-id'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },

    'solution-categories': {
      fields: [
        'id', 'name', 'parent-id'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },

    websites: {
      fields: [
        'id', 'host', 'url'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show', 'open_url'
      ]
    },
  },

  OPERATORS: ['=', '!=', '<', '>'],
  SECTIONS: ['family', 'refugees'],
  AFTER_SAVE_ACTIONS: {
    'to_edit': 'Bei dieser Instanz bleiben',
    'to_table': 'Zurück zur Tabelle',
    'to_new': 'Neues Objekt anlegen'
  }
}
