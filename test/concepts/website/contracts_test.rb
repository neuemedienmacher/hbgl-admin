# frozen_string_literal: true
require_relative '../../test_helper'
require_relative '../../support/utils/contract_test_utils'

class WebsiteContractsTest < ActiveSupport::TestCase
  include ContractTestUtils

  describe 'Create' do
    subject { Website::Contracts::Create.new(Website.new) }

    describe 'validations' do
      describe 'always' do
        it { must_validate_presence_of :host }
        it { must_validate_presence_of :url }
        it { must_validate_uniqueness_of :url, Website.first.url }
        it { must_validate_presence_of :unreachable_count }
      end
    end
  end
end
