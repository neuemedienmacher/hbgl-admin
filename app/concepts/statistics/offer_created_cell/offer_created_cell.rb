class Statistics::OfferCreatedCell < Cell::Concept
  def show
    render
  end

  private

  def graph_data
    { coordinates:
      Statistic.where(topic: :offer_created).pluck(:x, :y, :user_id).to_json
    }
  end

  def users
    User.researcher.all
  end
end
