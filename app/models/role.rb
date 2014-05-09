class Role < ActiveRecord::Base
  has_many :users

  def is?(name)
    self.name.to_sym == name
  end
end
