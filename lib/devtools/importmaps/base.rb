module Devtools
  module Importmaps
    class Base
      def self.pin(name, to: nil, preload: true, vendor: false)
        to = to.nil? ? "#{name}.js" : to
        pins << Pin.new(name, to, preload, vendor)
      end

      def self.pin_all_from(directory, under:, preload: true)
        Dir.glob("#{directory}/**/*.js").each do |file|
          path = Pathname.new(file)
          if path.basename.to_s == "index.js"
            pin(under, to: "#{under}/index.js", preload: preload)
          else
            name = file.sub("#{directory}/", "").sub(/\.js$/, "")
            to = "#{under}/#{name}"
            pin(to, to: "#{to}.js", preload: preload)
          end
        end
      end

      def self.pins
        @pins ||= []
      end

      def preloads
        pins.select(&:preload)
      end

      def pins
        self.class.pins
      end

      def to_json(**)
        imports = self.class.pins.each_with_object({}) do |pin, memo|
          memo[pin.name] = pin.path
        end

        JSON.pretty_generate({ imports: imports })
      end

      def find(item)
        pins.find { |p| p.to == "#{item}.js" }
      end
    end
  end

  class Pin
    attr_reader :name, :to, :preload, :vendor

    def initialize(name, to, preload, vendor)
      @name = name
      @to = to
      @preload = preload
      @vendor = vendor
    end

    def file_path
      @file_path ||= @vendor ? vendor_path_to(to) : local_javascript_path_to(to)
    end

    def path
      @path ||= Pathname.new("/devtools").join("frontend", "modules").join(to)
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
