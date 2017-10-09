# frozen_string_literal: true

require_relative '../../test_helper'

class CommonSideEffectsTest < ActiveSupport::TestCase
  let(:subject) do
    Class.new { include Translation::CommonSideEffects::HumanChangeFields }
  end
  let(:options) do
    {
      'changes_by_human' => false,
      'contract.default' => OpenStruct.new(
        'source' => 'GoogleTranslate',
        'possibly_outdated' => true
      )
    }
  end

  it 'should not change the options when the changes_by_human is false' do
    subject.new.reset_source_and_possibly_outdated_if_changes_by_human(options)
    options['contract.default'].source.must_equal 'GoogleTranslate'
    options['contract.default'].possibly_outdated.must_equal true
  end

  it 'should change the options when the changes_by_human is true' do
    options['changes_by_human'] = true
    subject.new.reset_source_and_possibly_outdated_if_changes_by_human(options)
    options['contract.default'].source.must_equal 'researcher'
    options['contract.default'].possibly_outdated.must_equal false
  end
end
