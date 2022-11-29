Feature: get books using Simple Books API
  The API is available at https://simple-books-api.glitch.me

  Scenario: verify that 'type' filter works correctly  on the list of books endpoint
    Given path 'books'
    When method get
    Then status 200
