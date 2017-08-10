# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class NoteContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Note::Contracts::Create.new(Note.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :text }
        it { must_validate_length_of :text, maximum: 800 }
        it { must_validate_presence_of :topic }
        it { must_validate_presence_of :user }
        it { must_validate_presence_of :notable }
      end
    end
  end
end
