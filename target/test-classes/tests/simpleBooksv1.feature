@tag2
Feature: Simple Books API
  This API allows you to reserve a book.
  The API is available at https://simple-books-api.glitch.me

  Background:
    * url 'https://simple-books-api.glitch.me'

  Scenario: verify the creation of token after an authentication
    * def generateEmail =
"""
function() {
     var DataStorage = Java.type('helpers.DataStorage');
     var dS = new DataStorage();
     return dS.generate();
}
"""
    * def email = call generateEmail

    Given path 'api-clients'
    And request
      """
      {
        "clientName": "fatima",
        "clientEmail": "##(email)"
       }
      """
    When method post
    Then status 201
    And match $ == {"accessToken":"#string"}
    * def token = $.accessToken
    * print token
    * def doStorage =
"""
function(args) {
     var DataStorage = Java.type('helpers.DataStorage');
     var dS = new DataStorage();
     return dS.write(args);
}
"""
    * def result = call doStorage {'key': '##(token)'}

  Scenario: verify that 'type' filter works correctly  on the list of books endpoint
    Given path 'books'
    And param type = 'fiction'
    When method get
    Then status 200
    #outline : fiction / non fiction (loop)

  Scenario: verify the successful creation of an order with an available book
    * def doStorage =
"""
function(args) {
    var DataStorage = Java.type('helpers.DataStorage');
    var dS = new DataStorage();
    return dS.read(args);
}"""
    Given path 'orders'
    * def result = call doStorage 'key'
    And header Authorization = 'Bearer '+ result
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

  Scenario: verify the unsuccessful creation of order when the book is out of stock
    * def doStorage =
"""
function(args) {
    var DataStorage = Java.type('helpers.DataStorage');
    var dS = new DataStorage();
    return dS.read(args);
}"""
    Given path 'orders'
    * def result = call doStorage 'key'

    And header Authorization = 'Bearer '+ result
    And request
      """
      {
      "bookId": 2,
      "customerName": "John"
      }
      """
    When method post
    Then status 404

