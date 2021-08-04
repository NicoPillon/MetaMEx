tabCorrelations <- tabPanel("Correlations", value="panelCorr",
                            
                            # Row introduction ####################################################################################
                            fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0% 1.3%",
                                     h5(style="color:white","Use the correlation to find genes with an exercise response
                                     correlated to your gene of interest. The analysis includes all exercise and inactivity studies."
                                     ),
                            ),                        
                            
                            # Row App and plots ###################################################################################
                            fluidRow(style="margin:0px -15px 0px -15px;",
                                     column(2,
                                            style="padding:12px 10px 0px 1%;background-color: #5b768e",
                                            selectizeInput("genename_correlation", label=NULL, 
                                                           choices=NULL,
                                                           options=NULL)
                                     ),
                                     column(10,
                                            style="padding:12px 10px 0px 0;background-color: #5b768e",
                                            selectInput("selectgroup", label=NULL, 
                                                        choices = list("All"=3,
                                                                       "Protocol"=5, 
                                                                       "Muscle"=7, 
                                                                       "Sex"=8,
                                                                       "Age"=9,
                                                                       "Training"=10,
                                                                       "Obesity"=11,
                                                                       "Disease"=12),
                                                        selected = 3),
                                            #=======================================================================================================================
                                            fluidRow(style="background-color: white;padding:1% 0 5% 0",
                                                     column(5, DT::dataTableOutput("CorrTable")
                                                     ),
                                                     
                                                     column(6, 
                                                            plotOutput("CorrPlot", height="300px"),
                                                            textOutput("Corr_description"),
                                                            uiOutput ("Corr_link")
                                                     )
                                            )
                                     )
                            )
)