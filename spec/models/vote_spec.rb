describe Vote do
  describe "validations" do
    describe "value validation" do
      it "allows -1 as value" do
        expect(Vote.new(value: -1).valid?).to eq(true)
      end

      it "allows 1 as value" do
        expect(Vote.new(value: 1).valid?).to eq(true)
      end

      it "doesn't allow any other value" do
        expect(Vote.new(value: 0).valid?).to eq(false)
        expect(Vote.new(value: 42).valid?).to eq(false)
        expect(Vote.new(value: -2).valid?).to eq(false)
      end
    end
  end
end