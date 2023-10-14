# class NotesController < ApplicationController
#     before_action :find_student

#     def new
#         @student = Student.find(params[:id])
#         @note = Note.new
#     end

#     def create
#         student_id = params[:student_id]
#         puts "Received student_id: #{student_id}" # Debugging line
#         @student = Student.find_by(id: student_id)
      
#         if @student.nil?
#           flash[:error] = "Student not found"
#           redirect_to root_path # or handle the error in some other way
#         else
#           @note = @student.notes.build(note_params)
#           if @note.save
#             redirect_to @student, notice: 'Note was successfully created.'
#           else
#             render :new
#           end
#         end
#     end
      
      

#     private

#     def note_params
#         params.require(:note).permit(:content)
#     end
# end

# class NotesController < ApplicationController
#     before_action :set_student, only: [:new, :create]
  
#     def new
#       @note = Note.new
#     end
  
#     def create
#       puts "Received student_id: #{params[:note][:student_id]}"
#       @student = Student.find(params[:note][:student_id])
#       puts @student.inspect
#       @note = @student.notes.create(note_params)
      
#       if @student.nil?
#         flash[:alert] = "Student not found"
#         redirect_to root_path
#       else
#         @note = @student.notes.create(note_params)
  
#         if @note.save
#           redirect_to @student, notice: 'Note was successfully created.'
#         else
#           render :new
#         end
#       end

#       # if @note.save
#       #   redirect_to @student, notice: 'Note was successfully created.'
#       # else
#       #   render :new
#       # end
#     end
  
#     private
  
#     def set_student
#       @student = Student.find(params[:student_id])
#     end
  
#     def note_params
#       params.require(:note).permit(:content, :student_id)
#     end
# end
  
class NotesController < ApplicationController
  before_action :set_student, only: [:new, :create]

  def new
    @note = Note.new
  end

  def create
    if @student.nil?
      flash[:alert] = "Student not found"
      render plain: "Student not found", status: :not_found
    else
      @note = @student.notes.build(note_params)
      
      if @note.content.blank?  # Check if content is blank
        flash.now[:alert] = "Note content cannot be blank"
        render :new, status: :unprocessable_entity
      elsif @note.save
        redirect_to @student, notice: 'Note was successfully created.'
      else
        render :new
      end
    end
  end
  

  private

  def set_student
    @student = Student.find_by(id: params[:student_id])
  end

  def note_params
    params.require(:note).permit(:content, :student_id)
  end
end




