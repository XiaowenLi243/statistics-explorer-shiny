
# Return finite numeric values
finite_values <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be numeric.")
  }
  
  x[is.finite(x)]
}


# Identify valid X-Y pairs
valid_pairs <- function(x, y) {
  
  if (!is.numeric(x) || !is.numeric(y)) {
    stop("Both variables must be numeric.")
  }
  
  if (length(x) != length(y)) {
    stop("X and Y must have equal lengths.")
  }
  
  is.finite(x) & is.finite(y)
}
