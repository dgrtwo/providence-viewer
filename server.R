library(shiny)
library(reshape2)
library(plyr)
library(dplyr)
library(ggplot2)
library(rjson)

compact <- function(x) Filter(function(e) length(e) > 0, x)

shinyServer(function(input, output) {
    json <- reactive({
        if (!is.null(input$data_file)) {
            lines <- readLines(input$data_file$datapath)            
            return(fromJSON(paste(lines, collapse = " ")))
        }
    })
    
    output$categories_plot <- renderPlot({
        j <- json()
        if (!is.null(j)) {
            tidied <- j$Data[c("TagViews", "InterestingTags", "MinorWebDeveloperKinds", "MinorMobileDeveloperKinds",
            "MinorOtherDeveloperKinds", "TechStacks")] %>%
                compact() %>%
                ldply(melt, .id = "Type") %>%
                rename(Category = L1) %>%
                group_by(Type) %>%
                filter(length(Category) > 1)
            
            # extract top stacks and tags
            num_cat <- data.frame(Type = c("TechStacks", "TagViews"),
                                  Limit = c(input$stacks, input$tags))
            
            filtered <- tidied %>%
                left_join(num_cat) %>%
                tidyr::replace_na(list(Limit = 100)) %>%
                group_by(Type) %>%
                filter(rank(-value) <= Limit, value > 1e-6) %>%
                ungroup() %>%
                mutate(Category = reorder(Category, value, function(x) -mean(x)))    

            g <- ggplot(filtered, aes(Category, value)) +
                geom_bar(stat = "identity") +
                facet_wrap(~ Type, scales = "free") +
                theme(axis.text.x = element_text(angle = 90, hjust = 1,
                                                 face = 'bold', size = 9))
            
            print(g)
        }
  }, height = 600, width = 600)

})
