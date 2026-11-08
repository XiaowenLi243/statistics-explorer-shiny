
source("helpers.R")

# Test 1: Remove missing and infinite values
result <- finite_values(
  c(10, NA, 20, Inf, 30)
)

stopifnot(
  identical(result, c(10, 20, 30))
)


# Test 2: Identify valid X-Y pairs
x <- c(10, NA, 30, 40)
y <- c(2, 4, Inf, 8)

result <- valid_pairs(x, y)

stopifnot(
  identical(
    result,
    c(TRUE, FALSE, FALSE, TRUE)
  )
)


# Test 3: Reject text data
result <- tryCatch(
  {
    finite_values(c("A", "B"))
    FALSE
  },
  error = function(e) TRUE
)

stopifnot(result)


cat("All 3 tests passed!\n")
