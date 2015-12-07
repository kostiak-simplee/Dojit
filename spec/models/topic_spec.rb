require 'rails_helper'

describe Topic do 
  describe "scopes" do
    before do
      @public_topic = Topic.create(name: 'something')
      @private_topic = Topic.create(name: 'something')
    end

    describe "publicaly_viewable" do
      it "returns a relation of all public topics" do
        expect(Topic.publicaly_viewable).to eq( Topic.where(public:true))
      end
    end

    describe "privately_viewable" do
      it "returns a relation of all private topics" do
        expect(Topic.privately_viewable).to eq(Topic.all)
      end
    end

    describe "visible_to(user)" do
      it "returns all topics if the user is present" do
        user = true
        expect(Topic.visible_to(user)).to eq(Topic.all)
      end

      it "returns only public topics if user is nil" do
        user = nil
        expect(Topic.visible_to(user)).to eq(Topic.where(public: true))
      end
    end
  end
end