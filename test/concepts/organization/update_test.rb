# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/operation_test_utils'

# rubocop:disable Metrics/ClassLength
class OrganizationUpdateTest < ActiveSupport::TestCase
  include OperationTestUtils

  let(:new_orga) { FactoryGirl.create(:organization) }

  it 'gets updated with a submodel' do
    params = {
      data: {
        type: 'organizations',
        id: '1',
        attributes: { description: 'changed' },
        relationships: {
          website: {
            data: {
              type: 'websites',
              attributes: {
                host: 'own',
                url: 'http://new.org'
              }
            }
          }
        }
      }
    }

    result =
      api_operation_must_work API::V1::Organization::Update, params.to_json
    result['model'].description.must_equal 'changed'
    result['model'].website_id.must_equal 2
    result['model'].website.url.must_equal 'http://new.org'
  end

  describe 'translation side effect' do
    def update_description orga, description
      operation_must_work(
        ::Organization::Update, id: orga.id, description: description
      )
    end

    def change_state orga, event
      operation_must_work(
        ::Organization::Update,
        id: orga.id, 'meta' => { 'commit' => event.to_s }
      )
    end

    it 'should always get de translation, others only on approval and change' do
      new_orga = FactoryGirl.create(:organization)
      new_orga.translations.count.must_equal 0
      new_orga.aasm_state.must_equal 'initialized'

      # First commit: only :de
      update_description new_orga, 'initial'
      new_orga.translations.count.must_equal 1 # only :de
      new_orga.translations.first.locale.must_equal 'de'

      # Changing things on an initialized offer doesn't change translations
      assert_nil new_orga.reload.description_ar
      update_description new_orga, 'change description, wont update translation'
      new_orga.translations.count.must_equal 1
      assert_nil new_orga.reload.description_ar

      # Completion does not generate translations
      change_state new_orga, :complete
      new_orga.translations.count.must_equal 1

      # Approval generates all translations initially
      change_state new_orga, :start_approval_process
      change_state new_orga, :approve
      new_orga.reload.translations.count.must_equal I18n.available_locales.count

      # Now changes to the model change the corresponding translated fields
      EasyTranslate.translated_with 'CHANGED' do
        new_orga.description_ar.must_equal 'GET READY FOR CANADA'
        update_description new_orga, 'change description, updates translation'
        new_orga.reload.description_ar.must_equal 'CHANGED'
      end
    end

    it 'should update an existing translation only when the field changed' do
      # Setup
      update_description new_orga, 'New description'
      change_state new_orga, :complete
      new_orga.translations.reload.count.must_equal 1
      change_state new_orga, :start_approval_process
      change_state new_orga, :approve
      new_orga.translations.reload.count.must_equal I18n.available_locales.count

      # Now changes to the model change the corresponding translated fields
      EasyTranslate.translated_with 'CHANGED' do
        new_orga.description_ar.must_equal 'GET READY FOR CANADA'
        # changing untranslated field => translations must stay the same
        operation_must_work(
          ::Organization::Update, id: new_orga.id, mailings: 'enabled'
        )
        new_orga.reload.description_ar.must_equal 'GET READY FOR CANADA'
        update_description new_orga, 'changing descr, should update translation'
        new_orga.reload.description_ar.must_equal 'CHANGED'
      end
    end
  end

  describe 'state change side-effects' do
    it 'wont do anything without the correct meta commit action' do
      new_orga.aasm_state.must_equal 'initialized'
      operation_wont_work(
        ::Organization::Update, id: new_orga.id, description: 'doesntMatter',
                                'meta' => { 'commit' => 'doesntexist' }
      )
      new_orga.reload.aasm_state.must_equal 'initialized'
    end

    it 'changes to complete state with the correct meta action' do
      new_orga.aasm_state.must_equal 'initialized'
      new_orga.valid?.must_equal true
      operation_must_work(
        ::Organization::Update, id: new_orga.id, description: 'doesntMatter',
                                'meta' => { 'commit' => 'complete' }
      )
      new_orga.reload.aasm_state.must_equal 'completed'
    end

    it 'works correctly with the meta complete action for section-user and '\
       'create the correct new assignment' do
      new_orga.aasm_state.must_equal 'initialized'
      new_orga.valid?.must_equal true
      assignment_count = new_orga.assignments.count
      user = users(:researcher)
      user.user_teams << user_teams(:basic)
      operation_must_work(
        ::Organization::Update, 'current_user' => user, id: new_orga.id,
                                description: 'doesntMatter',
                                'meta' => { 'commit' => 'complete' }
      )
      new_orga.reload.aasm_state.must_equal 'completed'
      new_orga.assignments.count.must_equal assignment_count + 1
      assert_nil new_orga.assignments.last.receiver_id
      new_orga.assignments.last.receiver_team_id.must_equal 1
      new_orga.assignments.last.message.must_equal(
        'Bitte den Orga Datensatz approven'
      )
      new_orga.assignments.last.creator_id.must_equal user.id
      new_orga.assignments.last.topic.must_equal 'approval'
    end

    it 'validates description and legal_form with approve state change param' do
      # complete & start_approval_process work without data
      orga =
        FactoryGirl.create(:organization, description: nil, legal_form: nil)
      operation_must_work(
        ::Organization::Update,
        id: orga.id, 'meta' => { 'commit' => 'complete' }
      )
      operation_must_work(
        ::Organization::Update,
        id: orga.id, 'meta' => { 'commit' => 'start_approval_process' }
      )

      # approve wont work right away
      result = operation_wont_work(
        ::Organization::Update, id: orga.id, 'meta' => { 'commit' => 'approve' }
      )
      result['result.contract.default'].errors.messages.must_equal(
        description: ['muss ausgefüllt werden'],
        legal_form: ['muss ausgefüllt werden']
      )

      # works with description and legal_form
      operation_must_work(
        ::Organization::Update,
        id: orga.id, description: 'foo', legal_form: 'ev',
        'meta' => { 'commit' => 'approve' }
      )
    end

    it 'changes from approved to all_done with done-only-divisions' do
      new_orga.update_columns aasm_state: 'approved'
      new_orga.divisions.first.update_columns done: true
      new_orga.divisions.count.must_equal 1
      operation_must_work(
        ::Organization::Update, id: new_orga.id, description: 'doesntMatter'
      )

      params = {
        data: {
          type: 'organizations',
          id: new_orga.id.to_s,
          relationships: {
            divisions: {
              data: [
                {
                  type: 'divisions',
                  id: new_orga.divisions.first.id.to_s
                }
              ]
            }
          }
        }
      }

      result =
        api_operation_must_work API::V1::Organization::Update, params.to_json
      result['model'].aasm_state.must_equal 'all_done'
    end
  end
end
# rubocop:enable Metrics/ClassLength
