# frozen_string_literal: true

module Devtools
  class DashboardController < BaseController
    def show
      render Dashboard::Show
    end
  end
end
