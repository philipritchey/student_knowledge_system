# frozen_string_literal: true
When('I click on {string}') do |link_text|
  click_link(link_text)
end

When('I select {string} from {string}') do |option, field|
  select option, from: field
end
  
Given('I select the correct answer') do
  correct_student_id = find('input[name="correct_student_id"]', visible: false).value
  choice_label = "choice-#{correct_student_id}"
  choose('answer', option: correct_student_id)
  @correct_student = Student.find_by(id: correct_student_id)
end

Given('I select an incorrect answer') do
  correct_student_id = find('input[name="correct_student_id"]', visible: false).value
  incorrect_choice = all('input[type="radio"]').reject do |input|
    input.value == find('input[name="correct_student_id"]', visible: false).value
  end.first
  incorrect_choice.choose
  @correct_student = Student.find_by(id: correct_student_id)
  @incorrect_student = Student.find_by(id: incorrect_choice)
end

When("I don't select any answer") do
  # Do nothing
end

When('I submit my answer') do
  click_button 'Submit'
end

Then('I should see that my answer is correct') do
  expect(page).to have_content('Correct Answer!')
end

Then('I should see that my answer is incorrect') do
  expect(page).to have_content('Incorrect')
end


Then("the student's practice interval should be doubled") do
  old_interval = @correct_student.curr_practice_interval.to_i
  new_interval = old_interval * 2
  @correct_student.reload
  expect(@correct_student.curr_practice_interval.to_i).to eq(new_interval)
end

Then("the student's practice interval should be halved if it was greater than 15") do
  old_interval = @correct_student.curr_practice_interval.to_i
  @correct_student.reload
  if @correct_student.curr_practice_interval.to_i > 15
    expect(@correct_student.curr_practice_interval.to_i).to eq(old_interval / 2)
  else
    expect(@correct_student.curr_practice_interval.to_i).to eq(old_interval)
  end
end

Then("the student's last practice time should be updated") do
  @correct_student.reload
  expect(@correct_student.last_practice_at).to be_within(1.minute).of(Time.now)
end
