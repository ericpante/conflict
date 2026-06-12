# R/build_igraph.R

#' Build igraph object
#' @export
build_coauthor_graph <- function(edge_list) {
  igraph::graph_from_data_frame(edge_list, directed = FALSE)
}
