require 'integration/spec_helper'

describe Ashikawa::AR::Persistence do
  before(:all) {
    require 'examples/person.rb'

    Ashikawa::AR.setup :default, ARANGO_HOST
    database = Ashikawa::Core::Database.new do |config|
      config.url = ARANGO_HOST
    end
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
      key = subject.key

      subject.name = "Jonathan Pryce"
      subject.send method

      @collection[key]["name"].should == "Jonathan Pryce"
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

    raw_document = @collection[subject.key]
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
    @collection[subject.key].should_not be_nil

    key = subject.key

    subject.delete
    expect { @collection[key] }.to raise_error Ashikawa::Core::DocumentNotFoundException
  end

  it "should throw an exception when deleting an unsaved document" do
    expect { subject.delete }.to raise_error Ashikawa::AR::UnsavedRecord
  end

  it "should also delete the ID of the object" do
    subject.save
    subject.delete
    subject.key.should be_nil
  end

  it "should update a single attribute and save the record" do
    subject.save
    subject.update_attribute :age, 39

    @collection[subject.key]["age"].should == 39
  end

  it "should throw an exception when updating an attribute of an unsaved document" do
    expect { subject.update_attribute :age, 39 }.to raise_error Ashikawa::AR::UnsavedRecord
  end

  [:update_attributes, :update_attributes!].each do |method|
    it "should update a single attribute and save the record via #{method}" do
      subject.save
      subject.send method, age: 39, favorite_color: "Green"

      @collection[subject.key]["age"].should == 39
      @collection[subject.key]["favorite_color"].should == "Green"
    end

    it "should throw an exception when updating attributes of an unsaved document via #{method}" do
      expect { subject.send method, age: 39, favorite_color: "Green" }.to raise_error Ashikawa::AR::UnsavedRecord
    end
  end

  it "should return false when updating attributes without the bang" do
    subject.save
    subject.update_attributes(age: "old").should be_false
  end

  it "should raise an exception when updating attributes with the bang" do
    subject.save
    expect { subject.update_attributes!(age: "old") }.to raise_error Ashikawa::AR::InvalidRecord
  end

  describe "status of the objects" do
    it "should know if it is persisted" do
      subject.persisted?.should be_false
      subject.save
      subject.persisted?.should be_true
    end

    it "should know if it is deleted" do
      subject.save
      subject.deleted?.should be_false
      subject.delete
      subject.deleted?.should be_true
    end

    it "should know if it is a new record" do
      subject.new_record?.should be_true
      subject.save
      subject.new_record?.should be_false
    end
  end
end
