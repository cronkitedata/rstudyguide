library(bookdown)

render_book("index.Rmd", output_format = "bookdown::gitbook",
            output_dir = "docs",  config_file = "_bookdown.yml")


# To stage all, go to a terminal window and say git add .
# Then you can commit. 