tabDatasets <- navbarMenu("Datasets",
                          ########################################################################################
                          tabPanel("Human Annotation", 
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the legend used for the annotation of studies.")
                                   ),
                                   fluidRow(style="font-size: 80%;padding:0% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_human_legend"))
                          ),         
                          tabPanel("Human Acute Studies", 
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the references for all studies of acute exercise included in MetaMEx.")
                                   ),
                                   fluidRow(style="font-size: 70%;padding:1% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_human_acute"))
                          ),    
                          tabPanel("Human Training Studies", 
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the references for all studies of exercise training included in MetaMEx.")
                                   ),
                                   fluidRow(style="font-size: 70%;padding:1% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_human_training"))
                          ),    
                          tabPanel("Human Inactivity Studies", 
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the references for all studies of inactivity included in MetaMEx.")
                                   ),
                                   fluidRow(style="font-size: 70%;padding:1% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_human_inactivity"))
                          ),
                          tabPanel("Mouse Annotation",
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the legend used for the annotation of studies.")
                                   ),
                                   fluidRow(style="font-size: 80%;padding:0% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_mouse_legend"))
                          ),
                          tabPanel("Mouse Acute Studies",
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the references for all studies of acute exercise included in MetaMEx.")
                                   ),
                                   fluidRow(style="font-size: 70%;padding:1% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_mouse_acute"))
                          ),
                          tabPanel("Mouse Training Studies",
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the references for all studies of exercise training included in MetaMEx.")
                                   ),
                                   fluidRow(style="font-size: 70%;padding:1% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_mouse_training"))
                          ),
                          tabPanel("Mouse Inactivity Studies",
                                   fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                            h5(style="color:white","Find the references for all studies of inactivity included in MetaMEx.")
                                   ),
                                   fluidRow(style="font-size: 70%;padding:1% 1% 10% 1%",
                                            DT::dataTableOutput("reftable_mouse_inactivity"))
                          )
)