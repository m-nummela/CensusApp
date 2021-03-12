# Package names
packages <- c("shiny", "maps", "mapproj")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
   install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# Load data
counties = readRDS("data/counties.rds")

# Source helper functions
source("helpers.R")

# User interface
ui = fluidPage(
   titlePanel("US Census Data (2010)"),

   sidebarLayout(
      sidebarPanel(
         helpText("Engage with maps of demographic
        information from the US Census (2010)."),

         selectInput("var",
                     label = "Choose a variable to display",
                     choices = c("Percent White", "Percent Black",
                                 "Percent Hispanic", "Percent Asian"),
                     selected = "Percent White"),

         sliderInput("range",
                     label = "Range of interest:",
                     min = 0, max = 100, value = c(0, 100))
      ),

      mainPanel(plotOutput("map"))
   )
)

# Server logic ----
server = function(input, output) {
   output$map = renderPlot({
      data = switch(input$var,
                    "Percent White" = counties$white,
                    "Percent Black" = counties$black,
                    "Percent Hispanic" = counties$hispanic,
                    "Percent Asian" = counties$asian)

      color = switch(input$var,
                     "Percent White" = "darkgray",
                     "Percent Black" = "darkblue",
                     "Percent Hispanic" = "darkgreen",
                     "Percent Asian" = "darkviolet")

      legend = switch(input$var,
                      "Percent White" = "% White",
                      "Percent Black" = "% Black",
                      "Percent Hispanic" = "% Hispanic",
                      "Percent Asian" = "% Asian")

      percent_map(data, color, legend, input$range[1], input$range[2])
   })
}

# Run app
shinyApp(ui, server)
