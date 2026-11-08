# Statistics Explorer

An interactive data exploration application built with R Shiny.

**[Open the live Shiny app](https://01a1b8c1-f85b-803f-41c6-a813cb44cb65.share.connect.posit.cloud/)**

## Overview

Statistics Explorer is a small learning project for exploring numerical variables in a CSV file. It uses reactive programming to update visualisations and descriptive statistics when users change their selections.

## Features

- Upload a CSV file, or explore the built-in `iris` dataset before uploading.
- Automatically populate variable selectors from numerical columns.
- Switch between a histogram (with adjustable bins) and a scatter plot.
- Display descriptive statistics and counts of missing and finite values.
- Preview the first six rows of the dataset.
- Show helpful validation messages for unreadable, empty or non-numeric CSV data.
- Exclude non-finite values from plots.
- Run basic checks of reusable functions.

## Technologies

- R
- Shiny
- Base R

## Project files

| File | Purpose |
| --- | --- |
| `app.R` | Shiny user interface and server logic |
| `helpers.R` | Reusable functions for finite values and valid X-Y pairs |
| `test_helpers.R` | Basic helper-function tests |
| `manifest.json` | Deployment environment information |

## Run locally

Install R and the Shiny package:

```r
install.packages("shiny")
```

Open RStudio, set the working directory to this repository's folder, and run:

```r
shiny::runApp()
```

No local absolute path is required in `app.R`.

## Run the tests

From the repository folder:

```r
source("test_helpers.R")
```

These tests cover selected helper functions; they do not replace full Shiny interface or deployment testing.

## Limitations

This is a learning and portfolio project, not a production analytics service. Plotting supports numeric columns only. Do not upload confidential or sensitive data unless the hosting environment and data-handling requirements have been checked.

## live App

https://01a1b8c1-f85b-803f-41c6-a813cb44cb65.share.connect.posit.cloud/
