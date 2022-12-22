########################################################################################        
tabHome <- tabPanel("Home", 
                    class="bg_image",
                    tags$br(),
                    ########################################################################################
                    fluidRow(style="padding:5% 2% 5% 2%;align:center;margin:-50px -15px 100px -15px;",
                             align="center",
                             tags$div(align="center", 
                                      style="align:center;padding:0.5% 2% 2% 2%;
                                      background-color:rgba(255, 255, 255, 0.7);width:60%",
                                      h1(style="font-weight:bold;color:#011b2a", "MetaMEx"),
                                      h4(style="font-weight:bold;color:#011b2a", "Meta-analysis of Skeletal Muscle Response to Exercise"),
                                      tags$hr(),
                                      selectizeInput("genename_home", label=tags$b("Select the gene you want to analyse:"), 
                                                     choices=NULL,
                                                     selected=NULL),
                                      actionButton(class="btn btn-primary",
                                                   'jumpToAppAcute', 'Acute Exercise', width="160px"),
                                      HTML('&nbsp;'), HTML('&nbsp;'),
                                      actionButton(class="btn btn-primary",
                                                   'jumpToAppTraining', 'Exercise Training', width="160px"),
                                      HTML('&nbsp;'), HTML('&nbsp;'),
                                      actionButton(class="btn btn-primary",
                                                   'jumpToAppInactivity', 'Inactivity', width="160px")
                             ),
                             tags$br(),

                             tags$div(align="center", 
                                      style="align:center;padding:1% 4% 1% 4%;
                                      background-color:rgba(91, 118, 142, 0.7);width:60%",
                                      
                             h5(style="color:white;",
                                "The app to meta-analyse skeletal muscle transcriptomic response to inactivity and exercise.
                           Use MetaMEx to get a complete overview the behavior of a specific gene across
                                 all published exercise and inactivity transcriptomic studies. 
                                MetaMEx v3.2208, last update August 2022"),
                             h4(style="color:white;font-weight:bold",
                                actionLink(style="color:white;font:bold", 'jumpToHelp', 'Get help >'))
                             )
                    )
)