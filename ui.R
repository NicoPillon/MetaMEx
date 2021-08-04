source("annexes/functions.R")
source("tabs/tab_home.R")
source("tabs/tab_metaanalysis_human.R")
source("tabs/tab_metaanalysis_mouse.R")
#source("tabs/tab_correlations.R")
source("tabs/tab_datasets.R")
source("tabs/tab_download.R")
source("tabs/tab_acknowledgments.R")


fluidPage(title="MetaMEx",
          useShinyjs(),
          style="padding:0 0 0 0",
          div(style="position:absolute;height:100%;width:100%;text-align:center;padding:3% 0 7% 0;background-color:#5B768E",
              id="loading_page",
              h1(style="color:white;font-weight:bold", "MetaMEx"),
              h4(style="color:white", "Meta-analysis of Skeletal Muscle Response to Exercise"),
              div(style="align:center;bottom:0;padding:2% 0 20% 0;background-color:#5B768E",
                  tags$img(src='dna.gif', width="20%"),
                  h5(style="color:white", "Loading, please wait...")
              ),
              fluidRow(style="position:fixed;bottom:0;width:100%;height:45px;color:white;background-color:#5b768e;z-index:1000",
                       column(9, style="padding:0.4% 1% 1% 3%;", align="left",
                              a("Transcriptomic Profiling of Skeletal Muscle Adaptations to Exercise and Inactivity",
                                href="https://doi.org/10.1038/s41467-019-13869-w", target="_blank", style="color:#D9DADB"), 
                              tags$br(),
                              "Pillon, Zierath et al. Nat Commun. 2020; 11: 470."),
                       column(3, style="padding:0.4% 3% 1% 1%;", align="right",
                              tags$b(HTML("Share:&nbsp")),
                              actionButton("twitter_share", 
                                           label=NULL, 
                                           icon=icon("twitter"),
                                           onclick = sprintf("window.open('%s')", url_twitter)),
                              actionButton("linkedin_share", 
                                           label=NULL, 
                                           icon=icon("linkedin"),
                                           onclick = sprintf("window.open('%s')", url_linkedin)),
                              actionButton("facebook_share", 
                                           label=NULL, 
                                           icon=icon("facebook"),
                                           onclick = sprintf("window.open('%s')", url_facebook))
                       )
              )
          ),
          
          hidden(
            div(id="main_content",
                style="padding:0 0 0 0",
                
                navbarPage(title="MetaMEx",  id="inTabset",
                           #add css theme
                           theme="simplex_custom.css", #shinytheme("cosmo"),
                           #include google analytics & adjust progress bar position
                           header=tags$head(includeHTML("google-analytics.html"),
                                            tags$style(HTML(".shiny-notification { height: 50px;
                                                                           width: 800px;
                                                                           position:fixed;
                                                                           top: calc(50% - 50px);
                                                                           left: calc(50% - 400px); }")),
                                            tags$style(HTML(".checkbox { font-size: 90%;}")),
                                            tags$style(HTML(".checkbox-inline { margin-left: 0px;
                                                                        margin-right: 10px;  }
                                                     .checkbox-inline+.checkbox-inline { margin-left: 0px;
                                                                                         margin-right: 10px; } "))
                           ),

                           ########################################################################################        
                           tabHome,
                           
                           ########################################################################################        
                           tabMetaanalysis_human,         
                           
                           ########################################################################################        
                           tabMetaanalysis_mouse,  

                           ########################################################################################        
                           #tabCorrelations,
                           
                           ########################################################################################        
                           tabDatasets,
                           
                           ########################################################################################        
                           tabDownloads,
                           
                           ########################################################################################        
                           tabPanel("Help", value="Tutorial",
                                    tags$script(src = "myscript.js"),
                                    fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;
                                             padding:0.5% 1.5% 1% 1.3%",
                                             h2(style="color:white", "Welcome to MetaMEx"),
                                             h5(style="color:white", "The online database of skeletal muscle 
                                                transcriptomic response to exercise and inactivity. On this website, 
                                                you will be able to explore how specific genes respond to acute exercise, 
                                                exercise training and inactivity in all available transcriptomic datasets.
                                                This section summarizes and explains the main analyses available on MetaMEx."
                                             ),
                                    ),
                                    fluidRow(style="padding:2% 5% 10% 5%",
                                             includeMarkdown("annexes/tutorial.md"))
                           ),
                           
                           
                           ########################################################################################        
                           tabAcknowledgments,
                           
                           # sticky footer ##################################################################################        
                           fluidRow(style="position:fixed;bottom:0;width:100%;height:45px;color:white;background-color:#5b768e;z-index:1000;",
                                    column(9, style="padding:0.4% 1% 1% 3%;", align="left",
                                           a("Transcriptomic Profiling of Skeletal Muscle Adaptations to Exercise and Inactivity",
                                             href="https://doi.org/10.1038/s41467-019-13869-w", target="_blank", style="color:#D9DADB"),
                                           tags$br(),
                                           "Pillon, Zierath et al. Nat Commun. 2020; 11: 470."),
                                    column(3, style="padding:0.4% 3% 1% 1%;", align="right",
                                           tags$b(HTML("Share:&nbsp")),
                                           actionButton("twitter_share", 
                                                        label=NULL, 
                                                        icon=icon("twitter"),
                                                        onclick = sprintf("window.open('%s')", url_twitter)),
                                           actionButton("linkedin_share", 
                                                        label=NULL, 
                                                        icon=icon("linkedin"),
                                                        onclick = sprintf("window.open('%s')", url_linkedin)),
                                           actionButton("facebook_share", 
                                                        label=NULL, 
                                                        icon=icon("facebook"),
                                                        onclick = sprintf("window.open('%s')", url_facebook))
                                           )
                           )
                           
                )
                
            )

          )
)
