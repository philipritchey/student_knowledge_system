class Course < ApplicationRecord

  validates :course_name, format: { with: /\A[A-Z]{4} \d{3}\z/, message: "Invalid course code format. It should be in the format 'CSCE 123' where 123 is a three-digit course number." }
  validates :section, format: { with: /\A\d{3}\z/, message: "Invalid section format. It should be in the format '123'." }
  validates :semester, format: { with: /\A(Fall|Spring) 20\d{2}\z/, message: "Invalid semester format. It should be in the format 'Fall 20XX' or 'Spring 20XX'." }

  # Your existing methods here
  def self.search_course(search, teacher)
      if search
        search_type = Course.where(course_name: search, teacher: teacher).all
        if search_type
          self.where(id: search_type)
        elsif (search_type.length == 0)
          @courses_db_result = Course.where(teacher: teacher)
        else
          @courses_db_result = Course.where(id: 0)
        end
      else
        @courses_db_result = Course.where(teacher: teacher)
      end
  end

  def self.search_semester(search, teacher)
    if search
      search_type = Course.where(semester: search, teacher: teacher).all
      if search_type
        self.where(id: search_type)
      elsif (search_type.length == 0)
        @courses_db_result = Course.where(teacher: teacher)
      else
        @courses_db_result = Course.where(id: 0)
      end
    else
      @courses_db_result = Course.where(teacher: teacher)
    end
end

def self.search_student(search, teacher)
  if search
    if search.include?(" ")
      student = Student.where(firstname: search.split(" ")[0], lastname: search.split(" ")[1]).all
    else
      student = Student.where(firstname: search).all + Student.where(lastname: search).all
    end
    enrollment = []
    for stud in student do
      puts stud.firstname
      enrollment = enrollment + StudentCourse.where(student_id: stud.id).all
      puts enrollment[0].id
    end
    search_type = []
    for enroll in enrollment do 
      search_type = search_type + Course.where(id: enroll.course_id, teacher: teacher).all
      puts search_type[0]
    end
      if search_type
        self.where(id: search_type)
      elsif (search_type.length == 0)
        @courses_db_result = Course.where(teacher: teacher)
      else
        @courses_db_result = Course.where(id: 0)
      end
    else
      @courses_db_result = Course.where(teacher: teacher)
  end
end

end