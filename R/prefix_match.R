#' define constant values used in ggconf
#'
#' @param pattern  the pattern string
#' @param table a table of string to be matched
#' @param show_warn boolean for showing ambiguous match warning
#' @param debug show debugging message if true
#' 
#' 
find_first_index <- function(
    pattern = "sz",
    table = c("x", "y", "size", "shape", "colour", "fill", "alpha", "stroke"),
    show_warn = TRUE,
    debug = FALSE
){
    matched_df <- get_analogue(pattern, table, debug = debug)
    best_matched <- matched_df[1, ]
    return(best_matched$index)
}

#' define constant values used in ggconf
#'
#' \code{define_ggconf_constants} has no side effect.
#'
#' One thing to note is \code{define_ggconf_constants} set implicitly
#' the preference order of geom_name in ggplot2.
#' For example, 'a.txt' ambiguously matches to 'axis.text' and 'axis.title',
#' but ggconf automatically uses 'axis.text'
#' with or without a warning message about the ambiguity.
#'
#'
#' @seealso The preference order is used
#'          when doing partial match in GgplotParser.
#'
define_ggconf_constants <- function(){
    list(
        first_wd = getwd(),
        # BUILTIN command Vectors
        # Note: the following commands are not included -- see exec_ggconf
        #       echo print quit exit
        builtinv = c("cd", "dir", "dir.create", "ls", "list",
                     "mkdir", "pwd", "rm", "rmdir", "setwd"),
        # all geom in ggplot2 documents
        # the order in geom_namev is important
        # because build_ggplot_object() uses
        # the first element after partial matching
        # i.e. the preferable (frequently-used) geom should appear first
        geom_namev = c("abline", "area",
                       "bar", "bin2d", "blank", "boxplot",
                       "count", "curve", "contour", "crossbar",
                       "density", "density_2d", "dotplot",
                       "errorbar", "errorbarh",
                       "freqpoly", "histogram", "hline", "hex", "jitter",
                       # "l" matches "line" (the 1st element starting by "l")
                       "line", "label", "linerange",
                       "map",
                       # "p" matches to "point"
                       "point", "path", "polygon", "pointrange",
                       "quantile",
                       "rect", "rug", "raster", "ribbon",
                       "segment", "smooth", "step",
                       "text", "tile",
                       "vline", "violin"
        ),
        savev = c("png", "pdf"),
        themedf = get_all_theme_aes()
    )
}

#' get element tree clone
#'
#' @description  {
#'    devtools::check() add a note about using ggplot2:::.element_tree
#'    because it is an internal object of other packages.
#'    Thus, a quick-and-dirty solution,
#'    I just copied the resulted data frame here.
#' }
#'
#'
get_element_tree_clone <- function() {

    #
    # This is done for ggplot2 2.2.1 (commit 464e0f3) on January 6, 2017.

    rect_data <-
        matrix(strsplit(
        "line                                   line element_line
        rect                                   rect element_rect
        text                                   text element_text
        title                                  text element_text
        aspect.ratio                   aspect.ratio         unit
        axis.title                       axis.title element_text
        axis.title.x                   axis.title.x element_text
        axis.title.x.top           axis.title.x.top element_text
        axis.title.y                   axis.title.y element_text
        axis.title.y.right       axis.title.y.right element_text
        axis.text                         axis.text element_text
        axis.text.x                     axis.text.x element_text
        axis.text.x.top             axis.text.x.top element_text
        axis.text.y                     axis.text.y element_text
        axis.text.y.right         axis.text.y.right element_text
        axis.ticks                       axis.ticks element_line
        axis.ticks.x                     axis.ticks element_line
        axis.ticks.y                     axis.ticks element_line
        axis.ticks.length         axis.ticks.length         unit
        axis.line                         axis.line element_line
        axis.line.x                     axis.line.x element_line
        axis.line.y                     axis.line.y element_line
        legend.background         legend.background element_rect
        legend.margin                 legend.margin       margin
        legend.spacing               legend.spacing         unit
        legend.spacing.x           legend.spacing.x         unit
        legend.spacing.y           legend.spacing.y         unit
        legend.key                     element_rect element_rect
        legend.key.size             legend.key.size         unit
        legend.key.height         legend.key.height         unit
        legend.key.width           legend.key.width         unit
        legend.text                     legend.text element_text
        legend.text.align         legend.text.align    character
        legend.title                   legend.title element_text
        legend.title.align       legend.title.align    character
        legend.position             legend.position    character
        legend.direction           legend.direction    character
        legend.justification   legend.justification    character
        legend.box                       legend.box    character
        legend.box.just             legend.box.just    character
        legend.box.margin         legend.box.margin       margin
        legend.box.background          element_rect element_rect
        legend.box.spacing       legend.box.spacing         unit
        panel.background           panel.background element_rect
        panel.border                   element_rect element_rect
        panel.spacing                 panel.spacing         unit
        panel.spacing.x             panel.spacing.x         unit
        panel.spacing.y             panel.spacing.y         unit
        panel.grid                     element_line element_line
        panel.grid.major               element_line element_line
        panel.grid.minor               element_line element_line
        panel.grid.major.x             element_line element_line
        panel.grid.major.y             element_line element_line
        panel.grid.minor.x             element_line element_line
        panel.grid.minor.y             element_line element_line
        panel.ontop                     panel.ontop      logical
        plot.background             plot.background element_rect
        plot.title                       plot.title element_text
        plot.subtitle                 plot.subtitle element_text
        plot.caption                   plot.caption element_text
        plot.margin                     plot.margin       margin
        strip.background           strip.background element_rect
        strip.placement             strip.placement    character
        strip.text                       strip.text element_text
        strip.text.x                   strip.text.x element_text
        strip.text.y                   strip.text.y element_text
        strip.switch.pad.grid strip.switch.pad.grid         unit
        strip.switch.pad.wrap strip.switch.pad.wrap         unit",
        "\\s+")[[1]], nrow = 3)

    aes_info <- as.data.frame(t(rect_data), stringsAsFactors = FALSE)
    colnames(aes_info) <- c("name", "unknown", "class")
    return(aes_info)
}

#' get all theme element names
#'
#'
get_all_theme_aes <- function() {

    aes_info <- get_element_tree_clone()

    # Now all of aes_info$class is non-NULL and not element_blank().
    return(aes_info)
}

#' get all theme element configurations
#'
#' @param class one of "element_text", "element_blank", "element_line", or
#'        "element_rect"
#'
#'
get_theme_elem_name_conf <- function(class = "element_text") {
    blacklist <- c("inherit.blank", "debug")

    if (class == "element_text")
        fields <- names(ggplot2::element_text())
    else if (class == "element_rect")
        fields <- names(ggplot2::element_rect())
    else if (class == "element_line") {
        fields <- c(names(ggplot2::element_rect()), "arrow")
    }

    conf <- fields[! fields %in% blacklist]
    return(conf)
}
