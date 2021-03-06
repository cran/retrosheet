#' @name getTeamIDs
#'
#' @title Retrieve team IDs for event files
#'
#' @description This function retrieves the team ID needed for the
#' \code{team} argument of \code{getRetrosheet("play", year, team)}.
#'
#' @param year A single valid four-digit numeric year.
#'
#' @return If the file exists, a named vector of IDs for the given year.
#' Otherwise \code{NA}.
#'
#' @details All currently available years can be retrieved with
#' \code{type.convert(substr(getFileNames()$event, 1L, 4L))}
#'
#' @importFrom httr http_error write_disk RETRY timeout
#' @export
#'
#' @examples \donttest{
#' getTeamIDs(2010)
#' }
#'
getTeamIDs <- function(year) {
    stopifnot(is.numeric(year), length(year) == 1L)
    path <- sprintf("https://www.retrosheet.org/events/%deve.zip", year)
    if (!http_error(path)) {
        tmp <- tempfile()
        on.exit(unlink(tmp))
        RETRY("GET", url = path, write_disk(tmp, overwrite=TRUE), timeout(15))
    } else {
        available <- grep(year, getFileNames()$event)
        if(!length(available)) {
            return(NA)

        }
    }
    fname <- paste0("TEAM", year)
    unzip(tmp, files = fname)
    on.exit(unlink(fname), add = TRUE)

    read <- suppressWarnings(read.csv(fname, header = FALSE, stringsAsFactors = FALSE))[c(1, 4)]

    out <- structure(read[[1L]], .Names = read[[2L]])
    out
}
