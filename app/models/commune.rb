class Commune < ActiveRecord::Base
  belongs_to :province
  has_many :sectors
end
