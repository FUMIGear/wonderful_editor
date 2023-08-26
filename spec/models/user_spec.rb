# Task6-3の模範回答を全部コピペ
require "rails_helper"
RSpec.describe User, type: :model do
  context "必要な情報が揃っている場合" do
    let(:user) { build(:user) }
    it "ユーザー登録できる" do
      # binding.pry
      expect(user).to be_valid #バリデーションが有効であればOK
    end
  end

  context "名前のみ入力している場合" do
    # FactoryBotで生成するキーが指定されても、ここで値を指定できる。
    let(:user) { build(:user, email: nil, password: nil) }
    it "エラーが発生する" do
      expect(user).not_to be_valid
    end
  end

  context "email がない場合" do
    let(:user) { build(:user, email: nil) }
    it "エラーが発生する" do
      expect(user).not_to be_valid
    end
  end

  context "password がない場合" do
    let(:user) { build(:user, password: nil) }
    it "エラーが発生する" do
      expect(user).not_to be_valid
    end
  end
end
