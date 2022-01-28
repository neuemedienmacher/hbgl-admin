const INDEX = 'index'
const EDIT = 'edit'
const SHOW = 'show'
const EXPORT = 'export'
const DELETE = 'delete'
const DUPLICATE = 'duplicate'
const PREVIEW = 'preview'
const NEW = 'new'
const MAILING = 'mailing'
const OPEN_URL = 'open_url'

export default {
  index: {
    'assignable': {
      'assignment-actions': [
        'assign-someone-else',
        'retrieve-assignment',
        'assign-to-system',
        'assign-to-current-user',
      ],
    },

    'offer-translations': {
      fields: [
        'id',
        'offer-id',
        'locale',
        'source',
        'name',
        'offer_stamp',
        'possibly-outdated',
        { offer: ['approved-at', 'created-by'] },
      ],
      general_actions: [INDEX, EXPORT],
      member_actions: [SHOW, EDIT],
    },

    'organization-translations': {
      fields: [
        'id',
        'organization-id',
        'locale',
        'source',
        'description',
        'possibly-outdated',
        { organization: ['approved-at'] },
      ],
      general_actions: [INDEX, EXPORT],
      member_actions: [SHOW, EDIT],
    },

    'offers': {
      fields: [
        'id',
        'name',
        { divisions: ['label'] },
        { 'solution-category': ['name'] },
        'aasm-state',
        'created-by',
        'expires-at',
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE, DUPLICATE, PREVIEW],
    },

    'locations': {
      fields: [
        'id',
        'name',
        'street',
        'addition',
        'zip',
        'hq',
        'visible',
        'in-germany',
        { 'federal-state': ['name'] },
        { organization: ['name'] },
        { city: ['name'] },
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'cities': {
      fields: ['id', 'name'],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT],
    },

    'openings': {
      fields: ['name', 'day', 'open', 'close', 'sort-value'],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'definitions': {
      fields: ['key', 'explanation'],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'tags': {
      fields: [
        'name-de',
        'keywords-de',
        'explanations-de',
        'name-en',
        'keywords-en',
        'explanations-en',
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'federal-states': {
      fields: ['id', 'name'],
      general_actions: [INDEX, EXPORT],
      member_actions: [SHOW],
    },

    'contact-people': {
      fields: [
        'id',
        'first-name',
        'last-name',
        { organization: ['name'] },
        { email: ['address', 'tos'] },
        'area-code-1',
        'local-number-1',
        'area-code-2',
        'local-number-2',
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'emails': {
      fields: ['id', 'address', 'tos'],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, DELETE, MAILING],
    },

    'areas': {
      fields: ['id', 'name', 'minlat', 'maxlat', 'minlong', 'maxlong'],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'next-steps': {
      fields: [
        'id',
        'text-de',
        'text-en',
        'text-ar',
        'text-fr',
        'text-ps',
        'text-tr',
        'text-fa',
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'solution-categories': {
      association_model_mapping: { parent: 'solution-categories' },
      fields: ['id', 'name', { parent: ['name'] }],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'users': {
      association_model_mapping: {
        'observed-user-teams': 'user-teams',
      },
      fields: [
        'id',
        'name',
        'email',
        { 'user-teams': ['name'] },
        { 'observed-user-teams': ['name'] },
      ],
      general_actions: [INDEX],
      member_actions: [SHOW],
    },

    'search-locations': {
      fields: [
        'id',
        'query',
        'latitude',
        'longitude',
        'created-at',
        'updated-at',
      ],
      general_actions: [INDEX, EXPORT],
      member_actions: [SHOW],
    },

    'language-filters': {
      fields: ['id', 'name', 'identifier'],
      general_actions: [INDEX, EXPORT],
      member_actions: [SHOW],
    },

    'contacts': {
      fields: [
        'id',
        'name',
        'email',
        'message',
        'city',
        'url',
        'internal_mail',
        'created-at',
        'updated-at',
      ],
      general_actions: [INDEX, EXPORT],
      member_actions: [SHOW],
    },

    'organizations': {
      association_model_mapping: {
        'current-assignment': 'assignments',
        'receiver': 'users',
        'receiver-team': 'user-teams',
      },
      fields: [
        'id',
        {
          'current-assignment': {
            'receiver': ['name'],
            'receiver-team': ['name'],
          },
        },
        'offers-count',
        'name',
        'aasm-state',
        'pending-reason',
        'locations-count',
        { topics: ['name'] },
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, PREVIEW, DELETE],
    },

    'divisions': {
      association_model_mapping: {
        'current-assignment': 'assignments',
        'receiver': 'users',
        'receiver-team': 'user-teams',
        'presumed-tags': 'tags',
        'presumed-solution-categories': 'solution-categories',
      },
      fields: [
        'id',
        {
          'current-assignment': {
            'receiver': ['name'],
            'receiver-team': ['name'],
          },
        },
        { organization: ['name'] },
        { section: ['identifier'] },
        { city: ['name'] },
        { area: ['name'] },
        'size',
        'done',
        'addition',
      ],
      general_actions: [INDEX, EXPORT, NEW],
      member_actions: [SHOW, EDIT, DELETE],
    },

    'user-teams': {
      association_model_mapping: {
        'observing-users': 'users',
        'parent': 'users',
        'lead': 'users',
      },
      fields: [
        'id',
        'name',
        'classification',
        { users: ['name'] },
        { 'observing-users': ['name'] },
      ],
      general_actions: [INDEX, NEW],
      member_actions: [SHOW, EDIT],
    },

    'assignments': {
      association_model_mapping: {
        'creator': 'users',
        'receiver': 'users',
        'receiver-team': 'user-teams',
        'creator-team': 'user-teams',
      },
      fields: [
        'id',
        'assignable-id',
        'assignable-type',
        { assignable: ['label'] },
        { creator: ['name'] },
        { 'creator-team': ['name'] },
        { receiver: ['name'] },
        { 'receiver-team': ['name'] },
        'message',
        'topic',
        'created-at',
        'updated-at',
      ],
      inline_fields: [
        'assignable-type',
        'assignable-id',
        'topic',
        { assignable: ['label'] },
        { creator: ['name'] },
        { receiver: ['name'] },
        { 'receiver-team': ['name'] },
        'message',
        'updated-at',
      ],
      general_actions: [INDEX],
      member_actions: ['show-assignable', 'edit-assignable'],
    },

    'sections': {
      fields: ['id', 'name', 'identifier'],
      general_actions: [INDEX],
      member_actions: [SHOW],
    },

    'websites': {
      fields: ['id', 'host', 'url'],
      general_actions: [INDEX],
      member_actions: [SHOW, OPEN_URL, DELETE, EDIT],
    },

    'subscriptions': {
      fields: ['id', 'email', 'created-at', 'updated-at'],
      general_actions: [INDEX],
      member_actions: [SHOW, DELETE],
    },

    'update-requests': {
      fields: ['id', 'search-location', 'email', 'created-at', 'updated-at'],
      general_actions: [INDEX],
      member_actions: [SHOW],
    },

    'target-audience-filters-offers': {
      association_model_mapping: { 'target-audience-filter': 'filter' },
      fields: ['id', 'target-audience-filter-id', 'offer-id', 'stamp_de'],
      general_actions: [],
      member_actions: [],
    },
  },

  OPERATORS: ['=', '!=', '<', '>', '...', 'ILIKE', 'NOT LIKE'],
  SECTIONS: ['family', 'refugees'],
  AFTER_SAVE_ACTIONS: {
    to_edit: 'Bei dieser Instanz bleiben',
    to_table: 'Zurück zur Tabelle',
    to_new: 'Neues Objekt anlegen',
  },

  HISTORY_ENABLED: ['organizations', 'offers'],
}
