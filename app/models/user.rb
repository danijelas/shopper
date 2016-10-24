class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :lists, dependent: :destroy
  has_many :categories, -> { order(id: :asc) },  dependent: :destroy
  has_many :units, -> { order(id: :asc) },  dependent: :destroy

  after_create :populate_categories, :populate_units

  validates :first_name, :last_name, :currency, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  private

  def populate_categories
    self.categories << Category.new(name: 'Dairy')
    self.categories << Category.new(name: 'Bakery')
    self.categories << Category.new(name: 'Fruits & Vegetables')
    self.categories << Category.new(name: 'Meat')
    self.categories << Category.new(name: 'Home Chemistry')
    self.categories << Category.new(name: 'Miscellaneous')
  end

  def populate_units
    self.units << Unit.new(name: 'kg')
    self.units << Unit.new(name: 'l')
    self.units << Unit.new(name: 'm')
    self.units << Unit.new(name: 'pic')
    self.units << Unit.new(name: 'other')
  end
end
