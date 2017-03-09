#' @title Euclidean Distance For Radial Arm Maze
#'
#' @description This function calculates the Euclidean distance in a
#'  multidimensional space between the number of individuals in each zone of a
#'  radial arm maze.
#'
#' @param x A vector containing the number of animals in each zone of the
#'  radial arm maze.
#'
#' @return A numeric scalar.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
.Dc <- function(x) {
  sqrt(sum(x ^ 2))
}


#' @title Minimum Euclidean Distance Of All Possible Partitions of N Individuals
#'  In A Radial Arm Maze
#'
#' @description This function calculates the minimum Euclidean distance of all
#'  possible partitions of N individuals in a radial arm maze with M arms.
#'
#' @param x A vector containing the number of animals in each zone of the
#'  radial arm maze.
#'
#' @return A numeric scalar.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
.Dmin <- function(x) {
  Z <- length(x)
  N <- sum(x)
  parts <- partitions::restrictedparts(N, Z)
  min(sqrt(apply(parts ^ 2, 2, sum)))
}


#' @title Group Cohesion Index For Radial Arm Maze
#'
#' @description This function calculates the cohesion index of groups of animals
#'  navigating a radial arm maze. Maximum cohesion occurs when all group members
#'  are in the same zone of the radial arm maze; minimum cohesion occurs when
#'  group members are equally spread between all the zones of the radial arm
#'  maze.
#'
#' @param df A data frame containing the number of animals in each zone of the
#'  radial arm maze. The data frame should be organized as follows: each column
#'  must correspond to a zone of the radial arm maze and each row must
#'  correspond to a different observation.
#'
#' @return A vector of length \code{nrow(df)}.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @export
#'
Ic <- function(df) {
  if (!all(apply(df, 2, is.numeric)))
    stop("All columns of df must be numerical.")

  N <- apply(df, 1, sum)
  Dc <- apply(df, 1, .Dc)
  Dmin <- apply(df, 1, .Dmin)
  (Dc - Dmin) / (N - Dmin)
}
