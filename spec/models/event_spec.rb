require 'spec_helper'

describe Event do
  describe "Associations" do
    it { should belong_to(:project) }
    it { should belong_to(:target) }
  end

  describe "Respond to" do
    it { should respond_to(:author_name) }
    it { should respond_to(:author_email) }
    it { should respond_to(:issue_title) }
    it { should respond_to(:merge_request_title) }
    it { should respond_to(:commits) }
  end

  describe "Push event" do 
    before do 
      project = Factory :project
      @user = project.owner

      data = { 
        before: "0000000000000000000000000000000000000000",
        after: "0220c11b9a3e6c69dc8fd35321254ca9a7b98f7e",
        ref: "refs/heads/master",
        user_id: @user.id,
        user_name: @user.name,
        repository: {
          name: project.name,
          url: "localhost/rubinius",
          description: "",
          homepage: "localhost/rubinius",
          private: true
        }
      }

      @event = Event.create(
        project: project,
        action: Event::Pushed,
        data: data,
        author_id: @user.id
      )
    end

    it { @event.push?.should be_true }
    it { @event.allowed?.should be_true }
    it { @event.new_branch?.should be_true }
    it { @event.tag?.should be_false }
    it { @event.branch_name.should == "master" }
    it { @event.author.should == @user }
  end
end
