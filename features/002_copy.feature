@copy
Feature: Copy a Swift object

  Scenario: Copy a Swift object
    Given I upload a tiny file to /cucumber_container/cucumber_object/lorem.txt
    When I copy an existing object to /cucumber_container_copy/cucumber_object/lorem.txt
    Then I can verify the success of the copy
    Then I can verify the size
    Then I remove the object(s) for the next test

    Scenario: Multipart copy for Swift object
      Given I upload a large file to /cucumber_container/cucumber_object/lorem.txt
      When I copy an existing object to /cucumber_container_copy/cucumber_object/lorem.txt
      Then I can verify the success of the copy
      Then I can verify the size
      Then I remove the object(s) for the next test
