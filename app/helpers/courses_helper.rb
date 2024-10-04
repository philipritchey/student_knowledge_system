# frozen_string_literal: true

module CoursesHelper
  def sort_link(column:, label:)
    link_to(label, list_courses_path(column:))
  end
end
