require "spec_helper"

describe ComplaintNotifier do
  describe "received" do
    let(:mail) { ComplaintNotifier.received }

    it "renders the headers" do
      mail.subject.should eq("Received")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
