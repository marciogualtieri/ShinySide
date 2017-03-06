data <- data.frame(id = 1:3,
                   name = c("Moe Howard", "Larry Fine", "Curly Howard"),
                   name_array = c("Jerry Seinfeld,George Constanza,Elaine Benes,Cosmo Kramer",
                                  "Larry David,Cheryl David,Susie Greene,Jeff Greene",
                                  "Chandler Bing,Joey Tribiani,Ross Geller,Monica Geller,Phoebe Buffay,Rachel Green"))

data$name <- as.character(data$name)
data$name_array <- as.character(data$name_array)
data$name_array <- sapply(data$name_array, strsplit, split=",")

test_that("Column is list of characters", {
  expect_that(is_character_list(data, "id"), equals(FALSE))
  expect_that(is_character_list(data, "name"), equals(FALSE)) 
  expect_that(is_character_list(data, "name_array"), equals(TRUE))  
})

test_that("Column is text", {
  expect_that(is_text_column(data, "id"), equals(FALSE))
  expect_that(is_text_column(data, "name"), equals(TRUE)) 
  expect_that(is_text_column(data, "name_array"), equals(TRUE))  
})

test_that("Create feature", {
  expected_data <- data
  expected_data$moe_howard <- c(TRUE, FALSE, FALSE)
  expect_that(add_feature(data, c("name", "name_array"), "moe howard"), equals(expected_data))
})

test_that("Create features for Multiple Columns", {
  expected_data <- data
  expected_data$moe_howard <- c(TRUE, FALSE, FALSE)
  expected_data$phoebe_buffay <- c(FALSE, FALSE, TRUE)
  expect_that(add_features(data, c("name", "name_array"), c("moe howard", "phoebe buffay")), equals(expected_data))
})

test_that("Create features for Single Column", {
  expected_data <- data
  expected_data$moe_howard <- c(FALSE, FALSE, FALSE)
  expected_data$phoebe_buffay <- c(FALSE, FALSE, TRUE)
  expect_that(add_features(data, c("name_array"), c("moe howard", "phoebe buffay")), equals(expected_data))
})