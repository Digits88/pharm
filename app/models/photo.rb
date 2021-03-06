class Photo < ActiveRecord::Base
  PHOTO_SIZES = {
    :small  => '600',
    :medium => '800',
    :large  => '990'
  }
  
  has_attached_file :asset, 
    :path            => ":rails_root/public/uploads/:attachment/:id/:style/:basename.:extension",
    :url             => "/uploads/:attachment/:id/:style/:basename.:extension",
    :default_url     => "/images/:attachment/missing_:style.gif",
    :convert_options => { :thumb => "-strip" },
    :styles          => 
      # { :thumb  => "90x80^",
      { :thumb  => "120>",
        :small  => "#{PHOTO_SIZES[:small]}>",
        :medium => "#{PHOTO_SIZES[:medium]}>",
        :large  => "#{PHOTO_SIZES[:large]}>"}

  named_scope :previous, lambda { |created_at| {:conditions => ['created_at < ?', created_at], :order => 'created_at DESC', :limit => 1} }
  named_scope :following, lambda { |created_at| {:conditions => ['created_at > ?', created_at], :order => 'created_at ASC', :limit => 1} }
  named_scope :selection, lambda { |selection| {:select => selection} }
  named_scope :limited, lambda { |num| {:limit => num} }
  named_scope :ordered, lambda { |*order| {:order => order.flatten.first || 'created_at DESC'} }

  validates_attachment_presence :asset
  validates_attachment_size :asset, :less_than => 10.megabytes
  validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg']

  xss_terminate :except => [:body, :body_html]  # These will be protected on the front-end via sanitize

  attr_accessible :title, :body, :asset
  
  def previous(circular=false)
    return @previous if @previous
    @previous ||= Photo.previous(self.created_at).first
    return @previous if @previous || !circular
    Photo.ordered.limited(1)
  end
  
  def following
    @following ||= Photo.following(self.created_at).first
  end
  
  def body
    read_attribute(:body) || ""
  end
  
  def body=(_body)
    self.write_attribute(:body, _body)
    self.body_html = RedCloth.new(_body).to_html
  end

end
