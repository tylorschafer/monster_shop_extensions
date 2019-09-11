require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  xdescribe "password_reset" do

    # let(:user) { User.create(name: "Evette", address: "123 street", city: "Denver", state: "CO", zip: "12345", email: "me@email.com", password: "12", password_confirmation: "12") }
    # let(:mail) { UserMailer.password_reset(user) }

    before :each do
        @user = User.create(name: "Evette", address: "123 street", city: "Denver", state: "CO", zip: "12345", email: "me@email.com", password: "12", password_confirmation: "12")

        @mail = UserMailer.password_reset(@user)
    end

    it "renders the email" do
      expect(@mail.subject).to eq("Password reset")
      expect(@mail.to).to eq([@user.email])
      expect(@mail.from).to eq(["king-pug@pugglywuggly.com"])
      expect(@mail.body.encoded).to have_content("woof")
    end
  end
end