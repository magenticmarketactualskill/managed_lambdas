Feature: Create Lambda Specification
  As a developer
  I want to create Lambda specifications
  So that I can manage Lambda deployments

  Scenario: Create a simple Lambda specification
    Given I have a data_shapes service running
    When I create a specification named "hello_world"
    Then the specification should be created successfully
    And the specification should have the name "hello_world"

  Scenario: Create a Lambda specification with custom properties
    Given I have a data_shapes service running
    When I create a specification with the following properties:
      | name        | hello_world_custom |
      | description | A custom Lambda    |
      | language    | ruby               |
    Then the specification should be created successfully
    And the specification should have the description "A custom Lambda"
