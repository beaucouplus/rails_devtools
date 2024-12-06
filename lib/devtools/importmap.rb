# frozen_string_literal: true

module Devtools
  class Importmap < Importmaps::Base
    pin "@hotwired/turbo-rails", to: "turbo.min.js", vendor: true
    pin "@hotwired/stimulus", to: "stimulus.min.js", vendor: true
    pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", vendor: true
    pin "@stimulus-components/reveal", to: "@stimulus-components--reveal.js", vendor: true # @5.0.0
    pin "@stimulus-components/clipboard", to: "@stimulus-components--clipboard.js", vendor: true # @5.0.0
    pin "@stimulus-components/notification", to: "@stimulus-components--notification.js", vendor: true # @3.0.0
    pin "stimulus-use", vendor: true # @0.52.2

    pin "application"
    pin_all_from Devtools::Engine.root.join("app/javascript/controllers"), under: "controllers"
  end
end
