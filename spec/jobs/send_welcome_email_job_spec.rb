require 'rails_helper'

RSpec.describe SendWelcomeEmailJob, type: :job do
  let(:user) { create(:user) }  # Assuming you have a factory for User

  describe "Checks the Job" do
    it "sends a welcome email" do
        # Mock the UserMailer to avoid sending a real email
        mailer = double("UserMailer")
        allow(UserMailer).to receive(:welcome_email).with(user).and_return(mailer)
        expect(mailer).to receive(:deliver_now)
    
        # Perform the job
        described_class.new.perform(user.id)
    end
    
    it "finds the user by id" do
        expect(User).to receive(:find).with(user.id).and_return(user)
        described_class.new.perform(user.id)
    end
  end
  
end
