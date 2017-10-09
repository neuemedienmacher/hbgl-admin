# frozen_string_literal: true

require_relative '../test_helper'

describe TargetAudienceFiltersOffer do
  let(:subject) { target_audience_filters_offer(:basicAudience) }

  describe 'validations' do
  end

  describe 'name' do
    it 'should mirror the saved german stamp if one is present' do
      subject.stamp_de = 'foobar'
      subject.name.must_equal 'foobar'
    end

    it 'should generate the name correctly' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.first.id
      subject.offer_id = Offer.first.id
      subject.name.must_equal "#{TargetAudienceFilter.first.name} (Offer##{Offer.first.id})"
    end

    it 'should generate a name even without an offer and filter' do
      subject.target_audience_filter_id = nil
      subject.offer_id = nil
      subject.name.must_equal 'Leere Verknüpfung'
    end
  end

  describe 'generated OfferStamp' do
    it 'should correctly respond to general _stamp_SECTION call' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_children').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder und Jugendliche'
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'Flüchtlinge', identifier: 'refugees_general').id
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Flüchtlinge'
    end

    it 'should correctly respond some general english _stamp_ calls' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_children').id
      subject.generate_stamps!
      subject.stamp_en.must_equal 'for children and adolescents'
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'Flüchtlinge', identifier: 'refugees_general').id
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.generate_stamps!
      subject.stamp_en.must_equal 'for refugees'
    end

    it 'should respond correctly for invisible age' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_children').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder und Jugendliche'
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'Flüchtlinge', identifier: 'refugees_general').id
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Flüchtlinge'
    end

    it 'should respond correctly for several visible age combinations' do
      subject.age_visible = true
      subject.age_from = 0
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder (bis 2 Jahre)'

      subject.age_from = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder (2 Jahre)'

      subject.age_to = 21
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder und Jugendliche (ab 2 Jahren)'

      subject.age_to = 99
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder und Jugendliche (ab 2 Jahren)'

      subject.age_visible = false
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder und Jugendliche'

      subject.age_visible = true
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_everyone').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für alle'
    end

    it 'should behave correctly for family_children target_audience' do
      subject.age_visible = true
      subject.age_from = 1
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder (1 – 2 Jahre)'

      subject.age_from = 15
      subject.age_to = 16
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Jugendliche (15 – 16 Jahre)'

      subject.age_from = 7
      subject.age_to = 16
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Kinder und Jugendliche (7 – 16 Jahre)'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Jungen (7 – 16 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mädchen (7 – 16 Jahre)'
    end

    it 'should behave correctly for family_parents target_audience' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_parents').id
      subject.age_visible = true
      subject.age_from = 1
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Eltern (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Eltern (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Väter (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Väter von Söhnen (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Väter von Töchtern (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = ''
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Eltern von Töchtern (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Eltern von Söhnen (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter von Söhnen (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter von Töchtern (1 – 2 Jahre)'
    end

    it 'should behave correctly for family_nuclear_family target_audience' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_nuclear_family').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.age_from = 0
      subject.age_to = 1
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien und ihre Babys'

      subject.age_visible = true
      subject.age_from = 1
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien und ihre Kinder (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = ''
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien'

      subject.age_visible = false
      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien'

      subject.age_visible = true
      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien und ihre Söhne (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Familien und ihre Töchter (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter und ihre Kinder (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Väter und ihre Kinder (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Väter und ihre Söhne (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Väter und ihre Töchter (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter und ihre Töchter (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = nil
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter und ihre Kinder (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter und ihre Söhne (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Mütter und ihre Kinder (1 – 2 Jahre)'
    end

    it 'should behave correctly for family_parents_to_be target_audience' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_parents_to_be').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Eltern'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Eltern und ihre Kinder'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Eltern und ihre Söhne'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Eltern und ihre Töchter'

      subject.gender_first_part_of_stamp = 'female'
      subject.gender_second_part_of_stamp = ''
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Schwangere'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Väter'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Väter und ihre Kinder'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Väter und ihre Söhne'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für werdende Väter und ihre Töchter'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Schwangere und ihre Töchter'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Schwangere und ihre Söhne'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Schwangere und ihre Kinder'
    end

    it 'should behave correctly for the remaining family target audiences' do
      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_relatives').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Angehörige'

      subject.age_visible = true
      subject.gender_second_part_of_stamp = 'neutral'
      subject.age_from = 1
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Angehörige (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = nil
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Angehörige (1 – 2 Jahre)'

      subject.target_audience_filter_id =
        TargetAudienceFilter.find_by(identifier: 'family_everyone').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für alle'
    end

    it 'should behave correctly for refugees_children target_audience' do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_children').id
      subject.age_from = 1
      subject.age_to = 10
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Kinder'

      subject.age_to = 20
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Kinder und Jugendliche'

      subject.age_from = 15
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Jugendliche'

      subject.age_visible = true
      subject.age_from = 13
      subject.age_to = 17
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Kinder und Jugendliche (13 – 17 Jahre)'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Jungen (13 – 17 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mädchen (13 – 17 Jahre)'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Kinder und Jugendliche (13 – 17 Jahre)'
    end

    it "should return 'für unbegleitete minderjährige Flüchtlinge' for minor refugees_uf target_audience " do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_uf').id
      subject.age_to = 17
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete minderjährige Flüchtlinge'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete minderjährige Flüchtlinge'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete minderjährige Flüchtlinge'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete minderjährige Flüchtlinge'
    end

    it "should return 'für unbegleitete Flüchtlinge' for non-minor refugees_uf target_audience " do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_uf').id
      subject.age_to = 18
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete Flüchtlinge'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete Flüchtlinge'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete Flüchtlinge'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für unbegleitete Flüchtlinge'
    end

    it 'should behave correctly for refugees_parents_to_be target_audience' do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_parents_to_be').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete werdende Eltern'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete werdende Eltern'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Schwangere'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete werdende Väter'
    end

    it 'should behave correctly for refugees_parents target_audience' do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_parents').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Eltern'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Eltern'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Eltern'

      subject.age_visible = true
      subject.age_from = 1
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Eltern (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Eltern von Töchtern (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Eltern von Söhnen (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter von Söhnen (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter von Töchtern (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = nil
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter (1 – 2 Jahre)'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter (Alter des Kindes: 1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter von Söhnen (1 – 2 Jahre)'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter von Töchtern (1 – 2 Jahre)'
    end

    it 'should behave correctly for refugees_families target_audience' do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_families').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Familien'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Familien'

      subject.age_visible = true
      subject.gender_second_part_of_stamp = 'neutral' # neutral equals nil
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Familien und ihre Kinder (bis 20 Jahre)'

      subject.age_from = 0
      subject.age_to = 1
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Familien und ihre Babys (bis 1 Jahr)'

      subject.age_visible = false
      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Familien und ihre Töchter'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Familien und ihre Söhne'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter und ihre Söhne'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter und ihre Töchter'

      subject.gender_second_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter und ihre Babys'

      subject.age_from = 1
      subject.age_to = 2
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mütter und ihre Kinder'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter und ihre Kinder'

      subject.age_from = 0
      subject.age_to = 1
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter und ihre Babys'

      subject.gender_second_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter und ihre Söhne'

      subject.gender_second_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Väter und ihre Töchter'
    end

    it 'should behave correctly for refugees_general target_audience' do
      subject.offer.section = Section.find_by(identifier: 'refugees')
      subject.target_audience_filter_id =
        TargetAudienceFilter.create(name: 'ref_1', identifier: 'refugees_general').id
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Flüchtlinge'

      # neutral equals nil
      subject.gender_first_part_of_stamp = 'neutral'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für Flüchtlinge'

      subject.age_from = 18
      subject.age_to = 99
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Erwachsene'

      subject.gender_first_part_of_stamp = 'female'
      subject.age_from = 15
      subject.age_to = 42
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Mädchen und Frauen'

      subject.gender_first_part_of_stamp = 'male'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Jungen und Männer'

      subject.age_from = 18
      subject.age_to = 42
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Männer'

      subject.gender_first_part_of_stamp = 'female'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Frauen'

      # simple residency_status tests
      subject.residency_status = 'before_the_asylum_decision'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Frauen – vor der Asylentscheidung'

      subject.residency_status = 'with_a_residence_permit'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Frauen – mit Aufenthaltserlaubnis'

      subject.residency_status = 'with_temporary_suspension_of_deportation'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Frauen – mit Duldung'

      subject.residency_status = 'with_deportation_decision'
      subject.generate_stamps!
      subject.stamp_de.must_equal 'für geflüchtete Frauen – mit Abschiebebescheid'
    end
  end
end
