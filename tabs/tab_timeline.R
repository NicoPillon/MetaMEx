tabTimeline <- tabPanel("Timeline", value="panelTimeline",
                        
                        # Row introduction ####################################################################################
                        fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0% 1.3%",
                                 h5(style="color:white","Use the timeline to observe the expression of
                                        your gene of interest over time. This analysis is only available for healthy individuals
                                        and pools data from all available studies."
                                 )
                        ),
                        
                        # Row App and plots ###################################################################################
                        fluidRow(style="margin:0px -15px 0px -15px;",
                                 column(2,
                                        style="padding:12px 10px 0px 1%;background-color: #5b768e",
                                        selectizeInput("genename_timeline", label=NULL, 
                                                       choices=NULL,
                                                       options=NULL)
                                 ),
                                 column(10,
                                        style="padding:0 0 0 0;background-color: #5b768e",
                                        tabsetPanel(type="pills", id="inTabsetMeta",
                                                    tabPanel("Acute Exercise", value="panelTimelineAcute",
                                                             fluidRow(style="background-color: white;padding:0",
                                                               column(5, tags$br(),
                                                                      plotOutput("TimelineAcutePlot", height="280px")
                                                               ),
                                                               column(5,  tags$br(),
                                                                      h5("Acute exercise timeline: statistics", style="font-weight: bold"),
                                                                      tableOutput("TimelineAcuteTable")
                                                               )
                                                             )
                                                    ),
                                                    tabPanel("Inactivity", value="panelTimelineInactivity",
                                                             fluidRow(style="background-color: white;padding:0",
                                                               column(4,  tags$br(),
                                                                      plotOutput("TimelineInactivityPlot", height="250px")
                                                               ),
                                                               column(6,  tags$br(), 
                                                                      h5("Inactivity timeline: statistics", style="font-weight: bold"),
                                                                      tableOutput("TimelineInactivityTable")
                                                               )
                                                             )
                                                    )
                                        )
                                 )
                        )
)