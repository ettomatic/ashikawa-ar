require 'integration/spec_helper'
require 'examples/person.rb'

describe "Basics" do
  it "should recognize the truth" do
    true.should be_true
  end

  describe "basic functionality" do
    subject { Person }

    it "should provide virtus and aequitas" do
      person = subject.new name: "George", age: "33"
      person.age.should == 33
      person.valid?.should be_true
    end

    it "should provide the collection name" do
      subject.model_name.collection.should == "people"
    end
  end
end
