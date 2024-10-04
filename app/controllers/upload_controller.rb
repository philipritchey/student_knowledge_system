# frozen_string_literal: true

class UploadController < ApplicationController
  before_action :require_user!

  def index; end

  def parse
    require 'zip'
    require 'csv'
    require 'securerandom'

    csv, images = process_zip(params[:file])

    if csv_valid?(csv, images)
      @course = create_course
      StudentCourse.where(course_id: @course.id).destroy_all

      csv.zip(images).each do |row, image|
        process_student(row, image)
      end

      redirect_to courses_url, notice: 'Upload successful!'
    else
      redirect_to upload_index_path, notice: 'Number of images does not match number of students'
    end
  end

  private

  def process_zip(file)
    images = []
    csv = []
    Zip::File.open(file) do |zip_file|
      zip_file.each do |entry|
        if entry.name.include? '.htm'
          images = extract_images(zip_file, entry)
        elsif entry.name.include? '.csv'
          csv = parse_csv(entry)
        end
      end
    end
    [csv, images]
  end

  def extract_images(zip_file, entry)
    images = []
    html_doc = Nokogiri::HTML(entry.get_input_stream.read)
    images_paths = html_doc.search('img/@src').map(&:text).map(&:strip)

    images_paths.each do |path|
      if path.include? '.display'
        full_path = path.split('/', 2)
        images.push(zip_file.find_entry(full_path[1]))
      else
        images.push(zip_file.find_entry(path))
      end
    end
    images
  end

  def parse_csv(entry)
    csv = CSV.parse(entry.get_input_stream.read, headers: true)
    csv.delete_if { |row| row.to_hash.values.all?(&:nil?) }
    csv
  end

  def csv_valid?(csv, images)
    !csv.empty? && (csv.length == images.length)
  end

  def create_course
    Course.find_or_create_by(course_name: params[:course_temp], teacher: current_user.email,
                             section: params[:section_temp], semester: params[:semester_temp])
  end

  def process_student(row, image)
    return unless valid_student_data?(row)

    student = find_or_create_student(row)
    create_student_course(student, row)

    uuid = "#{SecureRandom.uuid}-#{row['UIN'].strip}"
    attach_image(student, image, uuid)
  end

  def valid_student_data?(row)
    row['FIRST NAME'] && row['LAST NAME'] && row['UIN'] && row['EMAIL'] && row['CLASSIFICATION'] && row['MAJOR']
  end

  def find_or_create_student(row)
    student = Student.where(uin: row['UIN'].strip, teacher: current_user.email).first
    if student
      student.update(
        firstname: row['FIRST NAME'].strip,
        lastname: row['LAST NAME'].strip,
        uin: row['UIN'].strip,
        email: row['EMAIL'].strip,
        classification: row['CLASSIFICATION'].strip,
        major: row['MAJOR'].strip,
        teacher: current_user.email
      )
    else
      student = Student.new(
        firstname: row['FIRST NAME'].strip,
        lastname: row['LAST NAME'].strip,
        uin: row['UIN'].strip,
        email: row['EMAIL'].strip,
        classification: row['CLASSIFICATION'].strip,
        major: row['MAJOR'].strip,
        teacher: current_user.email,
        last_practice_at: Time.now - 121.minutes,
        curr_practice_interval: 120
      )
      student.save
    end
    student
  end

  def create_student_course(student, row)
    StudentCourse.find_or_create_by(course_id: @course.id, student_id: student.id,
                                    final_grade: row['FINALGRADE'])
  end

  def attach_image(student, image, uuid)
    Tempfile.open([uuid]) do |tmp|
      image.extract(tmp.path) { true }
      student.image.attach(io: File.open(tmp), filename: uuid)
    end
  end
end
