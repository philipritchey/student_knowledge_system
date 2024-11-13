# frozen_string_literal: true

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
  describe '#parse' do
    before(:each) do
      @user = User.create(email: 'test@example.com', confirmed_at: Time.now)
      allow(controller).to receive(:current_user).and_return(@user)
      @course = Course.create(course_name: 'test course', teacher: @user.email, section: '999', semester: 'Fall 2000')
    end

    context 'with valid file and contents' do
      before do
        @course1 = Course.create(course_name: 'test course1', teacher: @user.email, section: '000',
                                 semester: 'Fall 2002')
      end

      it 'creates student entries after uploading a valid csv and .htm file' do
        csv = fixture_file_upload('export.csv', 'text/csv')
        complete_webpage_file = fixture_file_upload('Howdy Dashboard _ Howdy.htm', 'text/html')
        params = { csv_file: csv, complete_webpage_file:, course_temp: @course.course_name,
                   section_temp: @course.section, semester_temp: @course.semester }
        post(:parse, params:)
        susheel = Student.find_by firstname: 'Susheel'
        expect(susheel.firstname).to eq('Susheel')
        expect(flash[:notice]).to eq('Upload successful!')
      end

      it 'updates students that already exist' do
        @prev_student = Student.create(firstname: 'Susheel', lastname: 'Vadakkekuruppath', uin: '236002222',
                                       email: 'zeb@tamu.edu', classification: 'G7', major: 'CPSC', teacher: @user.email)
        csv = fixture_file_upload('export.csv', 'text/csv')
        complete_webpage_file = fixture_file_upload('Howdy Dashboard _ Howdy.htm', 'text/html')
        params = { csv_file: csv, complete_webpage_file:, course_temp: @course1.course_name,
                   section_temp: @course1.section, semester_temp: @course1.semester }
        post(:parse, params:)
        uploaded_student = Student.find_by uin: '236002222'
        puts "ups: #{uploaded_student.inspect}"
        expect(@prev_student.email).not_to eq(uploaded_student.email)
        expect(flash[:notice]).to eq('Upload successful!')
      end
    end

    # context "with invalid file and contents" do
    #   it "redirects when CSV column contents are different than expected" do
    #     file = fixture_file_upload('Wrong_Cols.zip', 'application/zip')
    #     params = { file: file, course_temp: @course.course_name, section_temp: @course.section,
    #                semester_temp: @course.semester }
    #     post :parse, params: params
    #     expect(flash[:notice]).to eq("CSV column contents are different than expected.")
    #   end

    #   it "redirects when number of images does not match number of students" do
    #     file = fixture_file_upload('Wrong_imgs.zip', 'application/zip')
    #     params = { file: file, course_temp: @course.course_name, section_temp: @course.section,
    #                semester_temp: @course.semester }
    #     post :parse, params: params
    #     expect(flash[:notice]).to eq("Number of images does not match number of students")
    #   end
    # end
  end
end
