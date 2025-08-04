
dashboardPage(
  
  dashboardHeader(title = "", titleWidth = 0),
  
  dashboardSidebar(
    collapsed = T,
    sidebarMenu(
      menuItem("Sample Size", tabName = "A", icon = icon("gear")),
      menuItem("Credible Interval", tabName = "D", icon = icon("chart-area")),
      menuItem("About", tabName = "B", icon = icon("info-circle")),
      menuItem("Contact", tabName = "C", icon = icon("address-book"))
    )
  ),
  
  dashboardBody(
    
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
        #loading-content {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background-color: white;
          z-index: 9999;
          display: flex;
          align-items: center;
          justify-content: center;
        }
      "))
    ),
    
    div(id = "loading-content", h2("Loading...")),
    
    tags$head(tags$title("Título da Aba do Navegador")),
    
    tags$head(tags$style(HTML(
      '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
    tags$script(HTML('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> Bayesian Sample Size for a Single Binomial Proportion </span>\');
      })
     ')),
    
    
    tabItems(
      
      tabItem(tabName = "A",
        
              fluidRow(
                column(2,
                       selectInput("crit", "Criterion:", choices = c("ACC", "ALC"), selected = "ALC")
                ),
                column(2,
                       numericInput("c", "Hyperparameter c:", value = 10, min = 1, step = 1)
                ),
                column(2,
                       numericInput("d", "Hyperparameter d:", value = 2, min = 1, step = 1)
                ),
                column(3,
                       uiOutput("input_rho")
                ),
                column(3,
                       uiOutput("input_len")
                ),
              ),
              
              fluidRow(
                column(4,
                       div(
                         style = "display: flex; align-items: center; gap: 8px;",
                         actionButton("estimar", "Compute", class = "btn btn-success", width = "80%"),
                         span("This may take some time.", style = "color: gray; font-size: 10px; white-space: nowrap;"))
                       )              
                ),
              
              br(),
              
              fluidRow(
                box(width = 6, title = "Result", status = "danger", solidHeader = TRUE,
                    withSpinner(verbatimTextOutput("resultado"), type = 6)),
                
                box(width = 6, title = "Prior distribution of θ", status = "danger", solidHeader = TRUE,
                    withSpinner(plotOutput("grafico_beta"), type = 6))
              )
              
      ),
      
      tabItem(tabName = "D",
              
              fluidRow(
                column(2,
                       selectInput("crit_ic", "Criterion:", choices = c("ACC", "ALC"), selected = "ALC")
                ),
                column(2,
                       numericInput("c_ic", "Hyperparameter c:", value = 10, min = 1, step = 1)
                ),
                column(2,
                       numericInput("d_ic", "Hyperparameter d:", value = 2, min = 1, step = 1)
                ),
                column(2,
                       numericInput("xn_ic", "Number of successes:", value = NULL, min = 0, step = 1)
                ),
                column(2, 
                       numericInput("n_ic", "Sample size:", value = NULL, min = 1, step = 1)
                ),
                column(2,
                       uiOutput("input_ic_dinamico")
                )
              ),
              
              fluidRow(
                column(3,
                       actionButton("calcular_ic", "Compute", class = "btn btn-success", width = "85%")
                )
              ),
              
              br(),
              
              fluidRow(
                box(width = 6, title = "Credible Interval", status = "danger", solidHeader = TRUE,
                    withSpinner(textOutput("resultado_ic"), type = 6)),
                
                box(width = 6, title = "Posterior distribution of θ", status = "danger", solidHeader = TRUE,
                    withSpinner(plotOutput("grafico_ic"), type = 6))
              )
      ),
      
      tabItem(
        tabName = "B",
        h1("About:"),
        h4("This is a Shiny app in R language to compute Bayesian sample size for binomial proportions developed by Makson Rodrigues under supervision of Prof. Eliardo Costa. For more details about the methodology, see the references below."),
        h2("Acknowledgements:"),
        h4(HTML('PROPESQ/UFRN for the Undergraduate Research Grant and Marcus A. Nunes (<a href="https://marcusnunes.me/" target="_blank">https://marcusnunes.me/</a>) 
                for the hosting of the app in the UFRN domain.')),
        h2("References:"),
        h4("Costa, E. (2025). bssbinom: Bayesian Sample Size for Binomial Proportions. R package version 1.0.0. https://doi.org/10.32614/CRAN.package.bssbinom"),
        h4("Costa, E. G. (2025). Bayesian Sample Size for Binomial Proportions with Applications in R. In: Awe, O.O., A. Vance, E. (eds) Practical Statistical Learning and Data Science Methods. STEAM-H: Science, Technology, Engineering, Agriculture, Mathematics & Health. Springer, Cham. https://doi.org/10.1007/978-3-031-72215-8_14.")
      ),
      
      tabItem(
        tabName = "C",
        h1("Contact:"),
        h3(a("Makson Pedro Rodrigues")),
        h4("\u2709 maksonpedro@gmail.com"),
        
        h3(a("Eliardo Guimarães da Costa")),
        h4("\u2709 eliardo.costa@ufrn.br"),
      )
              

      ),
      
    ),
    
    
  
  skin = "red"
  
)
