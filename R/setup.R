## Default Configurations
knitr_config <- list(
    fig.width  = 12, 
    fig.asp    = 0.618, 
    fig.align  = "center",
    engine     = "python",
    background = NA,
    comment = NA
)
## Specific for Mac
if (Sys.info()["sysname"] %in% c("Darwin")) {
	knitr_config['engine.path'] = list(python = system2("which", "python3", stdout = TRUE))
}

## Set printer-friendly knitr theme, run only when called from LyX
if (!interactive()){
    thm <- knitr::knit_theme$get("print")
    knitr::knit_theme$set(thm)
}

knitr::opts_chunk$set(knitr_config)

## Common Hooks
hook_lst_bf <- function(x, options) {
    paste("\\begin{lstlisting}[]\n", x, 
        "\\end{lstlisting}\n", sep = "")
}

## Customize Hooks
knitr::knit_hooks$set(
    sympy = function(before, options, envir) {},
    replaceR = function(before, options, envir) {},
    source = function(x, options) {
        if (!is.null(options$sympy) && options$sympy){
            x <- sub("from\\s+sympy\\s+import\\s+latex\\n", "", x)
            x <- sub("print\\(latex\\((.*),(.*)\\)\\)", "\\1", x)
        }
        if (!is.null(options$replaceR)) x <- sub(options$replaceR, "r", x)
        
        lst_opts <- "style=Source"
        if (!is.null(options$caption)) {
            lst_opts <- paste(lst_opts, ",caption=", options$caption)
        }
        paste("\\begin{lstlisting}[", lst_opts, "]\n", 
              paste(x, collapse="\n"), 
              "\\end{lstlisting}\n", sep = "")
    }, 
    output = function(x, options) {
        if (options$results == 'asis') return(x)
        if (!is.null(options$replaceR)) x <- sub(options$replaceR, "r", x)
        paste("\\begin{lstlisting}[style=Result]\n", x, 
            "\\end{lstlisting}\n", sep = "")
    }, 
    warning = hook_lst_bf, 
    message = hook_lst_bf, 
    error = hook_lst_bf
)

## Option Hooks for Sympy Printing
knitr::opts_hooks$set(
    sympy = function(options) {
        if(options$sympy) options$results = "asis"
        return(options)
    }
)

## empty highlight header
knitr::set_header(highlight = "")

