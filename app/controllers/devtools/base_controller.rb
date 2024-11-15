# frozen_string_literal: true

module Devtools
  class BaseController < ApplicationController
    layout -> { DashboardLayout }
  end
end
