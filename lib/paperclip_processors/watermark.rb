# lib/paperclip_proccessors/watermark.rb
module Paperclip
  # Handles watermarking images that are uploaded.
  class Watermark < Processor

    attr_accessor :current_geometry, :whiny, :watermark_path, :watermark_position, :watermark_ratio, :watermark_dissolve

    # Adds a watermark object (+watermark_path+) to the +file+ given.
    # It creates a dissolved (+watermark_dissolve+) layer at (+watermark_position+) and
    # will attempt to transform the watermark to fit a given ratio (+watermark_ratio+).
    # Example: A +watermark_ratio+ of 25 with +watermark_position SouthEast will place the
    # watermark to the left bottom of the given file and, if needed, shrinks it to maximum 25% of either
    # width or height of the file given by keeping its aspect ratio. So it neither crops the watermark
    # nor scales it up. For further positioning details see ImageMagick gravity option.
    # Watermark creation will raise no errors unless +whiny+ is true (which it is, by default).
    def initialize file, options = {}, attachment = nil
      super
      @file                = file
      @current_geometry    = Geometry.from_file @file
      @whiny               = options[:whiny].nil? ? true : options[:whiny]

      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)

      @watermark_path      = options[:watermark_path]     || File.join(RAILS_ROOT, 'public', 'images', 'watermark.png')
      @watermark_position  = options[:watermark_position] || 'SouthEast'
      @watermark_dissolve  = options[:watermark_dissolve] || 30
      @watermark_ratio     = options[:watermark_ratio] || 25
    end

    # Performs the composition of the +file+ with the watermark. Returns the Tempfile that contains the new image.
    def make
      src = @file
      dst = Tempfile.new(@basename)
      dst.binmode

      command = <<-end_command
        #{transformation_command}
        "#{File.expand_path(src.path)}[0]"
        "#{File.expand_path(dst.path)}"
      end_command

      begin
        success = Paperclip.run('composite', command.gsub(/\s+/, ' '))
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny
      end

      dst
    end

    # Returns the command ImageMagick's +composite+ needs to add the watermark to the image.
    def transformation_command

      watermark_max_width  = (@current_geometry.width.to_i * (@watermark_ratio.to_f / 100)).to_i
      watermark_max_height = (@current_geometry.height.to_i * (@watermark_ratio.to_f / 100)).to_i

      trans = " -dissolve #{@watermark_dissolve} -gravity #{@watermark_position} \\( '#{@watermark_path}' -resize #{watermark_max_width}x#{watermark_max_height} \\) "
    end
  end
end 