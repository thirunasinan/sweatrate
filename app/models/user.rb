class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :sports
  has_one :units

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  def sports
    Sports.where(:id => self.widget_config)
  end

  def units
    Units.where(:id => self.unit_type)
  end

  def activities
    Activities.where(:user_id => self.id)
  end
end
