@upload
Feature: Upload a file

  Scenario: Upload a tiny file (1 MB) (singlepart)
    When I upload a tiny file to /cucumber_container/cucumber_object/lorem.txt
    Then I can verify the success of the upload
    Then I can verify the size
    Then I remove the object(s) for the next test

  Scenario: Upload a large file (200 MB) (multipart)
    When I upload a large file to /cucumber_container/cucumber_object/lorem.txt
    Then I can verify the success of the upload
    Then I can verify the size
    Then I remove the object(s) for the next test
