Offer.clear_index!

## Stubs
class GengoCommunicator
  def create_translation_jobs *attrs; true; end
end
## /Stubs

user = User.create! email: 'user@user.com', password: 'password',
                    role: 'researcher', name: 'Regina Research'
admin = User.create! email: 'admin@admin.com', password: 'password',
                     role: 'super', name: 'Agathe Admin'

team = UserTeam.create! name: 'The Experts'
team.users << user
team.users << admin

family = SectionFilter.create name: 'Family', identifier: 'family'
refugees = SectionFilter.create name: 'Refugees', identifier: 'refugees'
LanguageFilter.create name: 'Deutsch', identifier: 'deu'
LanguageFilter.create name: 'Englisch', identifier: 'eng'
LanguageFilter.create name: 'Türkisch', identifier: 'tur'
TargetAudienceFilter.create name: 'Kinder', identifier: 'family_children'
TargetAudienceFilter.create name: 'Eltern', identifier: 'family_parents'
TargetAudienceFilter.create name: 'Familie', identifier: 'family_nuclear_family'
TargetAudienceFilter.create name: 'Bekannte', identifier: 'family_relatives'

LogicVersion.create(version: 1, name: 'Altlasten')
LogicVersion.create(version: 2, name: 'Split Revolution')
LogicVersion.create(version: 3, name: 'TKKG')

schland = Area.create name: 'Deutschland', minlat: 47.270111, maxlat: 55.058347,
                      minlong: 5.866342, maxlong: 15.041896
berlin = Area.create name: 'Berlin', minlat: 52.339630, maxlat: 52.675454,
                     minlong: 13.089155, maxlong: 13.761118
Area.create name: 'Brandenburg & Berlin', minlat: 51.359059, maxlat: 53.558980,
            minlong: 11.268746, maxlong: 14.765826

FederalState.create name: 'Berlin'
FederalState.create name: 'Brandenburg'
FederalState.create name: 'Baden-Württemberg'
FederalState.create name: 'Bayern'
FederalState.create name: 'Bremen'
FederalState.create name: 'Hamburg'
FederalState.create name: 'Hessen'
FederalState.create name: 'Mecklenburg-Vorpommern'
FederalState.create name: 'Niedersachsen'
FederalState.create name: 'Nordrhein-Westfalen'
FederalState.create name: 'Saarland'
FederalState.create name: 'Sachsen'
FederalState.create name: 'Sachsen-Anhalt'
FederalState.create name: 'Schleswig-Holstein'
FederalState.create name: 'Thüringen'
FederalState.create name: 'Rheinland-Pfalz'
FederalState.create name: 'Mallorca' # Don't do this in production :)

SearchLocation.create query: 'Berlin', latitude: 52.520007,
                                       longitude: 13.404954,
                                       geoloc: '52.520007,13.404954'

fam = FactoryGirl.create :category, :with_dummy_translations,
                         name_de: 'Familie', icon: 'b-family'
fam.section_filters = [family, refugees]
legal = FactoryGirl.create :category, :with_dummy_translations,
                           name_de: 'Asyl und Recht', icon: 'a-legal'
legal.section_filters = [refugees]
health = FactoryGirl.create :category, :with_dummy_translations,
                            name_de: 'Gesundheit', icon: 'c-health'
health.section_filters = [family, refugees]
learn = FactoryGirl.create :category, :with_dummy_translations,
                           name_de: 'Lernen und Arbeiten', icon: 'd-learn'
learn.section_filters = [family, refugees]
miscf = FactoryGirl.create :category, :with_dummy_translations,
                          name_de: 'Sorgen im Alltag', icon: 'e-misc'
miscf.section_filters = [family]
miscr = FactoryGirl.create :category, :with_dummy_translations,
                          name_de: 'Leben in Deutschland', icon: 'e-misc'
miscr.section_filters = [refugees]
violence = FactoryGirl.create :category, :with_dummy_translations,
                              name_de: 'Gewalt', icon: 'f-violence'
violence.section_filters = [family, refugees]
crisis = FactoryGirl.create :category, :with_dummy_translations,
                            name_de: 'Notfall', icon: 'g-crisis'
crisis.section_filters = [family, refugees]

refugee_mains = Category.mains.in_section(:refugees).all
subcategories = []

10.times do
  subcategories.push(
    FactoryGirl.create :category, :with_dummy_translations,
                       section_filters: [refugees],
                       parent: refugee_mains.sample
  )
end

20.times do
  FactoryGirl.create :category, :with_dummy_translations,
                     section_filters: [refugees],
                     parent: subcategories.sample
end

categories = Category.all
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Lokales Angebot',
                   encounter: 'personal', categories: [categories.sample]
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Lokale Hotline',
                   encounter: 'hotline', area: berlin,
                   categories: [categories.sample]
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Bundesweiter Chat',
                   encounter: 'chat', area: schland,
                   categories: [categories.sample]
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Bundesweite Hotline',
                   encounter: 'hotline', area: schland,
                   categories: [categories.sample]

stic = StatisticTransition::CreateIfNecessary.({klass_name: 'Offer',
                                                field_name: 'aasm_state',
                                                start_value: 'initialized',
                                                end_value: 'completed'},
                                                current_user: User.system_user
                                              )['model']
stcc = StatisticTransition::CreateIfNecessary.({klass_name: 'Offer',
                                                field_name: 'aasm_state',
                                                start_value: 'checkup_process',
                                                end_value: 'completed'},
                                                current_user: User.system_user
                                              )['model']

