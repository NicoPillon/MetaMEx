####################################################################################################################
# Define server logic ##############################################################################################
server <- function(input, output, session) {
  
  #=======================================================================================
  # Load data
  #=======================================================================================
  withProgress(message = 'Loading data', value = 1, max=10, {
    # Data for forest plots
    incProgress(1, detail="Acute aerobic exercise studies")
    AA_stats <- data.frame(read_feather("data/merged_stats/acute_aerobic.feather"), row.names=1)
    incProgress(1, detail="Acute HIT exercise studies")
    AH_stats <- data.frame(read_feather("data/merged_stats/acute_hit.feather"), row.names=1)
    incProgress(1, detail="Acute resistance exercise studies")
    AR_stats <- data.frame(read_feather("data/merged_stats/acute_resistance.feather"), row.names=1)
    incProgress(1, detail="Aerobic training studies")
    TA_stats <- data.frame(read_feather("data/merged_stats/training_aerobic.feather"), row.names=1)
    incProgress(1, detail="Resistance training studies")
    TR_stats <- data.frame(read_feather("data/merged_stats/training_resistance.feather"), row.names=1)
    incProgress(1, detail="Combined training studies")
    TC_stats <- data.frame(read_feather("data/merged_stats/training_combined.feather"), row.names=1)
    incProgress(1, detail="HIT training studies")
    TH_stats <- data.frame(read_feather("data/merged_stats/training_hit.feather"), row.names=1)
    incProgress(1, detail="Inactivity studies")
    IN_stats <- data.frame(read_feather("data/merged_stats/inactivity.feather"), row.names=1)
    
    # Data for timeline
    incProgress(1, detail="Timeline analysis")
    timeline_acute_data <- data.frame(read_feather("data/timeline/timeline_acute_data.feather"), row.names=1)
    timeline_acute_stats <- data.frame(read_feather("data/timeline/timeline_acute_stats.feather"), row.names=1)
    
    timeline_inactivity_data <- data.frame(read_feather("data/timeline/timeline_inactivity_data.feather"), row.names=1)
    timeline_inactivity_stats <- data.frame(read_feather("data/timeline/timeline_inactivity_stats.feather"), row.names=1)
    
    timeline_genes <- unique(na.omit(c(rownames(timeline_acute_data), 
                               rownames(timeline_inactivity_data))))
    
    # Data for correlations
    incProgress(1, detail="Correlation tables")
    correlations_data <- readRDS("data/correlations/correlations_data.Rds")
    correlations_genes <- rownames(correlations_data)
    correlations_refseq <- readRDS("data/correlations/correlations_refseq.Rds")
    
    # Data for reference tables
    annotation <- readRDS("data/annotation/reftable_legend.Rds") # Load the table describing the legend of the tables
    StudiesAcute <- readRDS("data/annotation/reftable_acute.Rds") # Load the table describing the legend of the tables
    StudiesTraining <- readRDS("data/annotation/reftable_training.Rds") # Load the table describing the legend of the tables
    StudiesInactivity <- readRDS("data/annotation/reftable_inactivity.Rds") # Load the table describing the legend of the tables
  })
  
  #=======================================================================================
  # Synchronize genenames according to home page
  #=======================================================================================
  updateSelectizeInput(session, 'genename_home', choices=list_genes, server=TRUE, selected='NR4A3', options=NULL)
  observeEvent(input$genename_home, { updateSelectizeInput(session, 'genename_metaanalysis', choices=list_genes, server=TRUE, selected=input$genename_home, options=NULL) })
  observeEvent(input$genename_home, { updateSelectizeInput(session, 'genename_timeline', choices=list_genes, server=TRUE, selected=input$genename_home , options=NULL) })
  observeEvent(input$genename_home, { updateSelectizeInput(session, 'genename_correlation', choices=list_genes, server=TRUE, selected=input$genename_home , options=NULL) })
  
  #update all if gene is changed on the meta-analysis tab
  observeEvent(input$genename_metaanalysis, { updateSelectizeInput(session, "genename_timeline", selected=input$genename_metaanalysis) })
  observeEvent(input$genename_metaanalysis, { updateSelectizeInput(session, 'genename_correlation', selected=input$genename_metaanalysis) })
  

  #=======================================================================================
  # Observe the clicks on buttons on home page and transfer to tab
  #=======================================================================================
  observeEvent(input$jumpToAppAcute, {updateTabsetPanel(session, "inTabset", selected="panelApp")
    updateTabsetPanel(session, "inTabsetMeta", selected="panelAppAcute")})
  observeEvent(input$jumpToAppTraining, {updateTabsetPanel(session, "inTabset", selected="panelApp") 
    updateTabsetPanel(session, "inTabsetMeta", selected="panelAppTraining") })
  observeEvent(input$jumpToAppInactivity, {updateTabsetPanel(session, "inTabset", selected="panelApp")
    updateTabsetPanel(session, "inTabsetMeta", selected="panelAppInactivity") })
  observeEvent(input$jumpToHelp, {updateTabsetPanel(session, "inTabset", selected="Tutorial") })
  

  #=======================================================================================
  #Make all checkboxes selected by default - necessary for the select all(none) button to work
  #=======================================================================================
  observe({ updateCheckboxGroupInput(session, 'muscle', 
                                     choices = list_categories[['muscle_choice']], 
                                     selected = if (input$muscle_allnone) list_categories[['muscle_choice']])})
  observe({ updateCheckboxGroupInput(session, 'sex', 
                                     choices = list_categories[['sex_choice']], 
                                     selected = if (input$sex_allnone) list_categories[['sex_choice']])})
  observe({ updateCheckboxGroupInput(session, 'age', 
                                     choices = list_categories[['age_choice']], 
                                     selected = if (input$age_allnone) list_categories[['age_choice']])})
  observe({ updateCheckboxGroupInput(session, 'fitness',  
                                     choices = list_categories[['training_choice']], 
                                     selected = if (input$fitness_allnone) list_categories[['training_choice']])})
  observe({ updateCheckboxGroupInput(session, 'weight',             
                                     choices = list_categories[['obesity_choice']], 
                                     selected = if (input$weight_allnone) list_categories[['obesity_choice']])})
  observe({ updateCheckboxGroupInput(session, 'disease',             
                                     choices = list_categories[['disease_choice']], 
                                     selected = if (input$disease_allnone) list_categories[['disease_choice']])})
  
  observe({ updateCheckboxGroupInput(session, 'exercise_type',        
                                     choices = list_categories[['exercise_type_choice']], 
                                     selected = if (input$exercise_type_allnone) list_categories[['exercise_type_choice']])})
  observe({ updateCheckboxGroupInput(session, 'acute_biopsy',              
                                     choices = list_categories[['acute_biopsy_choice']], 
                                     selected = if (input$acute_biopsy_allnone) list_categories[['acute_biopsy_choice']])})
  
  observe({ updateCheckboxGroupInput(session, 'training_duration',        
                                     choices = list_categories[['training_duration_choice']], 
                                     selected = if (input$training_duration_allnone) list_categories[['training_duration_choice']])})
  observe({ updateCheckboxGroupInput(session, 'training_biopsy',        
                                     choices = list_categories[['training_biopsy_choice']], 
                                     selected = if (input$training_biopsy_allnone) list_categories[['training_biopsy_choice']])})
  
  observe({ updateCheckboxGroupInput(session, 'inactivity_duration', choices=list_categories[['inactivity_duration_choice']],
                                     selected = if (input$inactivity_duration_allnone) list_categories[['inactivity_duration_choice']])})
  observe({ updateCheckboxGroupInput(session, 'inactivity_protocol', choices=list_categories[['inactivity_protocol_choice']],
                                     selected = if (input$inactivity_protocol_allnone) list_categories[['inactivity_protocol_choice']])})
  
  
  #=======================================================================================
  # Make annotation tables for legend 
  #=======================================================================================
  output$Annotation <- DT::renderDataTable(escape = FALSE, rownames = FALSE, options=list(paging = FALSE), { annotation })
  output$StudiesAcute <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { StudiesAcute } )
  output$StudiesTraining <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { StudiesTraining })
  output$StudiesInactivity <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { StudiesInactivity })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Acute Aerobic forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  AA_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- AA_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease,
                                   Biopsy %in% input$acute_biopsy,
                                   Exercisetype %in% input$exercise_type)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$AA_studies)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$AA_plot <- renderPlot({ 
    #show progress
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    #call module to make forest plot
    finalplot <- ModuleForestPlot(AA_data(), paste(input$genename_metaanalysis),
                                  "#9D6807", 
                                  "acute aerobic exercise studies")
    #display forest plot
    return(finalplot)
    })
 
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Acute Resistance forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  AR_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- AR_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease,
                                   Biopsy %in% input$acute_biopsy,
                                   Exercisetype %in% input$exercise_type)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$AR_studies)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$AR_plot <- renderPlot({
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(AR_data(), paste(input$genename_metaanalysis),
                                  "#4C5C33", 
                                  "acute resistance exercise studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Acute HIT forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  AH_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- AH_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease,
                                   Biopsy %in% input$acute_biopsy,
                                   Exercisetype %in% input$exercise_type)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$AH_studies)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$AH_plot <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(AH_data(), paste(input$genename_metaanalysis),
                                  "#60394E", 
                                  "acute HIT exercise studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Training Aerobic forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  TA_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- TA_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$TA_studies,
                                   Biopsy %in% input$training_biopsy,
                                   Duration %in% input$training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  }) 
  
  output$TA_plot <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(TA_data(), paste(input$genename_metaanalysis),
                                  "#9D6807", 
                                  "aerobic training studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Training Resistance forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  TR_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- TR_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$TR_studies,
                                   Biopsy %in% input$training_biopsy,
                                   Duration %in% input$training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$TR_plot <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(TR_data(), paste(input$genename_metaanalysis),
                                  "#4C5C33", 
                                  "resistance training studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Training Combined forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  TC_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- TC_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$TC_studies,
                                   Biopsy %in% input$training_biopsy,
                                   Duration %in% input$training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$TC_plot <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(TC_data(), paste(input$genename_metaanalysis),
                                  "#58585A", 
                                  "combined training studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Training HIT forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  TH_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- TH_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$TH_studies,
                                   Biopsy %in% input$training_biopsy,
                                   Duration %in% input$training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$TH_plot <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(TH_data(), paste(input$genename_metaanalysis),
                                  "#60394E", 
                                  "HIT training studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Inactivity forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  IN_data <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- IN_stats[input$genename_metaanalysis,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$muscle, 
                                   Sex %in% input$sex, 
                                   Age %in% input$age, 
                                   Training %in% input$fitness,
                                   Obesity %in% input$weight,
                                   Disease %in% input$disease)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$IN_studies,
                                   Exercisetype %in% input$inactivity_protocol,
                                   Biopsy %in% input$inactivity_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata)
    }, error=function(e) NULL)
  })
  
  output$IN_plot <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(IN_data(), paste(input$genename_metaanalysis),
                                  "#3E3328", 
                                  "inactivity studies")
    finalplot
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Acute exercise timeline plot and table
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  output$TimelineAcutePlot      <- renderPlot({
    #show progress bar
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    genename <- toupper(input$genename_timeline)
    res  <- timeline_acute_data
    mydata <- data.frame(cessation=factor(colnames(res), levels=c('pre', '0_1', '2_3', '4_6', '24', '48', '72')),
                         logFC=as.numeric(res[genename,])) 
    validate(need(!all(is.na(mydata[,2])),  "No data found for this gene"))
    active <- ggplot(mydata, aes(x=cessation, y=logFC, fill=cessation)) + 
      theme_bw() + theme +
      geom_hline(yintercept=0, color="gray50", linetype="dashed") +
      geom_boxplot() +
      labs(x="Time after exercise (h)",
           y=paste(genename, ", log2(fold-change)", sep="")) + 
      scale_fill_brewer(palette="Blues", direction=1) +
      scale_x_discrete(breaks=levels(mydata$cessation),
                       labels=c('Pre', '0-1', '2-3', '4-6', '24', '48', '72'))
    active
  })
  
  output$TimelineAcuteTable <- renderTable(rownames = TRUE, align='c', { 
    #validate(need(input$genename_timeline!="",  "Start by selecting a gene in the list of official gene names")) 
    genename <- toupper(input$genename_timeline)
    res  <- timeline_acute_stats[genename,]
    stats <- data.frame(p.value=t(res[grepl('P.Value', colnames(res))]),
                        FDR=t(res[grepl('adj.P.Val', colnames(res))]))
    validate(need(!all(is.na(stats[,2])),  "No data found for this gene"))
    colnames(stats) <- c('p.value', 'FDR')
    ANOVA <- res[grepl('F_', colnames(res))]
    names(ANOVA) <- c('p.value', 'FDR')
    stats <- rbind(ANOVA, stats)
    stats$significance <- ''
    stats$significance[stats$FDR < 0.05] <- "*"
    stats$significance[stats$FDR < 0.01] <- "**"
    stats$significance[stats$FDR < 0.001] <- "***"
    stats$p.value <- scientific(stats$p.value, 1)
    stats$FDR <- scientific(stats$FDR, 1)
    rownames(stats) <- c('ANOVA',
                         'T-test 0-1h vs Pre', 'T-test 2-3h vs Pre',
                         'T-test 4-6h vs Pre', 'T-test 24h vs Pre',
                         'T-test 48h vs Pre', 'T-test 72h vs Pre')
    return(stats)
  })
  
  
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  # Inactivity timeline plot and table
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  output$TimelineInactivityPlot      <- renderPlot({
    #show progress bar
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    genename <- toupper(input$genename_timeline)
    res  <- timeline_inactivity_data
    mydata <- data.frame(cessation=factor(colnames(res)),
                         logFC=as.numeric(res[genename,])) 
    validate(need(!all(is.na(mydata[,2])),  "No data found for this gene"))
    mydata$cessation <- factor(mydata$cessation, levels=c('PRE', '<1', '1-2', '>2'))
    active <- ggplot(mydata, aes(x=cessation, y=logFC, fill=cessation)) + 
      theme_bw() + theme +
      geom_hline(yintercept=0, color="gray50", linetype="dashed") +
      geom_boxplot() +
      labs(x="Inactivity duration (weeks)",
           y=paste(genename, ", log2(fold-change)", sep="")) + 
      scale_fill_brewer(palette="Blues", direction=1) +
      scale_x_discrete(breaks=levels(mydata$cessation),
                       labels=c('Pre', '<1', '1-2', '>2'))
    active
  })
  
  output$TimelineInactivityTable <- renderTable(rownames = TRUE, align='c', { 
    validate(need(input$genename_timeline!="",  "No data found for this gene")) 
    genename <- toupper(input$genename_timeline)
    res  <- timeline_inactivity_stats[genename,]
    stats <- data.frame(p.value=t(res[grepl('P.Value', colnames(res))]),
                        FDR=t(res[grepl('adj.P.Val', colnames(res))]))
    validate(need(!all(is.na(stats[,2])),  "No data found for this gene"))
    colnames(stats) <- c('p.value', 'FDR')
    ANOVA <- res[grepl('F_', colnames(res))]
    names(ANOVA) <- c('p.value', 'FDR')
    stats <- rbind(ANOVA, stats)
    stats$significance <- ''
    stats$significance[stats$FDR < 0.05] <- "*"
    stats$significance[stats$FDR < 0.01] <- "**"
    stats$significance[stats$FDR < 0.001] <- "***"
    stats$p.value <- scientific(stats$p.value, 1)
    stats$FDR <- scientific(stats$FDR, 1)
    rownames(stats) <- c('ANOVA',
                         'T-test <1 week vs Pre',
                         'T-test 1-2 weeks vs Pre',
                         'T-test >3 weeks vs Pre')
    return(stats)
  })
  
  
  
  #=======================================================================================
  # Make correlation table
  #=======================================================================================
  
  Corr_stats <- reactive({
    validate(need(isTRUE(input$genename_correlation %in% correlations_genes),
                  "No correlation data for this gene"))
        tryCatch({
      withProgress(message = 'Calculating', value = 0, max=9, {
        selectedata <- correlations_data
        geneofinterest <- as.numeric(selectedata[toupper(input$genename_correlation),])
        estimate <- function(x) cor.test(x, geneofinterest, method="spearman", exact=F)$estimate
        p.value  <- function(x) cor.test(x, geneofinterest, method="spearman", exact=F)$p.value
        
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r1 <- apply(selectedata[1:1000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r2 <- apply(selectedata[1001:2000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r3 <- apply(selectedata[2001:3000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r4 <- apply(selectedata[3001:4000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r5 <- apply(selectedata[4001:5000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r6 <- apply(selectedata[5001:6000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r7 <- apply(selectedata[6001:7000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r8 <- apply(selectedata[7001:8000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r9 <- apply(selectedata[8001:9000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r10 <- apply(selectedata[9001:10000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r11 <- apply(selectedata[10001:11000,], 1, estimate)
        incProgress(0.4, detail="Spearman coefficients")
        Spearman.r12 <- apply(selectedata[11001:nrow(selectedata),], 1, estimate)
        Spearman.r <- c(Spearman.r1, Spearman.r2, Spearman.r3, Spearman.r4,
                        Spearman.r5, Spearman.r6, Spearman.r7, Spearman.r8,
                        Spearman.r9, Spearman.r10, Spearman.r11, Spearman.r12)
        
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p1 <- apply(selectedata[1:1000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p2 <- apply(selectedata[1001:2000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p3 <- apply(selectedata[2001:3000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p4 <- apply(selectedata[3001:4000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p5 <- apply(selectedata[4001:5000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p6 <- apply(selectedata[5001:6000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p7 <- apply(selectedata[6001:7000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p8 <- apply(selectedata[7001:8000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p9 <- apply(selectedata[8001:9000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p10 <- apply(selectedata[9001:10000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p11 <- apply(selectedata[10001:11000,], 1, p.value)
        incProgress(0.4, detail="Spearman statistics")
        Spearman.p12 <- apply(selectedata[11001:nrow(selectedata),], 1, p.value)
        Spearman.p <- c(Spearman.p1, Spearman.p2, Spearman.p3, Spearman.p4,
                        Spearman.p5, Spearman.p6, Spearman.p7, Spearman.p8,
                        Spearman.p9, Spearman.p10, Spearman.p11, Spearman.p12)
        
        incProgress(0.4, detail="Making table")
        Spearman.FDR <- p.adjust(Spearman.p, method="bonferroni")
        Spearman.r <- round(Spearman.r, digits=3)
        Spearman.p <- signif(Spearman.p, digits=2)
        Spearman.FDR <- signif(Spearman.FDR, digits=2)
        coeff <- data.frame(Spearman.r, Spearman.FDR)
        colnames(coeff) <- c("Spearman.r", "FDR")
        coeff <- coeff[order(coeff$FDR),]
        
        return(coeff)
      })
    }, error=function(e) NULL)
  })
  
  output$CorrTable <- DT::renderDataTable(escape = FALSE, 
                                          rownames = T, 
                                          selection = "single", {
                                            validate(need(!is.null(Corr_stats()),   "Start by selecting a gene in the list of official gene names"))

                                            Corr_stats()
                                          })
  
  
  #=======================================================================================
  # Make correlation plot
  #=======================================================================================
  output$CorrPlot      <- renderPlot({ 
    validate(need(!is.null(Corr_stats()),     " "))
    validate(need(input$CorrTable_rows_selected!="",  "Click on a gene in the table to display the correlation")) 
    
    Gene1 <- correlations_data[toupper(input$genename_correlation),]
    Gene2 <- Corr_stats()
    Gene2 <- rownames(Gene2[input$CorrTable_rows_selected,])
    Gene2 <- correlations_data[Gene2,]
    data  <- data.frame(t(Gene1), t(Gene2))
    data <- cbind(data, str_split_fixed(rownames(data), "_", 12))
    colnames(data) <- c("Gene1", "Gene2", "logFC", "GEO",
                        "Protocol", "Exercise type", "Muscle", 
                        "Sex", "Age", "Training", "Obesity", "Disease", "Biopsy time", "Training duration")
    active <- ggplot(data, aes(x=Gene2, y=Gene1, 
                               color=data[,as.numeric(input$selectgroup)],
                               shape=data[,as.numeric(input$selectgroup)])) +
      geom_smooth(method=lm, se=F, fullrange=TRUE, size=0.75) +
      geom_point(size=3) +
      labs(x=paste(rownames(Gene2), ", log2(fold-change)", sep=""),
           y=paste(input$genename_correlation, ", log2(fold-change)", sep=""),
           title="") +
      theme_bw() + theme + theme(legend.position="right") +
      scale_shape_manual(values=c(15,16,17,15,16,17,15,16,17)) +
      scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#999999"))
    return(active) 
  })
  
  
  #=======================================================================================
  # Make correlation description
  #=======================================================================================
  output$Corr_description <- renderText({
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Collecting information on selected genes", value = 1)
    
    validate(need(!is.null(Corr_stats()),     " "))
    validate(need(input$CorrTable_rows_selected!="",  " ")) 
    
    #find gene selected in the table
    GENENAME <- Corr_stats()
    GENENAME <- rownames(GENENAME[input$CorrTable_rows_selected,])
    
    #annotate with ENTREZID
    Annotation <- correlations_refseq
    ENTREZID <- Annotation[Annotation$GENENAME %in% GENENAME,2]
    
    #Find information on NCBI webpage
    webpage <- read_html(paste("https://www.ncbi.nlm.nih.gov/gene/", ENTREZID, sep=''))
    data_html <- html_nodes(webpage,'#summaryDl')
    data_html <- html_text(data_html)
    data_html <- str_replace_all(data_html, "[\r\n]" , "")
    data_html <- str_replace_all(data_html, "provided by HGNC" , "")
    if(str_detect(data_html, 'Summary')==T){
      data_html <- gsub('.*Summary', '', data_html)
      data_html <- gsub('\\].*', ']', data_html)
      data_html <- trimws(data_html)
    } else data_html <- "No information available for this gene on NCBI."
    
    return(data_html)
  })
  
  output$Corr_link <- renderUI({
    validate(need(!is.null(Corr_stats()),     " "))
    validate(need(input$CorrTable_rows_selected!="",  " ")) 
    
    #find gene selected in the table
    GENENAME <- Corr_stats()
    GENENAME <- rownames(GENENAME[input$CorrTable_rows_selected,])
    
    #Make link to genecard
    GeneCards <- paste("https://www.genecards.org/cgi-bin/carddisp.pl?gene=", GENENAME, sep="")
    GeneCards <- sprintf(paste0('<a href="', paste("https://www.genecards.org/cgi-bin/carddisp.pl?gene=", GENENAME, sep=""),
                                '" target="_blank">',
                                'Learn more about ', GENENAME, ' on GeneCards' ,'</a>'))
    GeneCards <- HTML(GeneCards)
    return(GeneCards)
  })
  
  #---------------------------------------------------------------------
  #hide loading page
  #Sys.sleep(2)
  shinyjs::hide("loading_page", anim = F, animType = "fade")
  shinyjs::show("main_content")
  
  #---------------------------------------------------------------------
  # Citations
  output$frame <- renderUI({
    my_test <- tags$iframe(src="https://app.dimensions.ai/discover/publication?and_subset_publication_citations=pub.1124285483",
                           height=600, width='100%')
    print(my_test)
    my_test
  })
}

