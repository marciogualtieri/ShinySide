library('testthat')

source('controllers/tableController.R')
source('utils.R')

test_dir('./tests', reporter = 'Summary')