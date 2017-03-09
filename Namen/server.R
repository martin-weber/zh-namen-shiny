library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)

minNumberOfChars <- 2

shinyServer(function(input, output) {
  
  getNamesReactive <- reactive({
    selectedNames <- emptyNames
    if(nchar(input$inputName) >= minNumberOfChars){
      
      # select datasource
      if(input$inputSpecies == "human"){
        currentNames <- humanNames
      }
      else if(input$inputSpecies == "dog"){
        currentNames <- dogNames
      }
      
      selectedNames <- currentNames %>% 
        filter(Geschlecht %in% input$inputGender) %>%
        filter(between(Jahrgang, input$sliderYear[1], input$sliderYear[2]))%>%
        filter(str_detect(Vorname, regex(paste("^(", input$inputName, ").*", sep = ""), ignore_case =T)))
    }
    selectedNames
  })
  
  output$plotTimelines <- renderPlot({
    validate(
      need(nchar(input$inputName) >= minNumberOfChars, paste("Bitte mindestens ", minNumberOfChars, " Zeichen eingeben."))
    )
    
    ggplot(getNamesReactive()) +
      theme(legend.position="bottom",
            axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold")) +
      scale_x_continuous(limits = input$sliderYear, name = "Jahrgang") +
      geom_line(aes(x = Jahrgang, y = Anzahl, color = Vorname))
  })
  
  output$plotRanks <- renderPlot({
    validate(
      need(nchar(input$inputName) >= minNumberOfChars, paste("Bitte mindestens ", minNumberOfChars, " Zeichen eingeben."))
    )
    
    nameRanks <- getNamesReactive() %>%
      group_by(Vorname, Geschlecht) %>%
      summarise(Total = sum(Anzahl)) %>% 
      data.frame()
    
    selectedNameRanks <- nameRanks
    selectedNameRanks <- top_n(nameRanks, 10, wt = Total)

    ggplot(selectedNameRanks, aes(x = reorder(Vorname, Total), 
                                  y = Total, 
                                  fill = Geschlecht, 
                                  label = Total)) +
      theme(legend.position="bottom", 
            axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold")) +
      geom_bar(stat = 'identity') +
      xlab("Namen") +
      ylab("Total") +
      coord_flip() +
      scale_fill_manual('Geschlecht', values = c('#4d94ff', '#ff6666')) +
      geom_text(size = 5, position = position_stack(vjust = 0.5))
  })
})
