@download
Feature: Download a file

  Scenario: Download a file (uploaded in singlepart)
    Given I upload a tiny file to /cucumber_container/cucumber_object/lorem.txt
    When I download a file from /cucumber_container/cucumber_object/lorem.txt
    Then I can verify the success of the download
    Then I can verify the size
    Then I remove the object(s) for the next test

    Scenario: Download a file (uploaded in multipart)
      Given I upload a large file to /cucumber_container/cucumber_object/lorem.txt
      When I download a file from /cucumber_container/cucumber_object/lorem.txt
      Then I can verify the success of the download
      Then I can verify the size
      Then I remove the object(s) for the next test
