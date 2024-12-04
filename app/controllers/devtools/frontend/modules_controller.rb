module Devtools
  module Frontend
    class ModulesController < ApplicationController
      protect_from_forgery except: :show

      def show
        paths = {
          "turbo.min.js" => vendor_path_to("turbo.min.js"),
          "stimulus.min.js" => vendor_path_to("stimulus.min.js"),
          "stimulus-loading.js" => vendor_path_to("stimulus-loading.js"),
          "@stimulus-components--reveal.js" => vendor_path_to("@stimulus-components--reveal.js"),
          "@stimulus-components--clipboard.js" => vendor_path_to("@stimulus-components--clipboard.js"),
          "@stimulus-components--notification.js" => vendor_path_to("@stimulus-components--notification.js"),
          "stimulus-use.js" => vendor_path_to("stimulus-use.js"),
          "application.js" => local_javascript_path_to("application.js"),
          "controllers/application.js" => local_javascript_path_to("controllers/application.js"),
          "controllers/checkbox_controller.js" => local_javascript_path_to("controllers/checkbox_controller.js"),
          "controllers/index.js" => local_javascript_path_to("controllers/index.js"),
          "controllers/search_reset_controller.js" => local_javascript_path_to("controllers/search_reset_controller.js"),
          "controllers/turbo_form_controller.js" => local_javascript_path_to("controllers/turbo_form_controller.js")
        }

        render file: paths.fetch("#{params[:path]}.js")
      end

      private

      def engine_path_to(*args)
        Devtools::Engine.root.join(*args)
      end

      def vendor_path_to(filename)
        engine_path_to("vendor", "javascript", filename)
      end

      def local_javascript_path_to(filename)
        engine_path_to("app", "javascript", filename)
      end
    end
  end
end
