library(shiny)

msg <- paste("<span style = 'font-size: 11px'>",
             "You can download your personalized prediction data from",
             "Stack Exchange",
             "<a href='http://stackoverflow.com/users/prediction-data'>",
             "here</a>. It should be called something like</br>",
             "<span style = 'font-family: Courier'>Stack Exchange personalized [...].json",
             "</span></span>")

shinyUI(fluidPage(
  # Application title
  titlePanel("Personalized Stack Exchange Prediction Viewer"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput("data_file", "Upload personalized prediction data",
                accept = "text/json"),
      HTML(msg),
      HTML("<div style = 'height: 25px'></div>"),
      sliderInput("tags",
                  "Number of tags shown:",
                  min = 1,
                  max = 25,
                  value = 6),
      sliderInput("stacks",
                  "Number of TechStacks shown:",
                  min = 1,
                  max = 16,
                  value = 6),
       HTML("<span style = 'font-size: 11px'>",
            "<p>This app is <i>not</i> affiliated with Stack Exchange. It also does",
            "not permanently store any of your data or other information about you.",
            "The Shiny Apps Terms of Use, including terms of use for uploaded files,",
            "can be found",
            "<a href='http://www.rstudio.com/about/shiny-apps-terms-use/'>here</a>.",
            "</p>"),
      HTML("<p>See <a href='https://github.com/dgrtwo/providence-viewer'>",
           "here</a> for the Shiny code used for this app.</p>"),
      HTML("<p>See <a href='http://kevinmontrose.com/2015/01/29/providence-what-technologies-do-you-know/'>",
           "here</a> for more about how Stack Exchange's Providence system",
           "constructs these predictions",
           "based on your traffic on the site.</p></span>")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("categories_plot")
    )
  )
))
