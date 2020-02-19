class ReportsController < ApplicationController

  before_action :load_users
  before_action :set_response_format

  def current
  end

  def previous
  end

  private

  # Loads all non-salary users.
  def load_users
    @users = User.by_number #.without_salary
  end

  # Sets response format to JSON.
  def set_response_format
    request.format = :json
  end

end