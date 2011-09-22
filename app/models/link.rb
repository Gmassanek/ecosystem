class Link < ActiveRecord::Base
  belongs_to :linkable, :polymorphic => true
  #validates :linkable, :presence => true
  has_one :created_by, :foreign_key => 'id', :class_name => "User"
  has_one :last_updated_by, :foreign_key => 'id', :class_name => "User"
  attr_accessor :created_by_id, :last_updated_by_id
  attr_reader  :created_by_id, :last_updated_by_id

  validates :url, :presence => true, :format => {:with => URI::regexp}

  def to_s
    "#{linkable.to_s} (#{url})"
  end
end
