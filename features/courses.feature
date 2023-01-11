Feature: Filter courses according to their defining traits, such as their course number, a recurring student, or a certain semester, 
and sort courses in terms of their relevance.

As a professor,
So I can more quickly recollect previous courses I’ve taught
I want to be able to filter and sort my courses.

Background: database

Given the following courses exist:

| course_name | teacher                       | section | semester         |
| CSCE 411    | team_cluck_admin@gmail.com    | 501     | Spring 2023      | 
| CSCE 411    | team_cluck_admin@gmail.com    | 501     | Fall 2022        | 
| CSCE 412    | team_cluck_admin@gmail.com    | 501     | Spring 2023      | 


Given the following students exist:
| firstname | lastname  | uin       | email                 | classification | major | teacher                    |
| Zebulun   | Oliphant  | 734826482 | zeb@tamu.edu          | U2             | CPSC  | team_cluck_admin@gmail.com |
| Batmo     | Biel      | 274027450 | speedwagon@tamu.edu   | U1             | ENGR  | team_cluck_admin@gmail.com |
| Ima       | Hogg      | 926409274 | piglet@tamu.edu       | U1             | ENGR  | team_cluck_admin@gmail.com |
| Joe       | Mama      | 720401677 | howisjoe@tamu.edu     | U1             | ENGR  | team_cluck_admin@gmail.com |
| Sheev     | Palpatine | 983650274 | senate@tamu.edu       | U2             | CPSC  | team_cluck_admin@gmail.com |


Scenario: All courses viewable
    Given students are enrolled in their respective courses
    When I sign in
    And I go to the courses page
    Then I should see "CSCE 411" offered in "Spring 2023"
    And I should see "CSCE 411" offered in "Fall 2022"
    And I should see "CSCE 412" offered in "Spring 2023"

    
