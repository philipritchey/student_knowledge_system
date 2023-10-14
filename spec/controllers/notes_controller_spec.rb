require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  before do
    puts "Before block: Creating user and student records"
    @user = User.create(email: 'student@gmail.com', confirmed_at: Time.now)
    allow(controller).to receive(:current_user).and_return(@user)
    @student = Student.create(
      firstname: 'Zebulun',
      lastname: 'Oliphant',
      uin: '734826482',
      email: 'zeb@tamu.edu',
      classification: 'U2',
      major: 'CPSC',
      teacher: 'student@gmail.com'
    )
    puts "Student ID: #{@student.id}"
  end

  describe "GET #new" do
    it "renders the new note form" do
      puts "GET #new test: Start"
      get :new, params: { student_id: @student.id } # Use the named route with parameters
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      expect(assigns(:note)).to be_a_new(Note)
      puts "GET #new test: End"
    end
  end

  describe "POST #create" do
    context "when creating a note for an existing student" do
      it "creates a new note and redirects to the student's page" do
        puts "POST #create test (existing student): Start"
        post :create, params: { student_id: @student.id, note: { content: "This is a test note", student_id: @student.id } }
        expect(response).to redirect_to(student_path(@student))
        expect(flash[:notice]).to eq("Note was successfully created.")
        puts "POST #create test (existing student): End"
      end
    end

    context "when attempting to create a note for a non-existent student" do
      it "displays an error message and does not create the note" do
        puts "POST #create test (non-existent student): Start"
        post :create, params: { student_id: 999, note: { content: "Test note" } }
        expect(response).to have_http_status(:not_found)
        expect(flash[:alert]).to eq("Student not found")
        expect(response).not_to redirect_to(student_path(@student))
        puts "POST #create test (non-existent student): End"
      end
    end

    context "when attempting to create a note with missing content" do
      it "displays an error message and does not create the note" do
        puts "POST #create test (missing content): Start"
        post :create, params: { student_id: @student.id, note: { content: "" } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)  # Update this line
        expect(flash[:alert]).to eq("Note content cannot be blank")
        puts "POST #create test (missing content): End"
      end
    end
  end
end
