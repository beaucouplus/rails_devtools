module Devtools
  module Frontend
    class ModulesController < ApplicationController
      protect_from_forgery except: :show

      def show
        render file: Devtools.importmap.find(params[:path]).file_path
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
