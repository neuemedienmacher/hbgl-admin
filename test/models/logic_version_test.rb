# frozen_string_literal: true
require_relative '../test_helper'

describe LogicVersion do
  let(:logic_version) { LogicVersion.new }
  subject { logic_version }

  describe 'validations' do
    it { subject.must validate_presence_of :name }
    it { subject.must validate_uniqueness_of :name }
    it { subject.must validate_presence_of :version }
    it { subject.must validate_uniqueness_of :version }
  end
end
