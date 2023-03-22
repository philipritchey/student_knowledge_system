# code to set session cookie
# @user = User.find_by(email: email)
# session = Passwordless::Session.new({
#     authenticatable: @user,
#     user_agent: 'Command Line',
#     remote_addr: 'unknown',
# })
# session.save!
# cookies[:passwordless_token] = { value: session.token, expires: 1.hour.from_now }
# manually set current_user variable

# this line from passwordless gem does not work
# passwordless_sign_in(@user)

require 'rails_helper'

RSpec.describe UploadController, type: :controller do
  describe "#parse" do
    before(:each) do
      @user = User.create(email: "test@example.com", confirmed_at: Time.now)
      allow(controller).to receive(:current_user).and_return(@user)
      @course = Course.create(course_name: "test course", teacher: @user.email, section: "999", semester: "Fall 2000")
    end
  
    context "with valid file and contents" do
      it "creates a new course and student entries" do
        file = fixture_file_upload('ProfRitchey_Template.zip', 'application/zip')
        params = { file: file, course_temp: @course.course_name, section_temp: @course.section, semester_temp: @course.semester }
        post :parse, params: params
        kunal = Student.find_by firstname: 'Kunal'
        expect(kunal.firstname).to eq('Kunal')
        expect(flash[:notice]).to eq("Upload successful!")
      end
    end
  
  end
end