tabMetaanalysis_human <- tabPanel("Human", value="panelApp", 
                                  
                                  # Row introduction ####################################################################################
                                  fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0% 1.3%",
                                           h5(style="color:white","Use the meta-analysis to obtain a forest plot of the expression of 
                                        your gene of interest in all available studies."
                                           )
                                  ),
                                  
                                  # Row App and plots ###################################################################################
                                  fluidRow(style="margin:0px -15px 0px -15px;",
                                           column(2,
                                                  style="padding:12px 10px 0 1%;background-color: #5b768e",
                                                  selectizeInput("genename_metaanalysis_human", label=NULL, 
                                                                 choices=NULL, 
                                                                 selected=NULL, options=NULL)
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
                                                                                                            plotOutput("plot_human_AA", height="700px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_AA", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['AA_names']],
                                                                                                                               names_human_datasets[['AA_names']],
                                                                                                                               inline = TRUE)
                                                                                                   ),
                                                                                                   tabPanel("Resistance",
                                                                                                            plotOutput("plot_human_AR", height="600px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_AR", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['AR_names']],
                                                                                                                               names_human_datasets[['AR_names']],
                                                                                                                               inline = TRUE)
                                                                                                   ),
                                                                                                   tabPanel("HIT",
                                                                                                            plotOutput("plot_human_AH", height="300px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_AH", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['AH_names']],
                                                                                                                               names_human_datasets[['AH_names']],
                                                                                                                               inline = TRUE)
                                                                                                   ),
                                                                                                   tabPanel("Timeline", 
                                                                                                            "The timeline plot is not reactive. All studies in healthy individuals are included by default, and differences (sex, age, protocol) are blocked for in the statistical model.",
                                                                                                            hr(),
                                                                                                            plotOutput("plot_human_timeline_acute", height="400px"),
                                                                                                            hr(),
                                                                                                            tableOutput("table_human_timeline_acute")
                                                                                                            
                                                                                                            
                                                                                                   )
                                                                                       )
                                                                                ),
                                                                                column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                       h3("Filter by", style="color:#011b2a"),
                                                                                       checkboxGroupInput("human_exercise_type", tags$b("Exercise type"), 
                                                                                                          choices=names_human_categories[['exercise_type_choice']],
                                                                                                          selected=names_human_categories[['exercise_type_choice']]),
                                                                                       checkboxInput('human_exercise_type_allnone', 'All/None', value=T), 
                                                                                       tags$br(),
                                                                                       checkboxGroupInput("human_acute_biopsy", tags$b("Time after exercise"), 
                                                                                                          choices=names_human_categories[['acute_biopsy_choice']],
                                                                                                          selected=names_human_categories[['acute_biopsy_choice']][1:6]), 
                                                                                       checkboxInput('human_acute_biopsy_allnone', 'All/None', value=T)
                                                                                ),
                                                                       ),
                                                              ),
                                                              
                                                              #= Tab Exercise Training =====================================================       
                                                              tabPanel("Exercise Training", value="panelAppTraining",
                                                                       fluidRow(style="background-color: white;padding:0",
                                                                                column(9, style="padding:0% 5% 2% 2%",
                                                                                       tabsetPanel(type="pills",
                                                                                                   tabPanel("Aerobic",
                                                                                                            plotOutput("plot_human_TA", height="600px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_TA", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['TA_names']],
                                                                                                                               names_human_datasets[['TA_names']],
                                                                                                                               inline = T)
                                                                                                   ),
                                                                                                   tabPanel("Resistance",
                                                                                                            plotOutput("plot_human_TR", height="650px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_TR", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['TR_names']],
                                                                                                                               names_human_datasets[['TR_names']],
                                                                                                                               inline = TRUE)
                                                                                                   ),
                                                                                                   tabPanel("HIT", 
                                                                                                            plotOutput("plot_human_TH", height="200px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_TH", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['TH_names']],
                                                                                                                               names_human_datasets[['TH_names']],
                                                                                                                               inline = TRUE)
                                                                                                   ),
                                                                                                   tabPanel("Combined", 
                                                                                                            plotOutput("plot_human_TC", height="300px"),
                                                                                                            hr(),
                                                                                                            checkboxGroupInput("studies_human_TC", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['TC_names']],
                                                                                                                               names_human_datasets[['TC_names']],
                                                                                                                               inline = TRUE)
                                                                                                   )
                                                                                       )
                                                                                ),
                                                                                column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                       h3("Filter by", style="color:#011b2a"),
                                                                                       checkboxGroupInput("human_training_duration", 
                                                                                                          tags$b("Training duration"), 
                                                                                                          choices=names_human_categories[['training_duration_choice']],
                                                                                                          selected=names_human_categories[['training_duration_choice']]), 
                                                                                       checkboxInput('human_training_duration_allnone', 'All/None', value=T),
                                                                                       tags$br(),
                                                                                       checkboxGroupInput("human_training_biopsy", 
                                                                                                          tags$b("Biopsy time"),
                                                                                                          choices=names_human_categories[['training_biopsy_choice']],
                                                                                                          selected=names_human_categories[['training_biopsy_choice']]), 
                                                                                       checkboxInput('human_training_biopsy_allnone', 'All/None', value=T)
                                                                                )
                                                                       )
                                                              ),
                                                              
                                                              #= Tab Inactivity =====================================================          
                                                              tabPanel("Inactivity", value="panelAppInactivity",
                                                                       fluidRow(style="background-color: white",
                                                                                column(9, style="padding:0% 5% 2% 2%;margin:0",
                                                                                       tabsetPanel(type="pills",
                                                                                                   tabPanel("Meta-analysis",
                                                                                                            plotOutput("plot_human_IN", height="350px"),
                                                                                                            hr(), 
                                                                                                            checkboxGroupInput("studies_human_IN", 
                                                                                                                               tags$b("Include/exclude specific datasets"), 
                                                                                                                               selected=names_human_datasets[['IN_names']], 
                                                                                                                               names_human_datasets[['IN_names']],
                                                                                                                               inline = TRUE)
                                                                                                   ),
                                                                                                   tabPanel("Timeline", 
                                                                                                            "The timeline plot is not reactive. All studies in healthy individuals are included by default, and differences (sex, age, protocol) are blocked for in the statistical model.",
                                                                                                            hr(),
                                                                                                            plotOutput("plot_human_timeline_inactivity", height="500px"),
                                                                                                            hr(),
                                                                                                            tableOutput("table_human_timeline_inactivity")
                                                                                                   )
                                                                                       )
                                                                                ),
                                                                                column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                       h3("Filter by", style="color:#011b2a"),
                                                                                       checkboxGroupInput("human_inactivity_protocol", 
                                                                                                          tags$b("Protocol"), 
                                                                                                          choices=names_human_categories[['inactivity_protocol_choice']],
                                                                                                          selected=names_human_categories[['inactivity_protocol_choice']]),
                                                                                       checkboxInput('human_inactivity_protocol_allnone', 'All/None', value=T),
                                                                                       tags$br(),
                                                                                       checkboxGroupInput("human_inactivity_duration", 
                                                                                                          tags$b("Duration"), 
                                                                                                          choices=names_human_categories[['inactivity_duration_choice']],
                                                                                                          selected=names_human_categories[['inactivity_duration_choice']]),
                                                                                       checkboxInput('human_inactivity_duration_allnone', 'All/None', value=T)
                                                                                )
                                                                       )
                                                              ),
                                                              
                                                              #= Tab correlations ===================================================== 
                                                              tabPanel("Correlations", 
                                                                       value="panelAppInactivity",
                                                                       fluidRow(style="background-color: white", 
                                                                                column(12, style="padding:2% 5% 2% 2%;margin:0",
                                                                                checkboxGroupInput("human_corr_protocol", 
                                                                                                   " ", 
                                                                                                   choices=correlations_categories_human[['corr_protocol_choice']],
                                                                                                   selected=correlations_categories_human[['corr_protocol_choice']],
                                                                                                   inline = TRUE),
                                                                                actionButton("updateCorrHuman", "Calculate", icon("sync")),
                                                                                tags$em("Click 'calculate' after changing selection criteria to update your analysis."),
                                                                                tags$br(), tags$br()
                                                                                )
                                                                       ),
                                                                       fluidRow(style="background-color: white",
                                                                                column(5, style="padding:0% 5% 2% 2%;margin:0",
                                                                                       DT::dataTableOutput("corr_table_human")
                                                                                ),
                                                                                
                                                                                column(6, 
                                                                                       plotOutput("corr_plot_human", height="300px"),
                                                                                       textOutput("corr_description_human"),
                                                                                       uiOutput ("corr_link_human")
                                                                                )
                                                                       )
                                                              ),
                                                              
                                                              #= Tab overview =====================================================        
                                                              tabPanel("Overview", 
                                                                       value="panelAppOverview",
                                                                       fluidRow(style="background-color: white", 
                                                                                column(10, style="padding:2% 5% 2% 2%;margin:0",
                                                                                       plotOutput("plot_overview") %>% withSpinner(color="#5b768e"),
                                                                                       tags$br(),
                                                                                       "This plot provides an overview of the meta-analysis for the selected gene.
                                                                                       The plot is reactive and updated based on the selection criteria used in all individual forest plots.
                                                                                       The data and meta-analysis calculation for the selected gene and population of interest can be downloaded here:",
                                                                                       tags$br(), tags$br(),
                                                                                       downloadButton("download_human_overview", label = "Download selected data"),
                                                                                       tags$br()
                                                                                )
                                                                       )
                                                              )
                                                  )
                                           )
                                                  
                                  ),
                                  
                                  # Row Select Population ###################################################################################
                                  tags$br(),
                                  fluidRow(style="position:center;background-color:#f4eae7;padding:0 0 1% 2%;margin:0 6% 5% 17%",
                                           h3("Customize your human population of interest", style="color:#c93f1e"),
                                           column(1, checkboxGroupInput("human_sex", tags$b("Sex"), 
                                                                        choices=names_human_categories[['sex_choice']],
                                                                        selected=names_human_categories[['sex_choice']]), #checkbox to select category
                                                  checkboxInput('human_sex_allnone', 'All/None', value=T)
                                           ), 
                                           column(1, checkboxGroupInput("human_age", tags$b("Age"),
                                                                        choices=names_human_categories[['age_choice']],
                                                                        selected=names_human_categories[['age_choice']]), #checkbox to select category
                                                  checkboxInput('human_age_allnone', 'All/None', value=T)
                                           ), 
                                           column(1, checkboxGroupInput("human_fitness", tags$b("Fitness"),
                                                                        choices=names_human_categories[['training_choice']],
                                                                        selected=names_human_categories[['training_choice']]), #checkbox to select category
                                                  checkboxInput('human_fitness_allnone', 'All/None', value=T)
                                           ), 
                                           column(2, checkboxGroupInput("human_weight", tags$b("Weight"), 
                                                                        choices=names_human_categories[['obesity_choice']],
                                                                        selected=names_human_categories[['obesity_choice']]), #checkbox to select category
                                                  checkboxInput('human_weight_allnone', 'All/None', value=T)
                                           ), 
                                           column(2, checkboxGroupInput("human_muscle", tags$b("Muscle"), 
                                                                        choices=names_human_categories[['muscle_choice']],
                                                                        selected=names_human_categories[['muscle_choice']]),
                                                  checkboxInput('human_muscle_allnone', 'All/None', value=T)
                                           ), 
                                           column(4, checkboxGroupInput("human_disease", tags$b("Health status"), 
                                                                        choices=names_human_categories[['disease_choice']],
                                                                        selected=names_human_categories[['disease_choice']]), #checkbox to select category
                                                  checkboxInput('human_disease_allnone', 'All/None', value=T)
                                           )
                                  )
)
