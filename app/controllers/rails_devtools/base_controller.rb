# frozen_string_literal: true

module RailsDevtools
  class BaseController < ApplicationController
    layout -> { ApplicationLayout }
  end
end
