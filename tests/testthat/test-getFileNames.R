test_that("getFileNames() returns the right result", {
    result <- getFileNames()

    expect_equal(length(result), 3)
    expect_gte(length(result[[1]]), 102)
    expect_gte(length(result[[2]]), 149)
    expect_gte(length(result[[3]]), 143)
})
