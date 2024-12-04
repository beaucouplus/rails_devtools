# frozen_string_literal: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@stimulus-components/reveal", to: "@stimulus-components--reveal.js", preload: true # @5.0.0
pin "@stimulus-components/clipboard", to: "@stimulus-components--clipboard.js", preload: true  # @5.0.0
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js", preload: true  # @3.0.0
pin "stimulus-use" # @0.52.2

pin "application", to: "application.js", preload: true

pin_all_from Devtools::Engine.root.join("app/javascript/controllers"), under: "controllers"
