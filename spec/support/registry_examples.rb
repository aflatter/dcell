shared_context "a DCell registry" do
  context "node registry" do
    before :each do
      subject.clear(:nodes)
    end

    it "stores node addresses" do
      address = "tcp://localhost:7777"

      subject.set(:nodes, "foobar", address)
      subject.get(:nodes, "foobar").should == address
    end

    it "stores the IDs of all nodes" do
      subject.set(:nodes, "foobar", "tcp://localhost:7777")
      subject.keys(:nodes).should include "foobar"
    end
  end

  context "global registry" do
    before :each do
      subject.clear(:global)
    end

    it "stores values" do
      subject.set(:global, "foobar", [1,2,3])
      subject.get(:global, "foobar").should == [1,2,3]
    end

    it "stores the keys of all globals" do
      subject.set(:global, "foobar", true)
      subject.keys(:global).should include "foobar"
    end
  end
end
