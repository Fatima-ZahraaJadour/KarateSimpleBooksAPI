@tag1
Feature: Simple Books API
  This API allows you to reserve a book.
  The API is available at https://simple-books-api.glitch.me

  Background:
    * url baseUrl

  Scenario: verify the creation of token after an authentication and save it
    * def jsonBody = read('classpath:data/user.json')
    Given path 'api-clients'
    And request jsonBody
    When method post
    Then status 201
    And match $ == {"accessToken":"#string"}
    * def token = $.accessToken
    * def result = call write {'token': #(token)}

  Scenario Outline: verify that 'type' filter works correctly on the list of books endpoint
    Given path 'books'
    And param type = '<type>'
    When method get
    Then status 200
    And match each response[*].type == '<type>'
    Examples:
      | type        |
      | fiction     |
      | non-fiction |

  Scenario: verify that 'type' filter works correctly on the list of books response
    Given path 'books'
    When method get
    Then status 200
    And def fictionBooks = response.filter(o => o.type == 'fiction')
    And print fictionBooks

    Scenario: get book id and write it in files
      * def getFeature = call read('getAllBooks.feature')
      * def books = getFeature.response
      * def id = get[0] books[?(@.available==true)].id
      * def result = call write {'id': 5}
      # i did this in a separate scenario cuz in the same scenario reading the value gives 0

  Scenario: verify the successful creation of an order with an available book

    #generate the json file
    * def jsonBody = read('../data/order.json')
    Given path 'orders'
    And header Authorization = 'Bearer '+ token
    And set jsonBody.bookId = 4
    And request jsonBody
    When method post
    Then status 201
    And print response
    * def orderId = call write {'orderId': #(response.orderId) }

  Scenario: verify the unsuccessful creation of order when the book is out of stock using a variable
    * def getFeature = call read('getAllBooks.feature')
    Given path 'orders'
    And header Authorization = 'Bearer '+ token
    And def books = getFeature.response
    * print books
    And def id = get[0] books[?(@.available==false)].id
    And request
      """
      {
      "bookId": '#(id)',
      "customerName": "John"
      }
      """
    When method post
    Then status 404

  Scenario: get orders
    Given path 'orders'
    And header Authorization = 'Bearer '+ token
    When method get
    Then status 200

  Scenario: update order

    Given path 'orders', orderId
    And header Authorization = 'Bearer '+ token
    And request '{"customerName": "had"}'
    When method PATCH
    Then status 204

  Scenario: get order
    Given path 'orders', orderId
    And header Authorization = 'Bearer '+ token
    When method get
    Then status 200
