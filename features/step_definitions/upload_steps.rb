Given('I am on the upload page') do
    visit upload_index_path()
    expect(page).to have_content 'Upload Instructions'
end

When('I upload a zip file') do
    attach_file('file', './app/resources/ProfRitchey_Template.zip')
end

When('I input form information') do
    fill_in('course_temp', with: "CSCE 606")
    fill_in('section_temp', with: "000")
    fill_in('semester_temp', with: "Fall 2022")
end

When('I click save') do
    click_button('Save')
end

Then('I should see the upload was successful') do
    expect(page).to have_content 'Upload successful!'
end

When('I upload a zip file with .display files') do
    attach_file('file', './app/resources/431_image_roster_with_chrome_files.zip')
  end
  
When('I input 431 form information') do
    fill_in('course_temp', with: "CSCE 431")
    fill_in('section_temp', with: "550")
    fill_in('semester_temp', with: "Spring 2023")
  end