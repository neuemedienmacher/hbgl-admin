require_relative '../../lib/rails_admin_extensions/rails_admin_change_state.rb'

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Auth ==
  # config.authorize_with do |req|
  #   redirect_to main_app.root_path unless current_user.try(:admin?)
  #   if req.action_name == 'statistics' && current_user.role != 'superuser'
  #     redirect_to dashboard_path
  #   end
  # end
  config.authorize_with :cancan, Ability
  config.current_user_method &:current_user

  # config.excluded_models = ['AgeFilter', 'FederalState',
  #                           'OrganizationConnection', 'Filter']

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.included_models = %w(
    Organization Website Location
    FederalState Offer Opening
    Category Email UpdateRequest
    LanguageFilter User Contact
    Keyword Definition Note Area
    SearchLocation ContactPerson
    Subscription SectionFilter
  )

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ['User', 'FederalState', 'SectionFilter']
    end
    export
    bulk_delete do
      except ['User', 'FederalState', 'SectionFilter']
    end
    show
    edit do
      except ['SectionFilter']
    end
    delete do
      except ['User', 'FederalState', 'SectionFilter']
    end
    show_in_app

    clone do
      except ['SectionFilter']
    end
    # nested_set do
    #   only ['Category']
    # end
    nestable do
      only ['Category']
    end
    change_state

    ## With an audit adapter, you can add:
    history_index
    history_show
  end

  config.model 'Organization' do
    list do
      field :offers_count
      field :name
      field :renewed
      field :aasm_state
      field :creator
      field :locations_count
      field :created_by

      sort_by :offers_count
    end
    weight(-3)
    field :name
    field :description do
      css_class 'js-count-character'
    end
    field :comment do
      css_class 'js-count-character'
    end
    field :locations
    field :legal_form
    field :charitable
    field :accredited_institution
    field :founded
    field :umbrella
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end

    field :websites
    field :mailings_enabled
    field :renewed
    field :aasm_state do
      read_only true
      help false
    end

    # Hidden fields
    edit do
      field :created_by, :hidden do
        visible do
          bindings[:object].new_record?
        end
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end

    show do
      field :offers
      field :locations
      field :created_by
      field :approved_by
    end

    clone_config do
      custom_method :partial_dup
    end

    export do
      field :id
    end
  end

  config.label_methods << :url
  config.model 'Website' do
    field :host
    field :url

    show do
      field :offers
      field :organizations
    end
  end

  config.label_methods << :display_name
  config.model 'Location' do
    list do
      field :name
      field :organization
      field :zip
      field :federal_state
      field :display_name
    end
    weight(-2)
    field :organization
    field :name
    field :street
    field :addition
    field :zip
    field :city
    field :area_code
    field :local_number
    field :email
    field :federal_state do
      inline_add false
      inline_edit false
    end
    field :hq
    field :visible do
      help do
        'Obacht: nur dann entfernen, wenn die Adresse auf der Orga-Seite
        versteckt werden soll!'
      end
    end
    field :latitude do
      read_only true
    end
    field :longitude do
      read_only true
    end
    show do
      field :offers
      field :display_name
    end
    export do
      field :id
    end
    clone_config do
      custom_method :partial_dup
    end
    object_label_method :display_name
  end

  config.model 'FederalState' do
    weight 2
    list do
      field :id do
        sort_reverse false
      end
      field :name
    end
  end

  config.model 'Offer' do
    weight(-1)
    list do
      field :name
      field :section_filters
      field :location
      field :renewed
      field :aasm_state
      field :creator
      field :expires_at
      field :approved_at
      field :organizations do
        searchable :name
      end
      field :created_by
    end

    field :section_filters
    field :name do
      css_class 'js-category-suggestions__trigger'
    end
    field :description do
      css_class 'js-count-character'
    end
    field :comment do
      css_class 'js-count-character'
    end
    field :notes
    field :next_steps do
      css_class 'js-count-character'
    end
    field :legal_information
    field :contact_people
    field :encounter
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end
    field :location
    field :area
    field :organizations do
      help do
        'Required. Only approved organizations.'
      end
    end
    field :categories do
      css_class 'js-category-suggestions'
    end
    field :language_filters
    field :exclusive_gender do
      help do
        'Optional. Leer bedeutet, dass das Angebot alle Geschlechter bedient.'
      end
    end
    field :target_audience_filters do
      help do
        'Richtet sich das Angebot direkt an das Kind, oder an Erwachsene wie
        z.B. die Eltern, einen Nachbarn oder einen Lotsen'
      end
    end
    field :age_from
    field :age_to
    field :openings
    field :opening_specification do
      help do
        'Bitte einigt euch auf eine einheitliche Ausdrucksweise. Wie etwa
        "jeden 1. Montag im Monat" oder "jeden 2. Freitag". Sagt mir
        (Konstantin) auch gern bescheid, wenn ihr ein einheitliches Format
        gefunden habt, mit dem alle Fälle abgedeckt werden können.'
      end
    end
    field :websites
    field :keywords do
      inverse_of :offers
    end
    field :expires_at
    field :renewed
    field :aasm_state do
      read_only true
      help false
    end

    # Hidden fields
    edit do
      field :created_by, :hidden do
        visible do
          bindings[:object].new_record?
        end
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end

    show do
      field :created_at do
        strftime_format "%d. %B %Y"
      end
      field :created_by
      field :approved_by
    end

    clone_config do
      custom_method :partial_dup
    end

    export do
      field :id
    end
  end

  config.model 'ContactPerson' do
    object_label_method :display_name
    list do
      field :id
      field :first_name
      field :last_name
      field :organization
      field :offers
      field :email_address
      field :operational_name
      field :local_number_1
      field :local_number_2
    end
    field :gender
    field :academic_title
    field :first_name
    field :last_name
    field :operational_name do
      help do
        "Falls es sich nicht um einen persönlichen Ansprechpartner handelt hier
        z.B. 'Zentrale' eintragen"
      end
    end
    field :responsibility do
      help do
        "Z.b. 'Zuständig für alle Anfragen von Menschen deren Nachname mit den
        Buchstaben A-M anfangen'"
      end
    end
    field :area_code_1
    field :local_number_1
    field :area_code_2
    field :local_number_2
    field :fax_area_code
    field :fax_number
    field :email
    field :organization
    field :offers
    field :spoc do
      help do
        "Single Point of Contact / Zentrale Anlaufstelle."
      end
    end
    export do
      field :id
    end
    clone_config do
      custom_method :partial_dup
    end

    show do
      field :referencing_notes
    end
  end

  config.model 'Opening' do
    field :day do
      help do
        'Required. Wenn weder "Open" noch "Close" angegeben werden, bedeutet
        das an diesem Tag "nach Absprache".'
      end
    end
    field :open do
      help do
        'Required if "Close" given.'
      end
    end
    field :close do
      help do
        'Required if "Open" given.'
      end
    end

    field :name do
      visible false
    end

    list do
      sort_by :sort_value
      field :sort_value do
        sort_reverse false
        visible false
      end
    end
  end

  config.model 'Category' do
    field :name
    field :section_filters
    field :parent
    field :sort_order
    field :visible

    object_label_method :name_with_world_suffix_and_optional_asterisk

    list do
      sort_by :name
    end

    show do
      field :offers
      field :icon
    end

    # nested_set(max_depth: 5)
    nestable_tree(max_depth: 5)
  end

  config.model 'Definition' do
    field :key
    field :explanation

    object_label_method :key
  end

  config.model 'Email' do
    field :address
    field :aasm_state do
      read_only true
      help false
    end

    list do
      field :contact_people
    end

    show do
      field :contact_people
    end

    object_label_method :address
  end

  config.model 'Note' do
    list do
      field :text
      field :topic
      field :user
      field :created_at
      field :notable
      field :referencable
    end

    edit do
      field :notable
      field :text
      field :topic
      field :referencable

      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end

    nested do
      field :notable do
        visible false
      end
      field :text do
        read_only do
          !bindings[:object].new_record?
        end
      end
      field :topic do
        read_only do
          !bindings[:object].new_record?
        end
      end
      field :referencable do
        read_only do
          !bindings[:object].new_record?
        end
      end
    end

    update do
      field :id do
        read_only true
      end
      field :text do
        read_only true
      end
      field :topic do
        read_only true
      end
      field :user do
        read_only true
      end
      field :notable do
        read_only true
      end
      field :user_id do
        read_only true
        visible false
      end

      field :referencable
    end
  end

  config.model 'Filter' do
    weight 1
    list do
      field :id
      field :name
      field :identifier
      field :offers
    end
  end
  config.model 'LanguageFilter' do
    parent Filter
  end
  config.model 'Target_AudienceFilter' do
    parent Filter
  end
  config.model 'SectionFilter' do
    weight 3
    parent Filter
    list do
      field :id
      field :name
      field :offers do
        label 'Anzahl der Angebote (approved)'
        pretty_value do
          "#{value.count} (#{value.approved.count})"
        end
      end
    end
    show do
      field :name
      field :offers do
        pretty_value do
          "#{value.count} (#{value.approved.count})"
        end
      end
    end
  end

  config.model 'User' do
    weight 1
    list do
      field :id
      field :name
      field :email
      field :role
      field :created_at
      field :updated_at
    end

    edit do
      field :name do
        read_only do
          bindings[:object] != bindings[:view].current_user
        end
      end
      field :email do
        read_only do
          bindings[:object] != bindings[:view].current_user
        end
      end
      field :password do
        visible do
          bindings[:object] == bindings[:view].current_user
        end
      end
    end
  end

  config.model 'Keyword' do
    weight 1
  end

  config.model 'Area' do
    weight 1
  end

  config.model 'Contact' do
    weight 2
  end

  config.model 'Subscription' do
    weight 2
  end

  config.model 'UpdateRequest' do
    weight 2
  end

  config.model 'ContactPersonOffer' do
    weight 3
  end

  config.model 'SearchLocation' do
    weight 3
    field :query do
      read_only true
    end
    field :latitude do
      read_only true
    end
    field :longitude do
      read_only true
    end
  end
end
