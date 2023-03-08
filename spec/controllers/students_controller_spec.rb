require 'rails_helper'
# @routes = Rails.application.routes



# RSpec.configure do |config|
#   config.include Devise::Test::ControllerHelpers, type: :controller
# end


# def sign_in(user = double('user'))
#   if user.nil?
#     allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
#     allow(controller).to receive(:current_user).and_return(nil)
#   else
#     allow(request.env['warden']).to receive(:authenticate!).and_return(user)
#     allow(controller).to receive(:current_user).and_return(user)
#   end
# end

RSpec.describe StudentsController, type: :controller do
  before do
    @user = User.create(email:'student@gmail.com', password:'password', confirmed_at:Time.now)
    sign_in @user
    @course1 = Course.create(course_name:"CSCE 411", teacher:'student@gmail.com', section:'501', semester:'Spring 2023')
    @course2 = Course.create(course_name:"CSCE 411", teacher:'student@gmail.com', section:'501', semester:'Fall 2023')
    @course3 = Course.create(course_name:"CSCE 412", teacher:'student@gmail.com', section:'501', semester:'Spring 2024')
    
    @student = Student.create(firstname:'Zebulun', lastname:'Oliphant', uin:'734826482', email:'zeb@tamu.edu', classification:'U2', major:'CPSC', teacher:'student@gmail.com')

    @student_course1 = StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2023', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: '100')
    @student_course2 = StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2024', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: '100')
  end

  describe "#controller" do
    
    # around(:each) do |example|
    #   controller.class.skip_before_action :authenticate_user
    #   example.run
    #   controller.class.before_action :authenticate_user
    # end
    

    it "calls index successfully" do
      get :index, params: { id: @student }
      expect(response).to have_http_status(:successful)
    end

    it "shows successfully" do
        get :show, params: { id: @student.id }
        expect(response).to have_http_status(:successful)
    end

    it "creates a new student" do
      expect {
        post :create, params: { student: {
          firstname: 'John', 
          lastname: 'Doe', 
          uin: '123456789', 
          email: 'johndoe@example.com', 
          classification: 'U1', 
          major: 'CPSC',
          teacher: 'team_cluck_admin@gmail.com'
        } }
      }.to change(Student, :count).by(1) # should be 1 once signing in works
    end

    it "updates successfully" do
        get :show, params: { id: @student.id }
    end

    it "deletes successfully" do
        get :show, params: { id: @student.id }
    end


  end

  describe "#edit" do
    
    it "collects all student courses and logs them" do
      allow(Rails.logger).to receive(:info)
      get :edit, params: { id: @student.id }
      
      expect(assigns(:all_student_course_entries)).to eq([@student_course1, @student_course2])
      #expect(assigns(:student_course_records_hash)).to eq({ @course2.id => an_instance_of(StudentCourseEntry), @course3.id => an_instance_of(StudentCourseEntry) })
      expect(assigns(:all_student_course_ids)).to eq([@course2.id, @course3.id])
      expect(assigns(:courses)).to eq([@course2, @course3])
      expect(assigns(:student_course_records)).to match_array([an_instance_of(StudentCourseEntry), an_instance_of(StudentCourseEntry)])
      expect(Rails.logger).to have_received(:info).with(/Collected all student courses/)
    end
  end


end