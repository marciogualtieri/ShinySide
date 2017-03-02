library(shiny)
library(shinyjs)
library(wordcloud)
library(qdap)
library(tm)
library(RWeka)
library(stringr)

options(mc.cores=1)
options(shiny.maxRequestSize=30*1024^2) 

DATA <- NULL
KEYWORDS <- NULL
RESULT <- NULL

PAGE_SIZE <- 100

DATA_PAGE <- NULL
KEYWORDS_PAGE <- NULL
RESULT_PAGE <- NULL

MAX_WORDS <- 1000

EXCLUSION_SIZE <- 100
FEATURES_SIZE <- 100