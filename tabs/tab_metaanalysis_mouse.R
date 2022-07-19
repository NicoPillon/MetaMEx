tabMetaanalysis_mouse <- tabPanel("Mouse", value="panelAppMouse", 
                                  
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
                                                  selectizeInput("genename_metaanalysis_mouse", label=NULL, 
                                                                 choices=NULL, 
                                                                 selected=NULL, options=NULL)
                                           ),
                                           column(10,
                                                  style="padding:0 0 0 0;background-color: #5b768e",
                                                  tabsetPanel(type="pills", id="inTabsetMeta", 
                                                              #= Tab Acute Exercise =====================================================        
                                                              tabPanel("Acute Exercise", value="panelAppAcute",
                                                                       fluidRow(style="background-color: white",
                                                                                column(9, style="padding:2% 5% 2% 2%;margin:0",
                                                                                       plotOutput("plot_mouse_AA", height="500px"),
                                                                                       hr(),
                                                                                       checkboxGroupInput("studies_mouse_AA", 
                                                                                                          tags$b("Include/exclude specific datasets"), 
                                                                                                          selected=names_mouse_datasets[['AA_names']],
                                                                                                          names_mouse_datasets[['AA_names']],
                                                                                                          inline = TRUE)
                                                                                ),
                                                                                column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                       h3("Filter by", style="color:#011b2a"),
                                                                                       checkboxGroupInput("mouse_exercise_type", tags$b("Exercise type"), 
                                                                                                          choices=names_mouse_categories[['exercise_type_choice']],
                                                                                                          selected=names_mouse_categories[['exercise_type_choice']]),
                                                                                       checkboxInput('mouse_exercise_type_allnone', 'All/None', value=T), 
                                                                                       tags$br(),
                                                                                       checkboxGroupInput("mouse_acute_biopsy", tags$b("Time after exercise"), 
                                                                                                          choices=names_mouse_categories[['acute_biopsy_choice']],
                                                                                                          selected=names_mouse_categories[['acute_biopsy_choice']][1:6]), 
                                                                                       checkboxInput('mouse_acute_biopsy_allnone', 'All/None', value=T)
                                                                                ),
                                                                       ),
                                                              ),
                                                              
                                                              #= Tab Exercise Training =====================================================       
                                                              tabPanel("Exercise Training", value="panelAppTraining",
                                                                       fluidRow(style="background-color: white;padding:0",
                                                                                column(9, style="padding:2% 5% 2% 2%",
                                                                                       plotOutput("plot_mouse_TA", height="500px"),
                                                                                       hr(),
                                                                                       checkboxGroupInput("studies_mouse_TA", 
                                                                                                          tags$b("Include/exclude specific datasets"),
                                                                                                          selected=names_mouse_datasets[['TA_names']],
                                                                                                          names_mouse_datasets[['TA_names']],
                                                                                                          inline = T)
                                                                                ),
                                                                                column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                       h3("Filter by", style="color:#011b2a"),
                                                                                       checkboxGroupInput("mouse_training_protocol", 
                                                                                                          tags$b("Protocol"), 
                                                                                                          choices=names_mouse_categories[['training_protocol_choice']],
                                                                                                          selected=names_mouse_categories[['training_protocol_choice']]),
                                                                                       checkboxInput('mouse_training_protocol_allnone', 'All/None', value=T),
                                                                                       checkboxGroupInput("mouse_training_duration", 
                                                                                                          tags$b("Training duration"), 
                                                                                                          choices=names_mouse_categories[['training_duration_choice']],
                                                                                                          selected=names_mouse_categories[['training_duration_choice']]), 
                                                                                       checkboxInput('mouse_training_duration_allnone', 'All/None', value=T)
                                                                                )
                                                                       )
                                                              ),
                                                              
                                                              #= Tab Inactivity =====================================================          
                                                              tabPanel("Inactivity", value="panelAppInactivity",
                                                                       fluidRow(style="background-color: white;padding:0",
                                                                                column(9, style="padding:2% 5% 2% 2%",
                                                                                       plotOutput("plot_mouse_IN", height="400px"),
                                                                                       hr(), 
                                                                                       checkboxGroupInput("studies_mouse_IN", 
                                                                                                          tags$b("Include/exclude specific datasets"), 
                                                                                                          selected=names_mouse_datasets[['IN_names']], 
                                                                                                          names_mouse_datasets[['IN_names']],
                                                                                                          inline = TRUE)
                                                                                ),
                                                                                column(2, style="background-color:#eaf1f7;margin-top:60px;padding:0 1% 1% 2%",
                                                                                       h3("Filter by", style="color:#011b2a"),
                                                                                       checkboxGroupInput("mouse_inactivity_protocol", 
                                                                                                          tags$b("Protocol"), 
                                                                                                          choices=names_mouse_categories[['inactivity_protocol_choice']],
                                                                                                          selected=names_mouse_categories[['inactivity_protocol_choice']]),
                                                                                       checkboxInput('mouse_inactivity_protocol_allnone', 'All/None', value=T),
                                                                                       tags$br(),
                                                                                       checkboxGroupInput("mouse_inactivity_duration", 
                                                                                                          tags$b("Duration"), 
                                                                                                          choices=names_mouse_categories[['inactivity_duration_choice']],
                                                                                                          selected=names_mouse_categories[['inactivity_duration_choice']]),
                                                                                       checkboxInput('mouse_inactivity_duration_allnone', 'All/None', value=T)
                                                                                )
                                                                       )
                                                              )
                                                  )
                                                  
                                           )
                                  ),
                                  
                                  # Row Select Population ###################################################################################
                                  tags$br(),
                                  fluidRow(style="position:center;background-color:#f4eae7;padding:0 0 1% 2%;margin:0 6% 5% 17%",
                                           h3("Customize your mouse population of interest", style="color:#c93f1e"),
                                           column(2, checkboxGroupInput("mouse_sex", tags$b("Sex"),
                                                                        choices=names_mouse_categories[['sex_choice']],
                                                                        selected=names_mouse_categories[['sex_choice']]), #checkbox to select category
                                                  checkboxInput('mouse_sex_allnone', 'All/None', value=T)
                                           ), 
                                           column(2, checkboxGroupInput("mouse_age", tags$b("Age"),
                                                                        choices=names_mouse_categories[['age_choice']],
                                                                        selected=names_mouse_categories[['age_choice']]), #checkbox to select category
                                                  checkboxInput('mouse_age_allnone', 'All/None', value=T)
                                           ), 

                                           column(2, checkboxGroupInput("mouse_muscle", tags$b("Muscle"), 
                                                                        choices=names_mouse_categories[['muscle_choice']],
                                                                        selected=names_mouse_categories[['muscle_choice']]
                                           ),
                                           checkboxInput('mouse_muscle_allnone', 'All/None', value=T)
                                           ), 
                                           column(4, checkboxGroupInput("mouse_disease", tags$b("Mouse model"), 
                                                                        choices=names_mouse_categories[['disease_choice']],
                                                                        selected=names_mouse_categories[['disease_choice']]), #checkbox to select category
                                                  checkboxInput('mouse_disease_allnone', 'All/None', value=T)
                                           )
                                  )
)
