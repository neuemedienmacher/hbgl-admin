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
        'possibly-outdated', { offer: ['approved-at', 'created-by'] }
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
        'possibly-outdated', { organization: ['approved-at'] }
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

    openings: {
      fields: [
        'name', 'day', 'open', 'close', 'sort-value'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    definitions: {
      fields: [
        'key', 'explanation'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    tags: {
      fields: [
        'name-de', 'keywords-de', 'explanations-de', 'name-en', 'keywords-en',
        'explanations-en'
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
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

    'solution-categories': {
      association_model_mapping: { parent: 'solution-categories' },
      fields: [
        'id', 'name', { parent: ['name'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit'
      ]
    },

    users: {
      association_model_mapping: {
        'observed-user-teams': 'user-teams'
      },
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
      association_model_mapping: {
        'current-assignment': 'assignments', receiver: 'users',
        'receiver-team': 'user-teams'
      },
      fields: [
        'id', {
          'current-assignment': {
            receiver: ['name'], 'receiver-team': ['name']
          }
        }, 'offers-count', 'name', 'aasm-state', 'pending-reason',
        'locations-count', { topics: ['name'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'edit', 'preview'
      ]
    },

    divisions: {
      association_model_mapping: {
        'current-assignment': 'assignments', receiver: 'users',
        'receiver-team': 'user-teams', 'presumed-categories': 'categories',
        'presumed-solution-categories': 'solution-categories'
      },
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
        'show', 'edit', 'delete'
      ]
    },

    'user-teams': {
      association_model_mapping: {
        'observing-users': 'users', parent: 'users', lead: 'users'
      },
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
      association_model_mapping: {
        creator: 'users', receiver: 'users',
        'receiver-team': 'user-teams', 'creator-team': 'user-teams'
      },
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

    'split-bases': {
      fields: [
        'id', 'title', 'clarat-addition', 'comments',
        { divisions: ['display-name'] }, { 'solution-category': ['name'] }
      ],
      general_actions: [
        'index', 'export', 'new'
      ],
      member_actions: [
        'show', 'old-backend-edit'
      ]
    },


    subscriptions: {
      fields: [
        'id', 'email', 'created-at', 'updated-at'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },

    'update-requests': {
      fields: [
        'id', 'search-location', 'email', 'created-at', 'updated-at'
      ],
      general_actions: [
        'index'
      ],
      member_actions: [
        'show'
      ]
    },
  },

  OPERATORS: ['=', '!=', '<', '>', '...'],
  SECTIONS: ['family', 'refugees'],
  AFTER_SAVE_ACTIONS: {
    'to_edit': 'Bei dieser Instanz bleiben',
    'to_table': 'Zurück zur Tabelle',
    'to_new': 'Neues Objekt anlegen'
  }
}
