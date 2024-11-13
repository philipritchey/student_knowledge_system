Feature: Student Quiz

Background: database

Given the following users exist:
| email                         | confirmed_at               |
| team_cluck_admin@gmail.com    | 2023-01-19 12:12:07.544080 |

Given the following courses exist:
| course_name | teacher                       | section | semester         |
| CSCE 411    | team_cluck_admin@gmail.com    | 501     | Spring 2023      | 
| CSCE 411    | team_cluck_admin@gmail.com    | 501     | Fall 2022        | 
| CSCE 412    | team_cluck_admin@gmail.com    | 501     | Spring 2023      | 


Given the following students exist:
| firstname | lastname  | uin       | email                 | classification | major | teacher                    | last_practice_at              | curr_practice_interval |
| Zebulun   | Oliphant  | 734826482 | zeb@tamu.edu          | U2             | CPSC  | team_cluck_admin@gmail.com | 2023-01-25 17:11:11.111111    | 120                    |
| Batmo     | Biel      | 274027450 | speedwagon@tamu.edu   | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 17:11:11.111111    | 60                     |
| Ima       | Hogg      | 926409274 | piglet@tamu.edu       | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 240                    |
| Joe       | Mama      | 720401677 | howisjoe@tamu.edu     | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 120                    |
| Sheev     | Palpatine | 983650274 | senate@tamu.edu       | U2             | CPSC  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 119                    |

Scenario: Answering the quiz incorrectly
    Given students are enrolled in their respective courses
    When I sign in as "team_cluck_admin@gmail.com"
    And I click on "Practice now!"
    When I select "CSCE 411" from "courses[]"
    And I select "501" from "sections[]"
    And I select "Spring 2023" from "semesters[]"
    And I click "Start the Quiz"
    When I select an incorrect answer
    And I submit my answer
    Then I should see that my answer is incorrect
    And the student's practice interval should be halved if it was greater than 15
    And the student's last practice time should be updated

Scenario: Answering the quiz correctly
    Given students are enrolled in their respective courses
    When I sign in as "team_cluck_admin@gmail.com"
    And I click on "Practice now!"
    When I select "CSCE 411" from "courses[]"
    And I select "501" from "sections[]"
    And I select "Spring 2023" from "semesters[]"
    And I click "Start the Quiz"
    When I select the correct answer
    And I submit my answer
    Then I should see that my answer is correct
    And the student's practice interval should be doubled
    And the student's last practice time should be updated