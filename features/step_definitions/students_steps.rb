  When('I go to the students page') do
    visit students_path()
    expect(page).to have_content("New student")
  end

  Then('I select {string} under semester') do |string|
    find("#selected_semester").select(string)
  end

  Then('I submit the form') do
    find("[value='Filter Students List']").click
    expect(page).to have_content("Kunal")
    # expect(students.find_by(firstname: "Kunal")).to be(successful)
  end

  When('I click show this student') do
    first("button", text: "Show this student").click
  end

  When('I fill in student {string} with {string}') do |string, string2|
    fill_in "student[#{string}]", with: string2
  end
  
  When('I select {string} under tag') do |string|
    find("#selected_tag").select(string)
  end