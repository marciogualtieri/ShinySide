list_to_string_columns <- function(data) {
  columns <- names(data)
  list_columns <- columns[sapply(columns, function(x) is.list(data[[x]]))]
  for(name in list_columns)
    data[[name]] <- sapply(data[[name]], toString)
  return(data)
}

is_character_list <- function(data, column) {
  column_data <- data[[column]]
  if(is.list(column_data)) is.character(column_data[[1]][[1]])
  else FALSE
}

is_text_column <- function(data, column) {
  is.character(data[[column]]) | is_character_list(data, column)
}

clean_corpus <- function(corpus, words_to_remove){
  corpus <- tm_map(corpus, content_transformer(bracketX))
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"), words_to_remove))
  return(corpus)
}

tokenizer <- function(x) 
  NGramTokenizer(x, Weka_control(min = 1, max = 5))

create_keywords_data_frame <- function(document_term_matrix) {
  frequency <- colSums(document_term_matrix)
  keywords <- data.frame(keyword = names(frequency), frequency = frequency)
  rownames(keywords) <- 1:length(frequency)
  return(keywords)
}

create_corpus <- function(data) {
  if(is.data.frame(data)) {
    data <- list_to_string_columns(data)
    data_corpus <- VCorpus(DataframeSource(data))
  }
  else {
    data <- data[!is.na(data) & !is.null(data)]
    data_corpus <- VCorpus(VectorSource(data))
  }
  data_corpus
}

extract_keywords <- function(data, words_to_remove) {
  data_corpus <- create_corpus(data)
  data_corpus <- clean_corpus(data_corpus, words_to_remove)
  document_term_matrix <- DocumentTermMatrix(data_corpus, control = list(tokenize = tokenizer))
  keywords <- create_keywords_data_frame(as.matrix(document_term_matrix))
  keywords <- keywords[order(keywords$frequency, decreasing = TRUE), ]
  return(keywords)
}

keyword_exists <- function(text, keyword) {
  text <- tolower(text)
  grepl(keyword, text)
}

normalize_keyword <- function(keyword)
  tolower(str_replace_all(keyword, "[^\\w]", "_"))

add_feature <- function(data, columns, keyword) {
  if(length(columns) > 1) text <-  do.call(paste, data[, columns])
  else text <- sapply(data[, columns], paste, collapse = ", ")
  normalized_keyword <- normalize_keyword(keyword)
  data[[normalized_keyword]] <- sapply(text, keyword_exists, keyword = keyword)
  return(data)
}

add_features <- function(data, columns, keywords) {
  for(keyword in keywords)
    data <- add_feature(data, columns, keyword)
  return(data)
}
