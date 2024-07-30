# vim: set filetype=r:

# Default CRAN mirror
options(repos=structure(c(CRAN="https://cloud.r-project.org/")))

# Print data.table's columns classes and key
options(datatable.print.class = TRUE, datatable.print.keys = TRUE)

# Monitor memory usage ( https://stackoverflow.com/questions/1358003 )
.ls.objects <- function (pos = 1,
                         pattern,
                         order.by,
                         decreasing=FALSE,
                         head=FALSE,
                         n=5) {
  napply <- function(names, fn) sapply(names, function(x) fn(get(x, pos = pos)))
  names <- ls(pos = pos, pattern = pattern)
  obj.class <- napply(names, function(x) as.character(class(x))[1])
  obj.mode <- napply(names, mode)
  obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
  obj.prettysize <- napply(names,
                           function(x) {
                             format(utils::object.size(x), units = "auto")
                           })
  obj.size <- napply(names, object.size)
  obj.dim <- t(napply(names, function(x) as.numeric(dim(x))[1:2]))
  vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
  obj.dim[vec, 1] <- napply(names, length)[vec]
  out <- data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
  names(out) <- c("Type", "Size", "PrettySize", "Length/Rows", "Columns")
  if (!missing(order.by)) {
    out <- out[order(out[[order.by]], decreasing=decreasing), ]
  }
  if (head) {
    out <- head(out, n)
  }
  return(out)
}
.lsos <- function(..., n=10) {
  .ls.objects(..., order.by="Size", decreasing=TRUE, head=TRUE, n=n)
}

# Built-in color names ( http://www.sthda.com/english/wiki/colors-in-r )
.showCols <- function(cl=colors(),
                     bg = "grey",
                     cex = 0.75,
                     rot = 30) {
  m <- ceiling(sqrt(n <-length(cl)))
  length(cl) <- m*m; cm <- matrix(cl, m)
  require("grid")
  grid.newpage(); vp <- viewport(w = .92, h = .92)
  grid.rect(gp=gpar(fill=bg))
  grid.text(cm, x = col(cm)/m, y = rev(row(cm))/m, rot = rot, vp=vp,
            gp=gpar(cex = cex, col = cm))
}

# Set IRkernel default plot size ( https://irkernel.github.io/ )
.d <- function(width = 8, height = 5, scale = 2) {
  options(repr.plot.width = width, repr.plot.height = height,
          jupyter.plot_scale = scale)
}

# Initialize environment and print summary, useful for notebooks
.envInit <- function(packages = NULL) {
  if (!is.null(packages)) {
    invisible(lapply(packages, library, character.only = TRUE))
  }
  print(R.version.string)
  print(sapply(packages, function(x) paste0(packageVersion(x))))
}