stcs = StatisticTransition::CreateIfNecessary.({klass_name: 'Offer',
                                                field_name: 'aasm_state',
                                                start_value: 'checkup_process',
                                                end_value: 'seasonal_pending'},
                                                current_user: User.system_user
                                              )['model']
stas = StatisticTransition::CreateIfNecessary.({klass_name: 'Offer',
                                                field_name: 'aasm_state',
                                                start_value: 'approval_process',
                                                end_value: 'seasonal_pending'},
                                                current_user: User.system_user
                                              )['model']
stca = StatisticTransition::CreateIfNecessary.({klass_name: 'Offer',
                                                field_name: 'aasm_state',
                                                start_value: 'checkup_process',
                                                end_value: 'approved'},
                                                current_user: User.system_user
                                              )['model']
staa = StatisticTransition::CreateIfNecessary.({klass_name: 'Offer',
                                                field_name: 'aasm_state',
                                                start_value: 'approval_process',
                                                end_value: 'approved'},
                                                current_user: User.system_user
                                              )['model']
# create charts for admin and researcher user

User.find_each do |u|
 sc1 = StatisticChart.create title: "completion",
                             starts_at: Date.new(2017,1,1),
                             ends_at: Date.new(2017,12,31), user_id: u.id
 sg1 = StatisticGoal.create amount: rand(300..1000),
                            starts_at: Date.new(2017,1,1)
 sc1.statistic_transitions = [stic, stcc]
 sc1.statistic_goals = [sg1]

 sc2 = StatisticChart.create title: "approval",
                                    starts_at: Date.new(2017,1,1),
                                    ends_at: Date.new(2017,12,31),
                                    user_id: u.id
 sg2 = StatisticGoal.create amount: rand(600..1800),
                                    starts_at: Date.new(2017,1,1)
 sc2.statistic_transitions = [stca, staa, stcs, stas]
 sc2.statistic_goals = [sg2]
end

team.users.find_each do |member|
  date_start = Date.new(2017,1,1)
  10.times do
    FactoryGirl.create :statistic, date: date_start, count: rand(1..10),
                       trackable_id: member.id, trackable_type: 'User', model: 'Offer',
                       field_name: 'aasm_state', field_start_value:'initialized',
                       field_end_value: 'completed'
    FactoryGirl.create :statistic, date: date_start, count: rand(1..10),
                       trackable_id: member.id, trackable_type: 'User', model: 'Offer',
                       field_name: 'aasm_state', field_end_value: 'approved',
                       field_start_value:'approval_process'
    date_start = date_start + rand(1..3).day
  end
end
# A few test statistics

# # A running goal
# now = Date.current
# date = now - 4.weeks
# goal = FactoryGirl.create(
#   :statistic_chart, :running,
#   title: 'Approve 1000 Offers', target_field_name: 'aasm_state',
#   target_field_value: 'approved', target_count: 1000, target_model: 'Offer'
# )
# goal.user_team.users << user
# FactoryGirl.create(
#   :statistic, goal: goal, count: 10, date: goal.starts_at + 1.day
# )
# FactoryGirl.create(
#   :statistic, goal: goal, count: 7, date: goal.starts_at + 2.day
# )
# FactoryGirl.create(
#   :statistic, goal: goal, count: 8, date: goal.starts_at + 3.days
# )
# FactoryGirl.create(
#   :statistic, goal: goal, count: 20, date: goal.starts_at + 3.days
# )
# FactoryGirl.create(
#   :statistic, goal: goal, count: 25, date: now - 1.days
# )

# # Time Allocations & Historical Productivity Data
# TimeAllocation.create! user: user, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 20
# date = now - 3.weeks
# TimeAllocation.create! user: user, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 20,
#                        actual_wa_hours: 15
# Statistic.create! user: user, user_team: goal.user_team, time_frame: 'weekly',
#                   model: 'Offer', field_name: 'aasm_state',
#                   field_start_value: 'approval_process',
#                   field_end_value: 'approved', date: date, count: 1.7
# team_mate = goal.user_team.users.create FactoryGirl.attributes_for(:researcher)
# TimeAllocation.create! user: team_mate, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 50,
#                        actual_wa_hours: 51
# Statistic.create! user: team_mate, user_team: goal.user_team,
#                   model: 'Offer', field_name: 'aasm_state',
#                   field_start_value: 'approval_process', time_frame: 'weekly',
#                   field_end_value: 'approved', date: date, count: 4.7
# date = now - 1.weeks
# TimeAllocation.create! user: user, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 10,
#                        actual_wa_hours: 3
# Statistic.create! user: user, user_team: goal.user_team, time_frame: 'weekly',
#                   model: 'Offer', field_name: 'aasm_state',
#                   field_start_value: 'approval_process',
#                   field_end_value: 'approved', date: date, count: 3.1
# date = now + 1.weeks
# TimeAllocation.create! user: user, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 15
# TimeAllocation.create! user: team_mate, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 10
# date = now + 2.weeks
# TimeAllocation.create! user: user, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 0
# TimeAllocation.create! user: team_mate, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 0
# date = now + 3.weeks
# TimeAllocation.create! user: user, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 5
# date = now + 4.weeks
# TimeAllocation.create! user: team_mate, year: date.year,
#                        week_number: date.cweek,
#                        desired_wa_hours: 20
