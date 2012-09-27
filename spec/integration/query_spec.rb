require 'integration/spec_helper'

describe "querying for documents" do
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

  it "should find a document by ID" do
    person = subject.find @johnny.id
    person.should be_instance_of subject
    person.name.should == "Johnny"
  end

  it "should find documents by aql query" do
    people = subject.find_by_aql "FOR u IN people RETURN u"
    people.length.should == @collection.length
    people.first.should be_instance_of subject
  end

  it "should find documents by example" do
    people = subject.by_example name: "Johnny"
    people.length.should == 1
    people.first.should be_instance_of subject
    people.first.name.should == "Johnny"
  end

  it "should find one document by example" do
    person = subject.first_example name: "Johnny"
    person.should be_instance_of subject
    person.name.should == "Johnny"
  end

  it "should return all documents" do
    people = subject.all
    people.length.should == @collection.length
    people.first.should be_instance_of subject
  end
end
