module Devtools
  class ImageMiddleware
    IMAGE_EXTENSIONS = {
      '.jpg'  => 'image/jpeg',
      '.jpeg' => 'image/jpeg',
      '.png'  => 'image/png',
      '.gif'  => 'image/gif',
      '.svg'  => 'image/svg+xml',
      '.webp' => 'image/webp',
      '.avif' => 'image/avif',
      '.ico'  => 'image/x-icon'
    }.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      image_path = find_source_image(env["PATH_INFO"])
      return @app.call(env) unless image_path

      [
        200,
        {
          "Content-Type" => content_type_for(image_path),
          "X-Image-Source" => image_path.to_s
        }, 
        [File.read(image_path)]
      ]
    end

    private

    def image?(path)
      IMAGE_EXTENSIONS.keys.include?(extension(path))
    end

    def find_source_image(path)
      return nil unless image?(path)
      filename = CGI.unescape(File.basename(path))

      found = nil

      Devtools.asset_config.paths.each do |path|
        paths = Dir.glob("#{path}/**/*#{filename}*")
        found = paths.find { |path| File.file?(path) }
        break if found
      end

      found
    end

    def extension(path)
      File.extname(path).downcase
    end

    def content_type_for(path)
      extension = extension(path)
      IMAGE_EXTENSIONS.fetch(extension, 'application/octet-stream')
    end
  end
end
