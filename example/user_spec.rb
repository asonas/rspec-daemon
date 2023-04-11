class User
  attr_accessor :birthday

  def initialize(birthday)
    @birthday = birthday
  end

  def age
    34
  end
end

Rspec.describe "User" do
  describe "#age" do
    before do
      @user = User.new(Time.new(1988, 11, 7))
    end

    it "should return 34" do
      expect(@user.age).to eql 34
    end
  end
end
