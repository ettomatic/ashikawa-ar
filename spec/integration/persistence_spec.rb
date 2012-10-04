require 'integration/spec_helper'

describe Ashikawa::AR::Search do
  before(:all) {
    require 'examples/person.rb'

    Ashikawa::AR.setup :default, ARANGO_HOST
    database = Ashikawa::Core::Database.new ARANGO_HOST
    @collection = database["people"]
    @collection.truncate!
  }

  subject { Person.new name: "Sam Lowry", age: 38 }

  [:save, :save!, :save_without_validation].each do |method|
    it "should save a document" do
      expect do
        subject.send method
      end.to change { @collection.length }.by 1
    end

    it "should not create a new document if it is already saved" do
      subject.send method

      expect do
        subject.send method
      end.to change { @collection.length }.by 0
    end

    it "should update a document with new content" do
      subject.send method

      id = subject.id

      subject.name = "Jonathan Pryce"
      subject.send method

      @collection[id]["name"].should == "Jonathan Pryce"
    end
  end

  it "should not save an invalid document when using save" do
    subject.age = "invalid"

    expect do
      subject.save
    end.to change { @collection.length }.by 0
  end

  it "should throw an exception when saving an invalid document using save!" do
    subject.age = "invalid"

    expect { subject.save! }.to raise_error Ashikawa::AR::InvalidRecord
  end

  it "should save an invalid document when using save_without_validation" do
    subject.age = "invalid"

    expect do
      subject.save_without_validation
    end.to change { @collection.length }.by 1
  end

  it "should reload documents from the database on demand" do
    subject.save

    raw_document = @collection[subject.id]
    raw_document["age"] = 39
    raw_document.save

    subject.age.should == 38
    subject.reload
    subject.age.should == 39
  end

  it "should throw an exception when reloading an unsaved document" do
    expect { subject.reload }.to raise_error Ashikawa::AR::UnsavedRecord
  end

  it "should be possible do delete from the database" do
    subject.save
    @collection[subject.id].should_not be_nil

    subject.delete
    expect { @collection[subject.id] }.to raise_error Ashikawa::Core::DocumentNotFoundException
  end

  it "should throw an exception when deleting an unsaved document" do
    expect { subject.delete }.to raise_error Ashikawa::AR::UnsavedRecord
  end
end
