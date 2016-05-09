# frozen_string_literal: true
class FlashCell < Cell::ViewModel
  def show
    render
  end

  private

  def message
    model[1]
  end

  def type
    case model[0]
    when 'error'
      'danger'
    when 'notice'
      'success'
    when 'warning'
      'warning'
    else
      'info'
    end
  end
end
