# frozen_string_literal: true
require_relative '../test_helper'

describe Note do
  let(:note) { Note.new }
  subject { note }

  describe 'validations' do
    it { subject.must validate_presence_of :text }
    it { subject.must validate_length_of :text }
    it { subject.must validate_presence_of :topic }
    it { subject.must validate_presence_of :user }
    it { subject.must validate_presence_of :notable }
  end
end
