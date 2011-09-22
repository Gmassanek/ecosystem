class Tutorial < ActiveRecord::Base
  belongs_to :item, :polymorphic => true

  has_one :created_by, :foreign_key => 'id', :class_name => "User"
  has_one :last_updated_by, :foreign_key => 'id', :class_name => "User"

  attr_accessible :item_id, :item_type, :title, :description, :content, :last_updated_by_id
  attr_accessor :created_by_id, :last_updated_by_id

  validates :title, :presence => true
  validates :description, :presence => true
  validates :content, :presence => true

  def to_s
    title
  end
end
