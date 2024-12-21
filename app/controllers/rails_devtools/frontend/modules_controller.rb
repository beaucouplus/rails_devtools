module RailsDevtools
  module Frontend
    class ModulesController < ApplicationController
      protect_from_forgery except: :show

      def show
        file = RailsDevtools.importmap.find(params[:path]).file_path
        return head :not_found unless file

        send_file(
          file,
          type: "application/javascript",
          disposition: "inline"
        )
      end
    end
  end
end
