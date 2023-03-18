Given(/the following users exist/) do |users_table|
    users_table.hashes.each do |user|
        User.create user
    end
end

Given(/the following courses exist/) do |courses_table|
    courses_table.hashes.each do |course|
        Course.create course
    end
end

Given(/the following students exist/) do |students_table|
    students_table.hashes.each do |student|
        Student.create student
    end
end

Given(/students are enrolled in their respective courses/) do 
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: '100')
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '926409274').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '274027450').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '720401677').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '983650274').id, final_grade: "")
end

When(/I sign in/) do

    #idea, try email_spec again, nah i don't want to deal with real emails
    
    # visit root_path
    # user = User.find_by(email: "team_cluck_admin@gmail.com")
    # puts "capybara user: #{user.inspect}"
    # session = Passwordless::Session.new(authenticatable: user)
    # session.save
    # # Set the session token in the test session cookie
    # session_key = Rails.application.config.session_options[:key]
    # session_cookie = Capybara.current_session.driver.request.env["rack.session"]
    # session_cookie[session_key.to_s] = { "passwordless" => { "authenticatable_id" => user.id, "token" => session.token, "current_user" => user} }
    # visit home_path

    ## does not set current_user but runs "visit home_path"
    # user = User.find_by_email('team_cluck_admin@gmail.com')
    # session = {
    #   passwordless: {
    #     user_id: user.id
    #   }
    # }
    # page.driver.browser.set_cookie("_passwordless_session=#{Rack::Utils.escape(JSON.generate(session))}")
    # visit home_path

    ## No rails route of '/passwordless/authentications'
    # visit '/'
    # page.driver.post('/passwordless/authentications', { auth: { email: 'team_cluck_admin@gmail.com' }})
    # visit home_path

    ## authenticate_by_session is not a valid method. trying to add it to capybara throws an error
    # user = User.find_by_email('team_cluck_admin@gmail.com')
    # authenticate_by_session(user)
    # visit home_path
    # expect(page).to have_content("Your account has been created. Please sign in.")



    email = "new@gmail.com"

    visit root_path
    click_link("Create Account")
    fill_in("user_email", with: email)
    click_button("Create account")
    expect(page).to have_content("Your account has been created. Please sign in.")
    click_link("Create Account")
    fill_in("user_email", with: email)
    click_button("Create account")
    expect(page).to have_content("Your account already exists. Please sign in.")
    click_link("Sign in")
    fill_in("passwordless_email", with: email)
    click_button("Send magic link") # email does not get sent or given to action mailer deliveries array
    expect(page).to have_content("If we have found you in our system, you have been sent a link to log in!")
    visit home_path

    ## og thing
    # visit new_user_session_path()
    # fill_in("Email", with: "team_cluck_admin@gmail.com")
    # fill_in("Password", with: "team_cluck_12345!")
    # click_button("Log in")
end 

When(/I go to the courses page/) do
    visit courses_path()
end

Then('I should see {string} offered in {string}') do |course_name, semester|
    hasCourse = false
    all('tr').each do |tr|
        next unless tr.has_content?(course_name)
        next unless tr.has_content?(semester)
        hasCourse = true
    end
    expect(hasCourse).to eq(true)
end

When('I fill in {string} with {string}') do |search, query|
    fill_in(search, with: query)
end

When('I click {string}') do |button|
    click_button(button)
end

Then('I should not see {string} offered in {string}') do |course_name, semester|
    hasCourse = false
    all('tr').each do |tr|
        next unless tr.has_content?(course_name)
        next unless tr.has_content?(semester)
        hasCourse = true
    end
    expect(hasCourse).to eq(false)
end
