class Person
  include Ashikawa::AR::Model

  attribute :name
  attribute :age, Integer

  validates_presence_of :name, :age
  validates_numericalness_of :age
end
