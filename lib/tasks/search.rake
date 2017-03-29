namespace :search do
  desc 'Reindex the entire search index'
  task :reindex do
    Offer.clear_index!
    Offer.reindex
  end
end
