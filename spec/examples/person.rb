class Person
  include Ashikawa::AR::Model

  attribute :name, String
  attribute :age, Integer
  attribute :favorite_color, String

  validates_presence_of :name, :age
  validates_numericalness_of :age
end
