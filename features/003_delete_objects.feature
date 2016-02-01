@delete
Feature: Delete several Swift objects

  Scenario: Delete several Swift objects
    Given I upload a tiny file to /cucumber_container/cucumber_object/lorem_1.txt
    Given I upload a tiny file to /cucumber_container/cucumber_object/lorem_2.txt
    When I remove several existing objects "cucumber_object/lorem_1.txt|cucumber_object/lorem_2.txt" from container /cucumber_container
    Then I can verify the success of the deletion
