#' Check User's Saved Albums
#'
#'Check if one or more albums is already saved in the current Spotify user’s ‘Your Music’ library.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @return
#' Returns a data frame of results containing album id and saved status. See \url{https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-albums/} for more information.
#' @export

check_my_saved_albums <- function(ids, authorization = get_spotify_authorization_code()) {
    base_url = 'https://api.spotify.com/v1/me/albums/contains'
    params <- list(ids = ids)
    # params <- ids
    res <- RETRY('GET', base_url, query = params, config(token = authorization), encode = 'json')
    stop_for_status(res)
    res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)

    tibble(album_id = ids,
           is_saved = res)
}
#' Check User's Saved Shows
#'
#'Check if one or more shows is already saved in the current Spotify user’s library.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @return
#' Returns a data frame of results containing show id and saved status. See \url{https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-albums/} for more information.
#' @export

check_my_saved_shows <- function(ids, authorization = get_spotify_authorization_code()) {
    base_url = 'https://api.spotify.com/v1/me/shows/contains'
    params <- list(ids = ids)
    # params <- ids
    res <- RETRY('GET', base_url, query = params, config(token = authorization), encode = 'json')
    stop_for_status(res)
    res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)

    tibble(album_id = ids,
           is_saved = res)
}
#' Check User's Saved Tracks
#'
#'Check if one or more tracks is already saved in the current Spotify user’s ‘Your Music’ library.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @return
#' Returns a data frame of results containing track id and saved status. See \url{https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-albums/} for more information.
#' @export

check_my_saved_tracks <- function(ids, authorization = get_spotify_authorization_code()) {
    base_url = 'https://api.spotify.com/v1/me/tracks/contains'
    params <- list(ids = ids)
    # params <- ids
    res <- RETRY('GET', base_url, query = params, config(token = authorization), encode = 'json')
    stop_for_status(res)
    res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)

    tibble(album_id = ids,
           is_saved = res)
}

#' Get Current User's Saved Albums
#'
#' Get a list of the albums saved in the current Spotify user’s ‘Your Music’ library.
#'
#' @param limit Optional. \cr
#' Maximum number of albums to return. \cr
#' Default: 20 \cr
#' Minimum: 1 \cr
#' Maximum: 50 \cr
#' @param offset Optional. \cr
#' The index of the first albums to return. \cr
#' Default: 0 (the first object). Maximum offset: 100,000. Use with \code{limit} to get the next set of albums.
#' @param market Optional. \cr
#' An \href{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}{ISO 3166-1 alpha-2 country code} or the string \code{"from_token"}. Provide this parameter if you want to apply \href{https://developer.spotify.com/documentation/general/guides/track-relinking-guide/}{Track Relinking}
#' @param authorization Required.\cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param include_meta_info Optional.\cr
#' Boolean indicating whether to include full result, with meta information such as \code{"total"}, and \code{"limit"}. Defaults to \code{FALSE}.
#' @return
#' Returns a data frame of results containing user saved albums information. See \url{https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/} for more information.
#' @export

get_my_saved_albums <- function(limit = 20, offset = 0, market = NULL, authorization = get_spotify_authorization_code(), include_meta_info = FALSE) {
    base_url <- 'https://api.spotify.com/v1/me/albums'
    if (!is.null(market)) {
        if (str_detect(market, '^[[:alpha:]]{2}$')) {
            stop('"market" must be an ISO 3166-1 alpha-2 country code')
        }
    }
    params <- list(
        limit = limit,
        offset = offset,
        market = market
    )
    res <- RETRY('GET', base_url, query = params, config(token = authorization), encode = 'json')
    stop_for_status(res)
    res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)

    if (!include_meta_info) {
        res <- res$items
    }
    return(res)
}

