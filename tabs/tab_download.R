########################################################################################
tabDownloads <- tabPanel("Download", 
                               ########################################################################################
                               fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                        h5(style="color:white","Here are all the data from MetaMEx. Each file contains the summary statistics for each individual study.
                                           All studies were processed using limma, and the files contain the logFC, confidence interval, p values, FDR and n size. 
                                           For more details, feel free to contact us.")
                               ),
                               fluidRow(style="padding:0% 5% 10% 5%",
                                 column(4, 
                                        tags$br(),
                                        h2("Human data"),
                                        tags$br(),
                                        downloadButton("data_stats_human_AA", label = "Human - Acute Aerobic"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_AR", label = "Human - Acute Resistance"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_AH", label = "Human - Acute HIT"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_TA", label = "Human - Training Aerobic"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_TR", label = "Human - Training Resistance"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_TH", label = "Human - Training HIT"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_TC", label = "Human - Training Combined"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_human_IN", label = "Human - Inactivity")
                                        ),
                                 column(4,
                                        tags$br(),
                                        h2("Mouse data"),
                                        tags$br(),
                                        downloadButton("data_stats_mouse_AA", label = "Mouse - Acute Aerobic"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_mouse_TA", label = "Mouse - Training Aerobic"),
                                        tags$br(),
                                        tags$br(),
                                        downloadButton("data_stats_mouse_IN", label = "Mouse - Inactivity")
                                        )
                               )
)