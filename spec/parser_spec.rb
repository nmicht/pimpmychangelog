require 'spec_helper'

describe Parser do

  describe "#initialize" do
    it "should take a changelog" do
      p = Parser.new('CHANGELOG')
      p.changelog.should == 'CHANGELOG'
    end
  end

  describe "#content" do
    context "when the changelog has link definitions" do
      let(:changelog) { <<-EOS
# My Awesome ChangeLog

This my awesome changelog.

<!--- The following link definition list is generated by PimpMyChangelog --->
#123: https://whatever
@pcreux: https://github.com/pcreux
EOS
      }

      it "should return the ChangeLog without the link definitions" do
        Parser.new(changelog).content.should == <<-EOS
# My Awesome ChangeLog

This my awesome changelog.

EOS
      end
    end # context "when the changelog has link definitions"

    context "when the changelog does not have link definitions" do
      let(:changelog) { "# My Awesome ChangeLog" }

      it "should return the ChangeLog without the link definitions" do
        Parser.new(changelog).content.should == changelog
      end
    end # context "when the changelog has link definitions"
  end # describe "#content"

  describe "#issues" do
    it "should return a sorted list of unique issue numbers" do
      Parser.new("#20 #100 #300 #20").issues.should == ['20', '100', '300']
    end
  end

  describe "#contributors" do
    it "should return a sorted list of unique contributors" do
      Parser.new("@samvincent @pcreux @gregbell @pcreux @dash-and_underscore").contributors.
        should == ['dash-and_underscore', 'gregbell', 'pcreux', 'samvincent']
    end
  end
end
