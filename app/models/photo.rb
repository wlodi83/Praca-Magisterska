require 'paperclip_processors/watermark'
require 'mime/types'
class Photo < ActiveRecord::Base
  named_scope :random, lambda { |n| {:order => "RAND()", :limit => n || 1 }}
  belongs_to :article
  belongs_to :user
  has_attached_file :file,
                    :styles => {:thumb => '100x100#',
                    :preview => {
                      :processors => [:watermark],
                      :geometry => '640x480>',
                      :watermark_path => "#{Rails.root}/public/images/watermark.png",
                      :watermark_position => 'SouthEast',
                      :position => 'Center',
                      :watermark_dissolve => 100
                    }
                   }
  # Paperclip Validations
  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg']
   # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.file = data
  end
end
