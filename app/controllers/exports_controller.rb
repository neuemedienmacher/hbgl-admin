# frozen_string_literal: true

class ExportsController < ApplicationController
  def create
    return render_error unless params['export']
    params['export'] = Export.snake_case_export_hash(params['export'])
    result = Export::Create.(params, 'current_user' => current_user)
    if result.success?
      stream_data(result)
    else
      render_error
    end
  end

  private

  def render_error
    render plain: 'error', status: 403
  end

  def stream_data(result)
    set_file_headers
    set_streaming_headers
    response.status = 200
    self.response_body = csv_lines(result['model'])
  end

  def set_file_headers
    file_name = "#{params[:object_name]}_export_#{Time.zone.now}.csv"
    headers['Content-Type'] = 'text/csv'
    headers['Content-disposition'] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    # nginx doc: Setting this to "no" will allow unbuffered responses suitable
    # for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers['Cache-Control'] ||= 'no-cache'
    headers.delete('Content-Length')
  end

  def csv_lines export
    # setting the body to an enumerator, rails will iterate this enumerator
    Enumerator.new do |enum|
      enum << export.csv_header.to_s

      export.csv_lines do |object_instance|
        enum << export.csv_row(object_instance).to_s
      end
    end
  end
end
