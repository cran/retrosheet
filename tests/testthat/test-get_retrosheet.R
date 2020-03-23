test_that("Caching works", {

    # With caching
    schedule_1 <- get_retrosheet("schedule", 1995, cache = "testdata")
    schedule_1a <- get_retrosheet("schedule", 1995, cache = "testdata/") # Test with trailing slash
    roster_1 <- get_retrosheet("roster", 1995, cache = "testdata")
    game_1 <- get_retrosheet("game", 2012, cache = "testdata")
    play_1 <- get_retrosheet("play", 2012, "SFN", cache = "testdata")

    # Without caching
    schedule_2 <- get_retrosheet("schedule", 1995)
    roster_2 <- get_retrosheet("roster", 1995)
    game_2 <- get_retrosheet("game", 2012)
    play_2 <- get_retrosheet("play", 2012, "SFN")

    expect_equal(schedule_1, schedule_2)
    expect_equal(schedule_1, schedule_1a)
    expect_equal(roster_1, roster_2)
    expect_equal(game_1, game_2)
    expect_equal(play_1, play_2)

    # Re-using cached data should give a message about using a local cache
    expect_message(get_retrosheet("schedule", 1995, cache = "testdata"), "Using local cache: testdata/schedule/1995SKED.ZIP")

})

test_that("Schedule downloading works", {

    schedule <- get_retrosheet(type = "schedule", year = 1995, cache = "testdata")
    schedule_splits <- get_retrosheet(type = "schedule", year = 1995, schedSplit = "TimeOfDay")

    expect_equal(nrow(schedule), 2016)
    expect_equal(length(schedule_splits), 3)
    expect_equal(nrow(schedule_splits[[3]]), 1355)
    expect_equal(sum(unlist(lapply(schedule_splits, nrow), recursive = TRUE)), nrow(schedule))

})

test_that("Roster downloading works", {

    roster <- get_retrosheet("roster", 1995, cache = "testdata")
    expect_equal(length(roster), 28)
    expect_equal(nrow(roster[[1]]), 40)
    expect_equal(nrow(roster$TOR), 39)

})

test_that("Game downloading works", {

    game <- get_retrosheet("game", 2012, cache = "testdata")
    expect_equal(length(game), 161)
    expect_equal(nrow(game), 2430)

})

test_that("Play downloading works", {

    play <- get_retrosheet("play", 2012, "SFN", cache = "testdata")
    expect_equal(length(play), 81)
    expect_equal(nrow(play[[1]]$play), 68)
    expect_equal(nrow(play[[1]]$sub), 4)
    expect_equal(nrow(play[[1]]$start), 18)
    expect_equal(nrow(play[[1]]$info), 26)

})

# Delete any previously cached data
unlink("testdata", recursive = TRUE)
