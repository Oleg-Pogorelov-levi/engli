class Error404Controller < ApplicationController
  def not_found
    render 'errors/not_found', status: 404, layout: 'error'
  end
end