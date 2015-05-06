@javascript
Feature: Display the completeness of a product
  In order to see the completeness of a product in the catalog
  As a product manager
  I need to be able to display the completeness of a product

  Background:
    Given a "footwear" catalog configuration
    And I add the "french" locale to the "tablet" channel
    And I add the "french" locale to the "mobile" channel
    And the following products:
      | sku      | family   | manufacturer | weather_conditions | color | name-en_US | name-fr_FR  | price          | rating | size | lace_color  |
      | sneakers | sneakers | Converse     | hot                | blue  | Sneakers   | Espadrilles | 69 EUR, 99 USD | 4      | 43   | laces_white |
      | sandals  | sandals  |              |                    | white |            | Sandales    |                |        |      |             |
    And the following product values:
      | product  | attribute   | value                 | locale | scope  |
      | sneakers | description | Great sneakers        | en_US  | mobile |
      | sneakers | description | Really great sneakers | en_US  | tablet |
      | sneakers | description | Grandes espadrilles   | fr_FR  | mobile |
      | sandals  | description | Super sandales        | fr_FR  | tablet |
      | sandals  | description | Super sandales        | fr_FR  | mobile |
    And I am logged in as "Julia"
    And I launched the completeness calculator

  Scenario: Successfully display the completeness of the products
    Given I am on the "sneakers" product page
    When I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state   | missing_values        | ratio |
      | mobile  | en_US  | success |                       | 100%  |
      | mobile  | fr_FR  | success |                       | 100%  |
      | tablet  | en_US  | warning | side_view             | 89%   |
      | tablet  | fr_FR  | warning | description side_view | 78%   |
    # Fix fake product update and remove the next two steps
    And I click on the Akeneo logo
    And I confirm the navigation
    When I am on the "sandals" product page
    And I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state   | missing_values                               | ratio |
      | mobile  | en_US  | warning | name price size                              | 40%   |
      | mobile  | fr_FR  | warning | price size                                   | 60%   |
      | tablet  | en_US  | warning | name description price rating side_view size | 25%   |
      | tablet  | fr_FR  | warning | price rating side_view size                  | 50%   |

  Scenario: Successfully display the completeness of the products in the grid
    Given I am on the products page
    And I switch the locale to "English (United States)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 40%   |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 89%   |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 25%   |
    And I switch the locale to "French (France)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 60%   |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 78%   |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 50%   |

  Scenario: Successfully update the completeness at product save
    Given I am on the "sneakers" product page
    When I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state   | missing_values        | ratio |
      | mobile  | en_US  | success |                       | 100%  |
      | mobile  | fr_FR  | success |                       | 100%  |
      | tablet  | en_US  | warning | side_view             | 89%   |
      | tablet  | fr_FR  | warning | description side_view | 78%   |
    When I visit the "Attributes" tab
    And I visit the "Media" group
    And I attach file "SNKRS-1C-s.png" to "side_view"
    And I save the product
    Then I should be on the product "sneakers" edit page
    When I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state   | missing_values  | ratio |
      | mobile  | en_US  | success |                 | 100%  |
      | mobile  | fr_FR  | success |                 | 100%  |
      | tablet  | en_US  | success |                 | 100%  |
      | tablet  | fr_FR  | warning | description     | 89%   |

  Scenario: Successfully display the completeness of the product in the grid after product save (PIM-2916)
    Given I am on the "sneakers" product page
    And I visit the "Attributes" tab
    And I visit the "Media" group
    And I attach file "SNKRS-1C-s.png" to "side_view"
    And I save the product
    And I am on the products page
    And I switch the locale to "English (United States)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    And I switch the locale to "French (France)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 89%   |

  Scenario: Update completeness when family requirements change
    Given I am on the "sneakers" family page
    And I visit the "Attributes" tab
    And I switch the attribute "Rating" requirement in channel "Mobile"
    And I save the family
    And I am on the "sneakers" product page
    When I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state   | missing_values        | ratio |
      | mobile  | en_US  | success |                       | 100%  |
      | mobile  | fr_FR  | success |                       | 100%  |
      | tablet  | en_US  | warning | side_view             | 89%   |
      | tablet  | fr_FR  | warning | description side_view | 78%   |
    # Fix fake product update and remove the next two steps
    And I click on the Akeneo logo
    And I confirm the navigation
    When I am on the "sandals" product page
    And I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state   | missing_values                               | ratio |
      | mobile  | en_US  | warning | name price size                              | 40%   |
      | mobile  | fr_FR  | warning | price size                                   | 60%   |
      | tablet  | en_US  | warning | name description price rating side_view size | 25%   |
      | tablet  | fr_FR  | warning | price rating side_view size                  | 50%   |

  Scenario: Remove completeness from grid when family requirements changed
    Given I am on the "sneakers" family page
    And I visit the "Attributes" tab
    And I switch the attribute "Rating" requirement in channel "Mobile"
    And I save the family
    And I am on the products page
    And I switch the locale to "English (United States)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | -     |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 40%   |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | -     |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 25%   |
    And I switch the locale to "French (France)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | -     |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 60%   |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | -     |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 50%   |

  Scenario: Remove completeness when locales of a channel are deleted
    Given I am on the "tablet" channel page
    And I change the "Locales" to "French (France)"
    And I press the "Save" button
    And I am on the "sneakers" product page
    When I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state    | missing_values        | ratio |
      | mobile  | en_US  | success  |                       | 100%  |
      | mobile  | fr_FR  | success  |                       | 100%  |
      | tablet  | en_US  | disabled | none                  | none  |
      | tablet  | fr_FR  | warning  | description side_view | 78%   |
    # Fix fake product update and remove the next two steps
    And I click on the Akeneo logo
    And I confirm the navigation
    When I am on the "sandals" product page
    And I open the "Completeness" panel
    Then I should see the completeness summary
    And I should see the completeness:
      | channel | locale | state    | missing_values   | ratio |
      | mobile  | en_US  | warning  | 3 missing_values | 40%   |
      | mobile  | fr_FR  | warning  | 2 missing_values | 60%   |
      | tablet  | en_US  | disabled | none             | none  |
      | tablet  | fr_FR  | warning  | 4 missing_values | 50%   |

  Scenario: Remove completeness from grid when locales of a channel are deleted
    Given I am on the "tablet" channel page
    And I change the "Locales" to "French (France)"
    And I press the "Save" button
    And I am on the products page
    And I switch the locale to "English (United States)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 40%   |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | -     |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | -     |
    And I switch the locale to "French (France)"
    And I filter by "Channel" with value "Mobile"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 100%  |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 60%   |
    And I filter by "Channel" with value "Tablet"
    Then the row "sneakers" should contain:
     | column   | value |
     | complete | 78%   |
    Then the row "sandals" should contain:
     | column   | value |
     | complete | 50%   |
