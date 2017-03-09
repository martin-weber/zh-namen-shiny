library(shiny)
library(shinythemes)

shinyUI(
  navbarPage(
    theme = shinytheme(theme = "cerulean"),
    title = "Namen in Zürich",
    inverse = F,
    tabPanel("Auswertung", fluidPage(
      sidebarPanel(fluidRow(
        selectInput("inputSpecies", "Gattung", list("Menschen" = "human", "Hunde" = "dog")),
        textInput("inputName", "Name", value = initialNameFragment)),
        sliderInput("sliderYear", "Jahrgang",
                    step = 1,
                    min = minJahrgang, max = maxJahrgang, 
                    value = c(minJahrgang, maxJahrgang)),
        checkboxGroupInput("inputGender", "Geschlecht",
                           choices = levels(currentNames$Geschlecht),
                           selected = levels(currentNames$Geschlecht))
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("nach Zeit",plotOutput("plotTimelines", height = 600)),
          tabPanel("nach Rang",plotOutput("plotRanks", height = 600))
        )
      )
    )),
    tabPanel("Info", fluidPage(
      tags$h1("Info"),
      tags$p("Visualisierung der Namen der zürcher Wohnbevölkerung (Menschen oder Hunde)."),
      tags$p("Es werden folgende Datensätze verwendet:"),
      tags$ul(
        tags$li(
          tags$a(href="https://data.stadt-zuerich.ch/dataset/bev-bestand-vornamen-jahrgang-geschlecht",
                 "Hundenamen aus dem Hundebestand der Stadt Zürich")),
        tags$li(
          tags$a(href="https://data.stadt-zuerich.ch/dataset/pd-stapo-hundenamen", 
                 "Vornamen der aktuellen Wohnbevölkerung der Stadt Zürich"))
        ),
      tags$p("Source Code: ", 
             tags$a(href="https://github.com/martin-weber/zh-namen-shiny", 
                    "https://github.com/martin-weber/zh-namen-shiny"))
      )
    )
  )
)

