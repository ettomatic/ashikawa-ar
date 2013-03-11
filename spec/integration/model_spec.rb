
describe Ashikawa::AR::Search do
  before(:all) {
    require 'examples/person.rb'

    Ashikawa::AR.setup :default, ARANGO_HOST
    database = Ashikawa::Core::Database.new do |config|
        config.url = ARANGO_HOST
      end
    @collection = database["people"]
    @collection.truncate!
    @johnny = @collection.create_document name: "Johnny"
    @jens = @collection.create_document name: "Jens"
  }

  subject { Person }

  it "should get the right status of a found record" do
    person = subject.find @johnny.key
    person.new_record?.should be_false
    person.persisted?.should be_true
    person.deleted?.should be_false
  end
end
