########################################################################################
tabAcknowledgments <- tabPanel("Acknowledgments", 
                               ########################################################################################
                               fluidRow(style="background-color: #5b768e;margin:-18px -15px 0px -15px;padding:0.5% 1.5% 0.5% 1.3%",
                                        h5(style="color:white","Here are the people and organizations who supported the 
                                           development of MetaMEx.")
                               ),
                               fluidRow(style="padding:0% 5% 10% 5%",
                                        includeMarkdown("annexes/acknowledgments.md")
                               )
)