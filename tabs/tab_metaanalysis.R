tabMetaanalysis <- tabPanel("Meta-analysis", value="panelApp", 
                            
                            # Row introduction ####################################################################################
                            fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0% 1.3%",
                                     h5(style="color:white","Use the meta-analysis to obtain a forest plot of the expression of 
                                        your gene of interest in all available studies."
                                     ),
                            ),
                            
                            # Row App and plots ###################################################################################
                            fluidRow(style="margin:0px -15px 0px -15px;",
                                     column(2,
                                            style="padding:12px 10px 0 1%;background-color: #5b768e",
                                            selectizeInput("genename", label=NULL, 
                                                           choices=NULL, 
                                                           selected=NULL, options=NULL),
                                     ),
                                     column(10,
                                            style="padding:0 0 0 0;background-color: #5b768e",
                                            tabsetPanel(type="pills", id="inTabsetMeta", 
                                                        #= Tab Acute Exercise =====================================================        
                                                        tabPanel("Acute Exercise", value="panelAppAcute",
                                                                 fluidRow(style="background-color: white",
                                                                          column(9, style="padding:0% 5% 2% 2%;margin:0",
                                                                                 tabsetPanel(type="pills",
                                                                                             tabPanel("Aerobic", 
                                                                                                      plotOutput("AA_plot", height="500px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("AA_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['AA_names']], list_datasets[['AA_names']],
                                                                                                                         inline = TRUE)
                                                                                             ),
                                                                                             tabPanel("Resistance",
                                                                                                      plotOutput("AR_plot", height="550px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("AR_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['AR_names']], list_datasets[['AR_names']],
                                                                                                                         inline = TRUE)
                                                                                             ),
                                                                                             tabPanel("HIT",
                                                                                                      plotOutput("AH_plot", height="300px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("AH_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['AH_names']], list_datasets[['AH_names']],
                                                                                                                         inline = TRUE)
                                                                                             )
                                                                                 )
                                                                          ),
                                                                          column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                 h3("Filter by", style="color:#011b2a"),
                                                                                 checkboxGroupInput("exercise_type", tags$b("Exercise type"), 
                                                                                                    choices=list_categories[['exercise_type_choice']],
                                                                                                    selected=list_categories[['exercise_type_choice']]),
                                                                                 checkboxInput('exercise_type_allnone', 'All/None', value=T), 
                                                                                 tags$br(),
                                                                                 checkboxGroupInput("acute_biopsy", tags$b("Biopsy collection"), 
                                                                                                    choices=list_categories[['acute_biopsy_choice']],
                                                                                                    selected=list_categories[['acute_biopsy_choice']][1:6]), 
                                                                                 checkboxInput('acute_biopsy_allnone', 'All/None', value=T),
                                                                          ),
                                                                 ),
                                                        ),
                                                        
                                                        #= Tab Exercise Training =====================================================       
                                                        tabPanel("Exercise Training", value="panelAppTraining",
                                                                 fluidRow(style="background-color: white;padding:0",
                                                                          column(9, style="padding:0% 5% 2% 2%",
                                                                                 tabsetPanel(type="pills",
                                                                                             tabPanel("Aerobic",
                                                                                                      plotOutput("TA_plot", height="600px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("TA_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['TA_names']], list_datasets[['TA_names']],
                                                                                                                         inline = T)
                                                                                             ),
                                                                                             tabPanel("Resistance",
                                                                                                      plotOutput("TR_plot", height="650px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("TR_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['TR_names']], list_datasets[['TR_names']],
                                                                                                                         inline = TRUE)
                                                                                             ),
                                                                                             tabPanel("HIT", 
                                                                                                      plotOutput("TH_plot", height="200px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("TH_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['TH_names']], list_datasets[['TH_names']],
                                                                                                                         inline = TRUE)
                                                                                             ),
                                                                                             tabPanel("Combined", 
                                                                                                      plotOutput("TC_plot", height="300px"),
                                                                                                      hr(),
                                                                                                      checkboxGroupInput("TC_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                                         selected=list_datasets[['TC_names']], list_datasets[['TC_names']],
                                                                                                                         inline = TRUE)
                                                                                             )
                                                                                 )
                                                                          ),
                                                                          column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                 h3("Filter by", style="color:#011b2a"),
                                                                                 checkboxGroupInput("training_duration", tags$b("Training duration"), 
                                                                                                    choices=list_categories[['training_duration_choice']],
                                                                                                    selected=list_categories[['training_duration_choice']]), 
                                                                                 checkboxInput('training_duration_allnone', 'All/None', value=T),
                                                                                 tags$br(),
                                                                                 checkboxGroupInput("training_biopsy", tags$b("Biopsy time"),
                                                                                                    choices=list_categories[['training_biopsy_choice']],
                                                                                                    selected=list_categories[['training_biopsy_choice']]), 
                                                                                 checkboxInput('training_biopsy_allnone', 'All/None', value=T),
                                                                          )
                                                                 )
                                                        ),
                                                        
                                                        #= Tab Inactivity =====================================================          
                                                        tabPanel("Inactivity", value="panelAppInactivity",
                                                                 fluidRow(style="background-color: white;padding:0",
                                                                          column(9, style="padding:2% 5% 2% 2%",
                                                                                 plotOutput("IN_plot", height="400px"),
                                                                                 hr(), 
                                                                                 checkboxGroupInput("IN_studies", tags$b("Include/exclude specific datasets"), 
                                                                                                    selected=list_datasets[['IN_names']], list_datasets[['IN_names']],
                                                                                                    inline = TRUE),
                                                                                 
                                                                          ),
                                                                          column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                 h3("Filter by", style="color:#011b2a"),
                                                                                 checkboxGroupInput("inactivity_protocol", tags$b("Protocol"), 
                                                                                                    choices=list_categories[['inactivity_protocol_choice']],
                                                                                                    selected=list_categories[['inactivity_protocol_choice']]),
                                                                                 checkboxInput('inactivity_protocol_allnone', 'All/None', value=T),
                                                                                 tags$br(),
                                                                                 checkboxGroupInput("inactivity_duration", tags$b("Duration"), 
                                                                                                    choices=list_categories[['inactivity_duration_choice']],
                                                                                                    selected=list_categories[['inactivity_duration_choice']]),
                                                                                 checkboxInput('inactivity_duration_allnone', 'All/None', value=T)
                                                                          ),
                                                                 )
                                                        )
                                            ),
                                            
                                     ),
                            ),
                            
                            # Row Select Population ###################################################################################
                            tags$br(),
                            fluidRow(style="position:center;background-color:#f4eae7;padding:0 0 1% 2%;margin:0 6% 5% 17%",
                                     h3("Customize your population of interest", style="color:#c93f1e"),
                                     column(1, checkboxGroupInput("sex", tags$b("Sex"),
                                                                  choices=list_categories[['sex_choice']],
                                                                  selected=list_categories[['sex_choice']]), #checkbox to select category
                                            checkboxInput('sex_allnone', 'All/None', value=T)
                                     ), 
                                     column(1, checkboxGroupInput("age", tags$b("Age"),
                                                                  choices=list_categories[['age_choice']],
                                                                  selected=list_categories[['age_choice']]), #checkbox to select category
                                            checkboxInput('age_allnone', 'All/None', value=T)
                                     ), 
                                     column(1, checkboxGroupInput("fitness", tags$b("Fitness"),
                                                                  choices=list_categories[['training_choice']],
                                                                  selected=list_categories[['training_choice']]), #checkbox to select category
                                            checkboxInput('fitness_allnone', 'All/None', value=T)
                                     ), 
                                     column(2, checkboxGroupInput("weight", tags$b("Weight"), 
                                                                  choices=list_categories[['obesity_choice']],
                                                                  selected=c("LEA", "OWE")), #checkbox to select category
                                            checkboxInput('weight_allnone', 'All/None', value=T)
                                     ), 
                                     column(2, checkboxGroupInput("muscle", tags$b("Muscle"), 
                                                                  choices=list_categories[['muscle_choice']],
                                                                  selected=list_categories[['muscle_choice']]
                                     ),
                                     checkboxInput('muscle_allnone', 'All/None', value=T)
                                     ), 
                                     column(4, checkboxGroupInput("disease", tags$b("Health status"), 
                                                                  choices=list_categories[['disease_choice']],
                                                                  selected=c("HLY", "IGT")), #checkbox to select category
                                            checkboxInput('disease_allnone', 'All/None', value=T)
                                     )
                            )
)
