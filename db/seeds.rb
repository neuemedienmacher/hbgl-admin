ClaratBase::Engine.load_seed

mains = ClaratBase::Category.mains.all

10.times do
  FactoryGirl.create :category, parent: mains.sample
end

20.times do
  FactoryGirl.create :category, parent_id: ClaratBase::Category.pluck(:id).sample
end

user = ClaratBase::User.find_by_email('user@user.com')
schland = ClaratBase::Area.find_by_name('Deutschland')
berlin = ClaratBase::Area.find_by_name('Berlin')

FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Lokales Angebot',
                                      encounter: 'personal'
FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Lokale Hotline',
                                      encounter: 'hotline',
                                      area: berlin
FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Bundesweiter Chat',
                                      encounter: 'chat',
                                      area: schland
FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Bundesweite Hotline',
                                      encounter: 'hotline',
                                      area: schland
