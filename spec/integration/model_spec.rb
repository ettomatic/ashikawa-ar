require 'integration/spec_helper'

describe Ashikawa::AR::Search do
  before(:all) {
    require 'examples/person.rb'

    Ashikawa::AR.setup :default, ARANGO_HOST
    database = Ashikawa::Core::Database.new ARANGO_HOST
    @collection = database["people"]
    @collection.truncate!
    @johnny = @collection.create name: "Johnny"
    @jens = @collection.create name: "Jens"
  }

  subject { Person }

  it "should get the right status of a found record" do
    person = subject.find @johnny.id
    person.new_record?.should be_false
    person.persisted?.should be_true
    person.deleted?.should be_false
  end
end
