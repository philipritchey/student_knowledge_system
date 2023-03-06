class Course < ApplicationRecord
    def self.search_course(search, teacher)
        if search != ""
          search_type = Course.where(course_name: search, teacher: teacher).all
          self.where(id: search_type)
        else
          @courses_db_result = Course.where(teacher: teacher)
        end
    end

    def self.search_semester(search, teacher)
      if search != ""
        search_type = Course.where(semester: search, teacher: teacher).all
        self.where(id: search_type)
      else
        @courses_db_result = Course.where(teacher: teacher)
      end
  end

  def self.search_student(search, teacher)
    if search != ""
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
      self.where(id: search_type)
      else
        @courses_db_result = Course.where(teacher: teacher)
    end
end
end