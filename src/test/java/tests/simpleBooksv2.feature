Feature: Simple Books API
  This API allows you to reserve a book.
  The API is available at https://simple-books-api.glitch.me

  Background:
    * url 'https://simple-books-api.glitch.me'

  Scenario: verify the creation of token after an authentication
    Given path 'api-clients'
    And request
      """
      {
        "clientName": "fatima",
        "clientEmail": "fatiza11@example.com"
       }
      """
    When method post
    Then status 201
    And match $ == {"accessToken":"#string"}
    * def token = response.accessToken


  #Scenario: verify the successful creation of an order with an available book
    Given path 'orders'
    And header Authorization = 'Bearer '+ token
    And request
      """
      {
        "bookId": 1,
        "customerName": "John"
      }
      """
    When method post
    Then status 201
    And print response

  #Scenario: verify the unsuccessful creation of order when the book is out of stock
    Given path 'orders'
    And header Authorization = 'Bearer '+ token
    And request
      """
      {
      "bookId": 2,
      "customerName": "John"
      }
      """
    When method post
    Then status 404


  Scenario: verify that 'type' filter works correctly  on the list of books endpoint
    Given path 'books'
    And param type = 'fiction'
    When method get
    Then status 200