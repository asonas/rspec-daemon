class User
  attr_accessor :birthday

  def initialize(birthday)
    @birthday = birthday
  end

  def age
    (Time.now.strftime("%Y%m%d").to_i - self.birthday.strftime("%Y%m%d").to_i) / 10000
  end
end

RSpec.describe "User" do
  describe "#age" do
    before do
      @user = User.new(Time.new(1988, 11, 7))
    end

    it "should return 34" do
      expect(@user.age).to eql 34
    end
  end
end
