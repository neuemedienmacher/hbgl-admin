class ExportsController < ApplicationController
  include RemoteShow

  def new
    form Export::Create
  end

  def create
    run Export::Create do |operation|
      set_file_headers
      set_streaming_headers
      response.status = 200
      return self.response_body = csv_lines(operation.model)
    end

    flash.now[:error] = 'Export konnte nicht erstellt werden.'
    render :new
  end

  private

  def set_file_headers
    file_name = "#{params[:object_name]}_export_#{Time.now}.csv"
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
