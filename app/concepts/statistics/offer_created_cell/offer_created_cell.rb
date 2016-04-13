class Statistics::OfferCreatedCell < Cell::Concept
  def show
    render
  end

  private

  def graph_data
    Statistic.where(topic: :offer_created).pluck(:x, :y)
  end
end