#' Get User's Saved Shows
#'
#' Get a list of shows saved in the current Spotify user’s library. Optional parameters can be used to limit the number of shows returned.
#'
#' @param limit Optional. \cr
#' Maximum number of shows to return. \cr
#' Default: 20 \cr
#' Minimum: 1 \cr
#' Maximum: 50 \cr
#' @param offset Optional. \cr
#' The index of the first show to return. \cr
#' Default: 0 (the first object). Use with \code{limit} to get the next set of shows.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param include_meta_info Optional. \cr
#' Boolean indicating whether to include full result, with meta information such as \code{"total"}, and \code{"limit"}. Defaults to \code{FALSE}.
#'
#' @return
#' Returns a data frame of results containing saved shows information. See \url{https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-shows/} for more information.
#' @export

get_my_saved_shows <- function(limit = 20, offset = 0, authorization = get_spotify_authorization_code(), include_meta_info = FALSE) {
    base_url <- 'https://api.spotify.com/v1/me/shows'
    params <- list(
        limit = limit,
        offset = offset
    )
    res <- RETRY('GET', base_url, query = params, config(token = authorization), encode = 'json')
    stop_for_status(res)
    res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)

    if(!include_meta_info) {
        res <- res$items
    }
    return(res)
}

#' Get a User's Saved Tracks
#'
#'Get a list of the songs saved in the current Spotify user’s ‘Your Music’ library.
#'
#' @param limit Optional. \cr
#' Maximum number of tracks to return. \cr
#' Default: 20 \cr
#' Minimum: 1 \cr
#' Maximum: 50 \cr
#' @param offset Optional. \cr
#' The index of the first track to return. \cr
#' Default: 0 (the first object). Maximum offset: 100,000. Use with \code{limit} to get the next set of tracks.
#' @param market Optional. \cr
#' An \href{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}{ISO 3166-1 alpha-2 country code} or the string \code{"from_token"}. Provide this parameter if you want to apply \href{https://developer.spotify.com/documentation/general/guides/track-relinking-guide/}{Track Relinking}
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param include_meta_info Optional. \cr
#' Boolean indicating whether to include full result, with meta information such as \code{"total"}, and \code{"limit"}. Defaults to \code{FALSE}.
#' @return
#' Returns a data frame of results containing user saved tracks information. See \url{https://developer.spotify.com/documentation/web-api/reference/users-profile/get-users-saved-tracks/} for more information.
#' @export

get_my_saved_tracks <- function(limit = 20, offset = 0, market = NULL, authorization = get_spotify_authorization_code(), include_meta_info = FALSE) {
    base_url <- 'https://api.spotify.com/v1/me/tracks'
    if (!is.null(market)) {
        if (str_detect(market, '^[[:alpha:]]{2}$')) {
            stop('"market" must be an ISO 3166-1 alpha-2 country code')
        }
    }
    params <- list(
        limit = limit,
        offset = offset,
        market = market
    )
    res <- RETRY('GET', base_url, query = params, config(token = authorization), encode = 'json')
    stop_for_status(res)
    res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)

    if (!include_meta_info) {
        res <- res$items
    }
    return(res)
}

#' Remove Albums for Current User
#'
#' Remove one or more albums from the current user’s ‘Your Music’ library. \cr
#' Changes to a user’s saved albums may not be visible in other Spotify applications immediately.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param echo Optional.\cr
#' Boolean indicating whether to return the response or work silently.
#'
#' @return
#' Returns a respinse status. See \url{https://developer.spotify.com/documentation/web-api/#response-status-codes} for more information.
#' @export

remove_my_saved_albums <- function(ids, authorization = get_spotify_authorization_code(), echo =FALSE) {
    base_url <- 'https://api.spotify.com/v1/me/albums'

    params <- toJSON(ids)

    res <- RETRY('DELETE', base_url, body = params, config(token = authorization), encode = 'json')
    stop_for_status(res)

    if (echo) {
        return(res)
    }
}

#' Remove User's Saved Shows
#'
#' Delete one or more shows from current Spotify user’s library.\cr
#' Changes to a user’s saved shows may not be visible in other Spotify applications immediately.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param echo Optional.\cr
#' Boolean indicating whether to return the response or work silently.
#'
#' @return
#' Returns a respinse status. See \url{https://developer.spotify.com/documentation/web-api/#response-status-codes} for more information.
#' @export

