class Province < ActiveRecord::Base
  belongs_to :region
  has_many :communes
end
