# frozen_string_literal: true
class TimeAllocation::Create < Trailblazer::Operation
  step :TODO
  def TODO
    raise 'Reimplement contract! and find_model'
  end

  step Model(::TimeAllocation, :new)
  step Contract::Build()
  step Contract::Validate()
  step Contract::Persist()

  def contract!(model=nil, _contract_class=nil)
    @_contract ||=
      if model.new_record?
        Contracts::Create.new(model)
      else
        Contracts::Update.new(model)
      end
  end

  def find_model(params)
    @model ||=
      if params[:id]
        ::TimeAllocation.find(params[:id])
      else
        ::TimeAllocation.new
      end
  end
end
