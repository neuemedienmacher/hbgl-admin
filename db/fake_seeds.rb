# Repeatedly usable with rake db:fake
u = User.first or raise "run `rake db:seed` first"

## Stubs
class GengoCommunicator
  def create_translation_jobs *attrs; true; end
end
## /Stubs

unless ENV['ALGOLIA_ID'] && ENV['ALGOLIA_KEY']
  raise "needs environment variables for algolia"
end

class GeocodingWorker
  def self.perform_async *attrs
    true
  end
end

puts "Before: Offer count #{Offer.count}"
10.times do
  begin
    FactoryGirl.create :offer, :approved, :with_dummy_translations,
                       approved_by: User.where(active: true).sample.id, fake_address: true,
                       tags: [Tag.all.sample]
  rescue ActiveRecord::RecordInvalid
    puts "Offer data are randomly repeating"
  end
end
Offer.reindex!
puts "After: Offer count #{Offer.count}"