remove_my_saved_shows <- function(ids, authorization = get_spotify_authorization_code(), echo =FALSE) {
    base_url <- 'https://api.spotify.com/v1/me/shows'

    params <- toJSON(ids)

    res <- RETRY('DELETE', base_url, body = params, config(token = authorization), encode = 'json')
    stop_for_status(res)

    if (echo) {
        return(res)
    }
}

#' Remove User's Saved Tracks
#'
#' Remove one or more tracks from the current user’s ‘Your Music’ library. \cr
#' Changes to a user’s saved tracks may not be visible in other Spotify applications immediately.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param echo Optional.\cr
#' Boolean indicating whether to return the response or work silently.
#'
#' @return
#' Returns a respinse status. See \url{https://developer.spotify.com/documentation/web-api/#response-status-codes} for more information.
#' @export

remove_my_saved_tracks <- function(ids, authorization = get_spotify_authorization_code(), echo =FALSE) {
    base_url <- 'https://api.spotify.com/v1/me/tracks'

    params <- toJSON(ids)

    res <- RETRY('DELETE', base_url, body = params, config(token = authorization), encode = 'json')
    stop_for_status(res)

    if (echo) {
        return(res)
    }
}


#' Save Albums for Current User
#'
#' Save one or more albums to the current user’s ‘Your Music’ library.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param echo Optional.\cr
#' Boolean indicating whether to return the response or work silently.
#'
#' @return
#' Returns a respinse status. See \url{https://developer.spotify.com/documentation/web-api/#response-status-codes} for more information.
#' @export

save_albums_to_library <- function(ids, authorization = get_spotify_authorization_code(), echo = FALSE){
    base_url <- 'https://api.spotify.com/v1/me/albums'

    params <- toJSON(ids)
    res <- RETRY('PUT', base_url, body = params, config(token = authorization), encode = 'json')
    stop_for_status(res)

    if (echo) {
        return(res)
    }
}

#' Save Shows for Current User
#'
#' Save one or more shows to current Spotify user’s library.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param echo Optional.\cr
#' Boolean indicating whether to return the response or work silently.
#'
#' @return
#' Returns a respinse status. See \url{https://developer.spotify.com/documentation/web-api/#response-status-codes} for more information.
#' @export

save_shows_to_library <- function(ids, authorization = get_spotify_authorization_code(), echo = FALSE){
    base_url <- 'https://api.spotify.com/v1/me/shows'

    params <- toJSON(ids)
    res <- RETRY('PUT', base_url, body = params, config(token = authorization), encode = 'json')
    stop_for_status(res)

    if (echo) {
        return(res)
    }
}

#' Save Tracks for Current User
#'
#' Save Tracks for User Save one or more tracks to the current user’s ‘Your Music’ library.
#'
#' @param ids Required. \cr
#' A comma-separated list of the \href{https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids}{Spotify IDs} for the albums. Maximum: 50 IDs.
#' @param authorization Required. \cr
#' A valid access token from the Spotify Accounts service. See the \href{https://developer.spotify.com/documentation/general/guides/authorization-guide/}{Web API authorization Guide} for more details. Defaults to \code{spotifyr::get_spotify_authorization_code()}. The access token must have been issued on behalf of the current user.
#' @param echo Optional.\cr
#' Boolean indicating whether to return the response or work silently.
#'
#' @return
#' Returns a respinse status. See \url{https://developer.spotify.com/documentation/web-api/#response-status-codes} for more information.
#' @export

save_tracks_to_library <- function(ids, authorization = get_spotify_authorization_code(), echo = FALSE){
    base_url <- 'https://api.spotify.com/v1/me/tracks'

    params <- toJSON(ids)
    res <- RETRY('PUT', base_url, body = params, config(token = authorization), encode = 'json')
    stop_for_status(res)

    if (echo) {
        return(res)
    }
}
