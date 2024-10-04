# frozen_string_literal: true

class CoursesController < ApplicationController
  # before_action :authenticate_user!
  # before_action :authenticate_by_session
  before_action :set_course, only: %i[show edit update destroy]
  before_action :require_user!

  # GET /courses or /courses.json
  def index
    @courses_db_result = determine_search
    @courses_comb_hash = build_courses_comb_hash(@courses_db_result)
    @courses = @courses_comb_hash.values
  end

  # GET /courses/1 or /courses/1.json
  def show
    initialize_show
    apply_filters if filters_selected?
    @student_records = build_student_records(@student_ids, @target_course_id)
    sort_student_records if params[:sortOrder].present?

    Rails.logger.info "Collected info for filter #{@student_records.inspect}"
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit; end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    respond_to_save(@course.save, 'Course was successfully created.', :new)
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to_save(@course.update(course_params), 'Course was successfully updated.', :edit)
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    destroy_course
  end

  private

  def determine_search
    if request.fullpath.include?('search_course')
      Course.search_course(params[:search_course], current_user.email)
    elsif request.fullpath.include?('search_student')
      Course.search_student(params[:search_student], current_user.email)
    else
      Course.search_semester(params[:search_semester], current_user.email)
    end
  end

  def build_courses_comb_hash(courses_db_result)
    courses_comb_hash = {}
    courses_db_result.each do |c|
      if !courses_comb_hash[c.course_name.strip]
        course_all_sections = CourseEntries.new
        course_all_sections.initializeUsingCourseModel(c)
        courses_comb_hash[c.course_name.strip] = course_all_sections
      else
        course = courses_comb_hash[c.course_name.strip]
        course.sections.add(c.section)
        course.semesters.add(c.semester)
        course.records.add(c)
      end
    end
    courses_comb_hash
  end

  def initialize_show
    @all_course_ids = Course.where(course_name: Course.find(params[:id]).course_name, teacher: current_user.email).pluck(:id)
    @student_ids = StudentCourse.where(course_id: @all_course_ids).pluck(:student_id)
    @student_records = Student.where(id: @student_ids)
    @tags = fetch_tags(@student_records)
    @semesters, @sections = fetch_semesters_and_sections
  end

  def fetch_tags(student_records)
    tags = Set[]
    student_records&.each do |student|
      StudentsTag.where(student_id: student.id, teacher: current_user.email).each do |tag_assoc|
        tag = Tag.find_by(id: tag_assoc.tag_id)
        tags.add(tag.tag_name) if tag
      end
    end
    tags
  end

  def fetch_semesters_and_sections
    semesters, sections = Set[], Set[]
    Course.where(course_name: @course.course_name).each do |record|
      semesters.add(record.semester)
      sections.add(record.section)
    end
    [semesters, sections]
  end

  def filters_selected?
    params[:selected_semester].present? || params[:selected_section].present? || params[:selected_tag].present?
  end

  def apply_filters
    @selected_tag, @selected_semester, @selected_section = params[:selected_tag], params[:selected_semester], params[:selected_section]
    @target_course_id = filter_courses_by_selection
    filter_students_by_tag if @selected_tag.present?
  end

  def filter_courses_by_selection
    if @selected_section.blank? && @selected_semester.blank?
      Course.where(id: @all_course_ids)
    elsif @selected_section.present? && @selected_semester.blank?
      Course.where(id: @all_course_ids, section: @selected_section)
    elsif @selected_section.blank? && @selected_semester.present?
      Course.where(id: @all_course_ids, semester: @selected_semester)
    else
      Course.where(id: @all_course_ids, semester: @selected_semester, section: @selected_section)
    end
  end

  def filter_students_by_tag
    selected_tag_id = Tag.find_by(tag_name: @selected_tag).id
    tag_associations = StudentsTag.where(tag_id: selected_tag_id, teacher: current_user.email)
    @student_records = @student_records.select do |record|
      tag_associations.any? { |assoc| record.id == assoc.student_id }
    end
  end

  def build_student_records(student_ids, target_course_ids)
    student_records_hash = {}
    Student.where(id: student_ids).each do |student|
      student_courses = StudentCourse.where(student_id: student.id, course_id: target_course_ids)
      student_courses.each do |student_course|
        course = Course.find_by(id: student_course.course_id)
        if student_records_hash[student.uin].nil?
          student_entry = StudentEntries.new
          student_entry.initializeUsingStudentModel(student, course)
          student_records_hash[student.uin] = student_entry
        else
          student_entry = student_records_hash[student.uin]
          student_entry.records.append(student)
          student_entry.semester_section.add("#{course.semester} - #{course.section}")
          student_entry.course_semester.add("#{course.course_name} - #{course.semester}")
        end
      end
    end
    student_records_hash.values
  end

  def sort_student_records
    case params[:sortOrder]
    when 'Alphabetical'
      @student_records = @student_records.sort_by { |student| student.records[0].lastname }
    when 'Reverse Alphabetical'
      @student_records = @student_records.sort_by { |student| student.records[0].lastname }.reverse
    end
  end

  def destroy_course
    StudentCourse.where(course_id: params[:id]).destroy_all
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course and its info were successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def respond_to_save(success, success_message, error_action)
    respond_to do |format|
      if success
        format.html { redirect_to course_url(@course), notice: success_message }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render error_action, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_course
    @course = Course.find_by(teacher: current_user.email, id: params[:id])
    return unless @course.nil?

    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Given course not found.' }
      format.json { head :no_content }
    end
  end

  def course_params
    params.require(:course).permit(:course_name, :section, :semester).with_defaults(teacher: current_user.email)
  end
end
