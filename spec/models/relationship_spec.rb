require 'spec_helper'

describe Relationship do
  before do
    @rel = Fabricate(:relationship)
  end
  it "displays the relationship from node1 to node2" do
    Ecosystem::SentenceSubstitution.should_receive(:populate).with(@rel.sentence1, @rel.node1.to_s, @rel.node2.to_s)
    @rel.sent1
  end
  # it "substitutes two values in a sentence for the %1 and %2 in the sentence" do
  #   @rel.populate(sentence1, node1.title, node2.title).should == ""
  # end
  it "displays the relationship from node2 to node1" do
    @rel.sent2.should include(@rel.node1.title)
    @rel.sent2.should include(@rel.node2.title)
  end
  it "doesn't change sentence1 even after calling sentence1to2" do
    sent = @rel.sentence1
    @rel.sent1
    @rel.save
    sent.should == @rel.sentence1
  end
  it "responds to node1" do
    @rel.should respond_to(:node1)
  end
  it "is invalid if the sentence 1 is blank" do
    @rel.sentence1 = nil
    @rel.should_not be_valid
  end
  it "is invalid if the sentence 2 is blank" do
    @rel.sentence2 = nil
    @rel.should_not be_valid
  end
  it "is invalid if the sentence 1 doesn't contain a %1 and a %2" do
    @rel.sentence1 = "This should be %2 invalid"
    @rel.should_not be_valid
    @rel.sentence1 = "This should be %1 invalid"
    @rel.should_not be_valid
  end
  it "is invalid if the sentence 2 doesn't contain a %1 and a %2" do
    @rel.sentence2 = "This should be %2 invalid"
    @rel.should_not be_valid
    @rel.sentence2 = "This should be %1 invalid"
    @rel.should_not be_valid
  end
  it "is invalid if node1 or node2 are blank" do
    @rel.node1 = nil
    @rel.should_not be_valid
    @rel.node1 = @rel.node1
    @rel.node2 = nil
    @rel.should_not be_valid
  end
  it "is valid if %1 or %2 are not separated from other characters by white space" do
    @rel.sentence1 = "(%1) %2"
    @rel.should be_valid
  end
  describe "relationship key" do
    it "replies to .key function" do
      @rel.should respond_to(:key)
    end
    it "has the same key as the opposite relationship" do
      @rel2 = @rel.clone
      @rel2.node1 = @rel.node2
      @rel2.node2 = @rel.node1
      @rel2.key.should == @rel.key
    end
    it "restricts a key to being unique" do
      @rel2 = @rel.clone
      @rel2.node1 = @rel.node2
      @rel2.node2 = @rel.node1
      @rel2.should_not be_valid
    end
    it "defaults the key and saves it" do
      @rel.key.should_not be_nil
    end
  end
  it "can't save with the same two nodes" do
    @rel.node2 = @rel.node1
    @rel.should_not be_valid
  end
  it "responds to .sentence(node)" do
    @rel.sentence_from(@rel.node1).should == @rel.sent1
  end
  it "responds to .other_node(node)" do
    @rel.other_node(@rel.node1).should == @rel.node2
  end
end

