require 'rails_helper'
require 'sidekiq/testing'  # Add this line to include Sidekiq's testing module


RSpec.describe SendWelcomeEmailJob, type: :job do
  let(:user) { create(:user) }  # Assuming you have a factory for User
  before do
    # Simulates Sidekiq job enqueuing without performing
    # Use fake mode to prevent jobs from being processed immediately
    Sidekiq::Testing.fake!
  end

  describe "Job enqueuing" do
    it "enqueues a SendWelcomeEmailJob" do
      expect {
        SendWelcomeEmailJob.perform_async(user.id)
      }.to change(SendWelcomeEmailJob.jobs, :size).by(1)
    end
  end

  describe "Job execution" do
    it "sends a welcome email" do
      mailer = double("UserMailer", deliver_now: true)
      expect(UserMailer).to receive(:welcome_email).with(user).and_return(mailer)

      # Directly call perform method to test execution
      SendWelcomeEmailJob.new.perform(user.id)
    end

    it "finds the user by id" do
      expect(User).to receive(:find).with(user.id).and_return(user)
      SendWelcomeEmailJob.new.perform(user.id)
    end
  end
  
  describe "Error handling" do
    it "raises an error if user not found" do
      expect {
        SendWelcomeEmailJob.new.perform(-1)  # Pass an invalid user ID
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
