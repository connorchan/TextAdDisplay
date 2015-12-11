class AdFile < ActiveRecord::Base
  belongs_to :user
  has_attached_file :text_ad_file
  validates_attachment_content_type :text_ad_file, content_type: /\Atext\/csv\Z/
  validates_attachment_file_name :text_ad_file, matches: /csv\Z/
end
