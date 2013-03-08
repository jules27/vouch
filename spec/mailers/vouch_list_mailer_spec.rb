require "spec_helper"

describe VouchListMailer do
  describe "share_vouch" do
    let(:mail) { VouchListMailer.share_vouch }

    it "renders the headers" do
      mail.subject.should eq("Share vouch")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
