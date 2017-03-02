data <- data.frame(number = 1:10, letter = LETTERS[1:10])

test_that("Create Page Correctly", {
  test_page <- page(data, 3)
  expect_that(test_page$page_start(), equals(1))
  expect_that(test_page$page_size(), equals(3)) 
  expect_that(test_page$page_end(), equals(3))  
})

test_that("Create Page Overflow Correctly", {
  test_page <- page(data, 11)
  expect_that(test_page$page_start(), equals(1))
  expect_that(test_page$page_size(), equals(11)) 
  expect_that(test_page$page_end(), equals(10))  
})

test_that("Switch to Next Page Correctly", {
  test_page <- page(data, 3)
  test_page$next_page()
  expect_that(test_page$page_start(), equals(4))
  expect_that(test_page$page_end(), equals(6))  
})

test_that("Switch to Next Page with Overflow Correctly", {
  test_page <- page(data, 11)
  test_page$next_page()
  expect_that(test_page$page_start(), equals(1))
  expect_that(test_page$page_end(), equals(10))  
})

test_that("Switch to Previous Page Correctly", {
  test_page <- page(data, 3)
  test_page$next_page()
  expect_that(test_page$page_start(), equals(4))
  expect_that(test_page$page_end(), equals(6))
  test_page$previous_page()
  expect_that(test_page$page_start(), equals(1))
  expect_that(test_page$page_end(), equals(3))  
})

test_that("Switch to Previous Page with Overflow Correctly", {
  test_page <- page(data, 6)
  test_page$next_page()
  test_page$next_page()
  expect_that(test_page$page_start(), equals(7))
  expect_that(test_page$page_end(), equals(10)) 
  test_page$previous_page()
  expect_that(test_page$page_start(), equals(1))
  expect_that(test_page$page_end(), equals(6))  
})

test_that("Page Labeled Correctly", {
  test_page <- page(data, 3)
  test_page$next_page()
  expect_that(test_page$label(), equals("4:6"))  
})

test_that("Get Data for Page Correctly", {
  test_page <- page(data, 3)
  expect_that(page_data(data, test_page), equals(data[1:3, ]))  
})