####################################################################################################################
# Define server logic ##############################################################################################
server <- function(input, output, session) {
  
  
  #=======================================================================================
  #
  # Load data
  #
  #=======================================================================================
  withProgress(message = 'Loading data', value = 1, max=13, {
    # Data for human
    incProgress(1, detail="Acute aerobic exercise studies")
    stats_human_AA <- data.frame(read_feather("data/merged_stats/stats_human_acute_aerobic.feather"), row.names=1)
    incProgress(1, detail="Acute HIT exercise studies")
    stats_human_AH <- data.frame(read_feather("data/merged_stats/stats_human_acute_hit.feather"), row.names=1)
    incProgress(1, detail="Acute resistance exercise studies")
    stats_human_AR <- data.frame(read_feather("data/merged_stats/stats_human_acute_resistance.feather"), row.names=1)
    incProgress(1, detail="Aerobic training studies")
    stats_human_TA <- data.frame(read_feather("data/merged_stats/stats_human_training_aerobic.feather"), row.names=1)
    incProgress(1, detail="Resistance training studies")
    stats_human_TR <- data.frame(read_feather("data/merged_stats/stats_human_training_resistance.feather"), row.names=1)
    incProgress(1, detail="Combined training studies")
    stats_human_TC <- data.frame(read_feather("data/merged_stats/stats_human_training_combined.feather"), row.names=1)
    incProgress(1, detail="HIT training studies")
    stats_human_TH <- data.frame(read_feather("data/merged_stats/stats_human_training_hit.feather"), row.names=1)
    incProgress(1, detail="Inactivity studies")
    stats_human_IN <- data.frame(read_feather("data/merged_stats/stats_human_inactivity.feather"), row.names=1)
    
    # Data for reference tables - human
    reftable_human_legend <- readRDS("data/annotation/reftable_human_legend.Rds") # Load the table describing the legend of the tables
    reftable_human_acute <- readRDS("data/annotation/reftable_human_acute.Rds") # Load the table describing the legend of the tables
    reftable_human_training <- readRDS("data/annotation/reftable_human_training.Rds") # Load the table describing the legend of the tables
    reftable_human_inactivity <- readRDS("data/annotation/reftable_human_inactivity.Rds") # Load the table describing the legend of the tables
    
    # Data for mouse
    incProgress(1, detail="Mouse acute exercise studies")
    stats_mouse_AA <- data.frame(read_feather("data/merged_stats/stats_mouse_acute.feather"), row.names=1)
    incProgress(1, detail="Mouse inactivity studies")
    stats_mouse_IN <- data.frame(read_feather("data/merged_stats/stats_mouse_inactivity.feather"), row.names=1)
    incProgress(1, detail="Mouse training studies")
    stats_mouse_TA <- data.frame(read_feather("data/merged_stats/stats_mouse_training.feather"), row.names=1)
    
    # Data for reference tables - mouse
    reftable_mouse_legend <- readRDS("data/annotation/reftable_mouse_legend.Rds") # Load the table describing the legend of the tables
    reftable_mouse_acute <- readRDS("data/annotation/reftable_mouse_acute.Rds") # Load the table describing the legend of the tables
    reftable_mouse_training <- readRDS("data/annotation/reftable_mouse_training.Rds") # Load the table describing the legend of the tables
    reftable_mouse_inactivity <- readRDS("data/annotation/reftable_mouse_inactivity.Rds") # Load the table describing the legend of the tables
    
    # Data for timeline
    incProgress(1, detail="Timeline analysis")
    timeline_acute_data <- data.frame(read_feather("data/timeline/timeline_acute_data.feather"), row.names=1)
    timeline_acute_stats <- data.frame(read_feather("data/timeline/timeline_acute_stats.feather"), row.names=1)
    timeline_acute_genes <- unique(na.omit(c(rownames(timeline_acute_data), 
                                             rownames(timeline_acute_stats))))
    
    timeline_inactivity_data <- data.frame(read_feather("data/timeline/timeline_inactivity_data.feather"), row.names=1)
    timeline_inactivity_stats <- data.frame(read_feather("data/timeline/timeline_inactivity_stats.feather"), row.names=1)
    timeline_inactivity_genes <- unique(na.omit(c(rownames(timeline_inactivity_data), 
                                                  rownames(timeline_inactivity_stats))))
    
    
    # Data for correlations
    incProgress(1, detail="Correlation tables")
    correlations_data_human <- data.frame(read_feather("data/correlations/data_human_correlations.feather"), row.names=1)
    correlations_data_mouse <- data.frame(read_feather("data/correlations/data_mouse_correlations.feather"), row.names=1)

  })
  
  
  #=======================================================================================
  #
  # Set up reactivity of home page
  #
  #=======================================================================================
  updateSelectizeInput(session, 'genename_home', 
                       choices=names_human_genes, 
                       server=TRUE, 
                       selected='NR4A3', 
                       options=NULL)
  
  # Synchronize genenames according to home page
  observeEvent(input$genename_home, { updateSelectizeInput(session, 'genename_metaanalysis_human', 
                                                           choices=names_human_genes, 
                                                           server=TRUE, 
                                                           selected=input$genename_home, options=NULL) })
  observeEvent(input$genename_home, { updateSelectizeInput(session, 'genename_metaanalysis_mouse', 
                                                           choices=names_mouse_genes, 
                                                           server=TRUE, 
                                                           selected=firstup(input$genename_home), options=NULL) })
  observeEvent(input$genename_metaanalysis_human, { updateSelectizeInput(session, 'genename_metaanalysis_mouse', 
                                                           choices=names_mouse_genes, 
                                                           server=TRUE, 
                                                           selected=firstup(input$genename_metaanalysis_human), options=NULL) })
  
  #update all if gene is changed on the meta-analysis tab
  #observeEvent(input$genename_metaanalysis_human, { updateSelectizeInput(session, "genename_timeline", selected=input$genename_metaanalysis_human) })
  #observeEvent(input$genename_metaanalysis_human, { updateSelectizeInput(session, 'genename_correlation', selected=input$genename_metaanalysis_human) })
  
  
  # Observe the clicks on buttons on home page and transfer to tab
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
  observe({ updateCheckboxGroupInput(session, 'human_muscle', 
                                     choices = names_human_categories[['muscle_choice']], 
                                     selected = if (input$human_muscle_allnone) names_human_categories[['muscle_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_sex', 
                                     choices = names_human_categories[['sex_choice']], 
                                     selected = if (input$human_sex_allnone) names_human_categories[['sex_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_age', 
                                     choices = names_human_categories[['age_choice']], 
                                     selected = if (input$human_age_allnone) names_human_categories[['age_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_fitness',  
                                     choices = names_human_categories[['training_choice']], 
                                     selected = if (input$human_fitness_allnone) names_human_categories[['training_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_weight',             
                                     choices = names_human_categories[['obesity_choice']], 
                                     selected = if (input$human_weight_allnone) names_human_categories[['obesity_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_disease',             
                                     choices = names_human_categories[['disease_choice']], 
                                     selected = if (input$human_disease_allnone) names_human_categories[['disease_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_exercise_type',        
                                     choices = names_human_categories[['exercise_type_choice']], 
                                     selected = if (input$human_exercise_type_allnone) names_human_categories[['exercise_type_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_acute_biopsy',              
                                     choices = names_human_categories[['acute_biopsy_choice']], 
                                     selected = if (input$human_acute_biopsy_allnone) names_human_categories[['acute_biopsy_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_training_duration',        
                                     choices = names_human_categories[['training_duration_choice']], 
                                     selected = if (input$human_training_duration_allnone) names_human_categories[['training_duration_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_training_biopsy',        
                                     choices = names_human_categories[['training_biopsy_choice']], 
                                     selected = if (input$human_training_biopsy_allnone) names_human_categories[['training_biopsy_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_inactivity_duration', 
                                     choices=names_human_categories[['inactivity_duration_choice']],
                                     selected = if (input$human_inactivity_duration_allnone) names_human_categories[['inactivity_duration_choice']])})
  observe({ updateCheckboxGroupInput(session, 'human_inactivity_protocol', 
                                     choices=names_human_categories[['inactivity_protocol_choice']],
                                     selected = if (input$human_inactivity_protocol_allnone) names_human_categories[['inactivity_protocol_choice']])})
  
  
  observe({ updateCheckboxGroupInput(session, 'mouse_muscle',
                                     choices = names_mouse_categories[['muscle_choice']],
                                     selected = if (input$mouse_muscle_allnone) names_mouse_categories[['muscle_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_sex',
                                     choices = names_mouse_categories[['sex_choice']],
                                     selected = if (input$mouse_sex_allnone) names_mouse_categories[['sex_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_age',
                                     choices = names_mouse_categories[['age_choice']],
                                     selected = if (input$mouse_age_allnone) names_mouse_categories[['age_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_disease',
                                     choices = names_mouse_categories[['disease_choice']],
                                     selected = if (input$mouse_disease_allnone) names_mouse_categories[['disease_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_exercise_type',
                                     choices = names_mouse_categories[['exercise_type_choice']],
                                     selected = if (input$mouse_exercise_type_allnone) names_mouse_categories[['exercise_type_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_acute_biopsy',
                                     choices = names_mouse_categories[['acute_biopsy_choice']],
                                     selected = if (input$mouse_acute_biopsy_allnone) names_mouse_categories[['acute_biopsy_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_training_duration',
                                     choices = names_mouse_categories[['training_duration_choice']],
                                     selected = if (input$mouse_training_duration_allnone) names_mouse_categories[['training_duration_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_inactivity_duration',
                                     choices=names_mouse_categories[['inactivity_duration_choice']],
                                     selected = if (input$mouse_inactivity_duration_allnone) names_mouse_categories[['inactivity_duration_choice']])})
  observe({ updateCheckboxGroupInput(session, 'mouse_inactivity_protocol',
                                     choices=names_mouse_categories[['inactivity_protocol_choice']],
                                     selected = if (input$mouse_inactivity_protocol_allnone) names_mouse_categories[['inactivity_protocol_choice']])})

  
  #=======================================================================================
  #
  # Make annotation tables for legend 
  #
  #=======================================================================================
  output$reftable_human_legend <- DT::renderDataTable(escape = FALSE, rownames = FALSE, options=list(paging = FALSE), { reftable_human_legend })
  output$reftable_human_acute <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { reftable_human_acute } )
  output$reftable_human_training <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { reftable_human_training })
  output$reftable_human_inactivity <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { reftable_human_inactivity  })
  
  output$reftable_mouse_legend <- DT::renderDataTable(escape = FALSE, rownames = FALSE, options=list(paging = FALSE), { reftable_mouse_legend })
  output$reftable_mouse_acute <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { reftable_mouse_acute } )
  output$reftable_mouse_training <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { reftable_mouse_training })
  output$reftable_mouse_inactivity <- DT::renderDataTable(escape = FALSE, rownames = FALSE, { reftable_mouse_inactivity  })
  
  
  #=======================================================================================
  #
  # Code for forest plots - Human
  #
  #=======================================================================================
  
  # Acute Aerobic forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_AA <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_AA["NR4A3",]
      selectedata <- stats_human_AA[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease,
                                   Biopsy %in% input$human_acute_biopsy,
                                   Exercisetype %in% input$human_exercise_type)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_AA)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_AA))
      }, error=function(e) NULL)
  })
  
  output$plot_human_AA <- renderPlot({ 
    data_human_AA <- metadata
    genename <- "NR4A3"
    #collect data from inputs
    genename <- input$genename_metaanalysis_human
    data_human_AA <- data_human_AA()
    #show progress
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    #call module to make forest plot
    finalplot <- ModuleForestPlot(data_human_AA, 
                                  genename,
                                  "#9D6807", 
                                  "acute aerobic exercise studies")
    finalplot
    #display forest plot
    return(finalplot)
  })
  
  
  # Acute Resistance forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_AR <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_AR[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease,
                                   Biopsy %in% input$human_acute_biopsy,
                                   Exercisetype %in% input$human_exercise_type)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_AR)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_AR))
    }, error=function(e) NULL)
  })
  
  output$plot_human_AR <- renderPlot({
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_AR(), paste(input$genename_metaanalysis_human),
                                  "#4C5C33", 
                                  "acute resistance exercise studies")
    finalplot
  })
  
  
  # Acute HIT forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_AH <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_AH[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease,
                                   Biopsy %in% input$human_acute_biopsy,
                                   Exercisetype %in% input$human_exercise_type)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_AH)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_AH))
    }, error=function(e) NULL)
  })
  
  output$plot_human_AH <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_AH(), paste(input$genename_metaanalysis_human),
                                  "#60394E", 
                                  "acute HIT exercise studies")
    finalplot
  })
  
  # Inactivity forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_IN <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_IN[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease)
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_IN,
                                   Exercisetype %in% input$human_inactivity_protocol,
                                   Biopsy %in% input$human_inactivity_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_IN))
    }, error=function(e) NULL)
  })
  
  output$plot_human_IN <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_IN(), paste(input$genename_metaanalysis_human),
                                  "#2171B5", 
                                  "inactivity studies")
    finalplot
  })
  
  
  # Training Aerobic forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_TA <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_TA[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_TA,
                                   Biopsy %in% input$human_training_biopsy,
                                   Duration %in% input$human_training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_TA))
    }, error=function(e) NULL)
  }) 
  
  output$plot_human_TA <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_TA(), paste(input$genename_metaanalysis_human),
                                  "#9D6807", 
                                  "aerobic training studies")
    finalplot
  })
  
  
  # Training Resistance forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_TR <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_TR[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_TR,
                                   Biopsy %in% input$human_training_biopsy,
                                   Duration %in% input$human_training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_TR))
    }, error=function(e) NULL)
  })
  
  output$plot_human_TR <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_TR(), paste(input$genename_metaanalysis_human),
                                  "#4C5C33", 
                                  "resistance training studies")
    finalplot
  })
  
  
  # Training Combined forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_TC <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_TC[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_TC,
                                   Biopsy %in% input$human_training_biopsy,
                                   Duration %in% input$human_training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_TC))
    }, error=function(e) NULL)
  })
  
  output$plot_human_TC <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_TC(), paste(input$genename_metaanalysis_human),
                                  "#58585A", 
                                  "combined training studies")
    finalplot
  })
  
  
  # Training HIT forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_human_TH <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_human_TH[input$genename_metaanalysis_human,]
      selectedata <- DataForGeneName(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Muscle %in% input$human_muscle, 
                                   Sex %in% input$human_sex, 
                                   Age %in% input$human_age, 
                                   Training %in% input$human_fitness,
                                   Obesity %in% input$human_weight,
                                   Disease %in% input$human_disease)
      #subset specific data for training studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_human_TH,
                                   Biopsy %in% input$human_training_biopsy,
                                   Duration %in% input$human_training_duration)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_human_TH))
    }, error=function(e) NULL)
  })
  
  output$plot_human_TH <- renderPlot({ 
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    finalplot <- ModuleForestPlot(data_human_TH(), paste(input$genename_metaanalysis_human),
                                  "#60394E", 
                                  "HIT training studies")
    finalplot
  })
  
  
  # Human overview plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  
  data_human_overview <- reactive({
    
    #create a NULL dataframe if data is not available
    null_df <- data.frame(logFC = NA, adj.P.Val = NA,
                          CI.L = NA, CI.R = NA,
                          size = 0,
                          Studies = "Meta-analysis score")
    
    # collect data from the different forest plots - if no data available in one group, replace with the empty dataframe
    data_human_AA <- if(!is.na(data_human_AA())){ data_human_AA() } else null_df
    data_human_AR <- if(!is.na(data_human_AR())){ data_human_AR() } else null_df
    data_human_AH <- if(!is.na(data_human_AH())){ data_human_AH() } else null_df
    data_human_IN <- if(!is.na(data_human_IN())){ data_human_IN() } else null_df
    data_human_TA <- if(!is.na(data_human_TA())){ data_human_TA() } else null_df
    data_human_TR <- if(!is.na(data_human_TR())){ data_human_TR() } else null_df
    data_human_TH <- if(!is.na(data_human_TH())){ data_human_TH() } else null_df
    data_human_TC <- if(!is.na(data_human_TC())){ data_human_TC() } else null_df

    # rename the datasets
    data_human_AA$Studies <- gsub("Meta-analysis score", "Acute Aerobic Meta-analysis", data_human_AA$Studies)
    data_human_AR$Studies <- gsub("Meta-analysis score", "Acute Resistance Meta-analysis", data_human_AR$Studies)
    data_human_AH$Studies <- gsub("Meta-analysis score", "Acute HIT Meta-analysis", data_human_AH$Studies)
    data_human_IN$Studies <- gsub("Meta-analysis score", "Inactivity Meta-analysis", data_human_IN$Studies)
    data_human_TA$Studies <- gsub("Meta-analysis score", "Training Aerobic Meta-analysis", data_human_TA$Studies)
    data_human_TR$Studies <- gsub("Meta-analysis score", "Training Resistance Meta-analysis", data_human_TR$Studies)
    data_human_TC$Studies <- gsub("Meta-analysis score", "Training Combined Meta-analysis", data_human_TC$Studies)
    data_human_TH$Studies <- gsub("Meta-analysis score", "Training HIT Meta-analysis", data_human_TH$Studies)
    
    # join everything in one table
    overview_data <- rbind(data_human_AA,
                           data_human_AR,
                           data_human_AH,
                           data_human_IN,
                           data_human_TA,
                           data_human_TR,
                           data_human_TH,
                           data_human_TC)
    
    overview_data <- overview_data[!is.na(overview_data$Studies),]
    overview_data <- overview_data[,c(6,1:5)]
    rownames(overview_data) <- c()

    return(overview_data)
    
  })
    
    
  output$plot_overview <- renderPlot({
    
    overview_data <- data_human_overview()
    
    #select only meta-analysis scores for plotting
    overview_data <- overview_data[grepl("Meta-analysis", overview_data$Studies),]

    # adjust groups and names
    overview_data$group <- gsub(" .*", "", overview_data$Studies)
    overview_data$Studies <- gsub(" Meta-analysis", "", overview_data$Studies)
    overview_data$Studies <- gsub(" ", "\n", overview_data$Studies)

    
    # need data in at least one of the protocols to make a plot
    validate(need(sum(is.na(overview_data$logFC)) != length(overview_data$logFC),
                  "No studies found - try different selection criteria"))
    
    # prepare stats to add to plot
    overview_data$p.adj.signif <- paste0("adj.P.Val =\n",
                                         signif(overview_data$adj.P.Val, 1))
    
    overview_data$p.adj.signif <- ifelse(overview_data$adj.P.Val < 0.05,
                                         paste0("adj.P.Val =\n",
                                                signif(overview_data$adj.P.Val, 2)),
                                         "ns")
    
    overview_data$p.adj.signif <- ifelse(is.na(overview_data$p.adj.signif),
                                         "Not\nenough\nstudies\nincluded",
                                         overview_data$p.adj.signif)
    
    overview_data$y.position <- overview_data$CI.R + 0.3
    overview_data$y.position <- ifelse(is.na(overview_data$y.position),
                                       -1,
                                       overview_data$y.position)
    
    ggbarplot(overview_data, 
              x = "Studies", y = "logFC",
              fill = "group") +
      xlab(NULL) +
      theme_bw() +
      theme(plot.title  = element_text(face="bold", color="black", size=12, angle=0),
            axis.text.x = element_text(color="black", size=10, angle=0, hjust = 0.5),
            axis.text.y = element_text(color="black", size=10, angle=0, hjust = 1),
            axis.title  = element_text(face="bold", color="black", size=12, angle=0),
            legend.text   = element_text(color="black", size=9, angle=0),
            legend.title  = element_text(face="bold", color="black", size=10, angle=0),
            legend.position="none") +
      geom_hline(yintercept = 0) +
      geom_point() +
      geom_errorbar(aes(ymin=CI.L, ymax=CI.R), 
                    width=.2,
                    position=position_dodge(.9)) +
      add_pvalue(overview_data, bracket.size = NA, 
                 xmin = "Studies",
                 xmax = "Studies",
                 label = "p.adj.signif",
                 y.position = "y.position", 
                 label.size = 3) +
      scale_y_continuous(expand = expansion(mult = c(0.1, 0.15)))
    
    
    
  })
  
  
  
  #=======================================================================================
  #
  # Code for forest plots - Mouse
  #
  #=======================================================================================
  
  # Mouse aerobic forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_mouse_AA <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_mouse_AA["Nr4a3",]
      selectedata <- stats_mouse_AA[input$genename_metaanalysis_mouse,]
      selectedata <- DataForGeneNameMouse(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Sex %in% input$mouse_sex, 
                                   Age %in% input$mouse_age, 
                                   Muscle %in% input$mouse_muscle, 
                                   Condition %in% input$mouse_disease,
                                   
                                   Protocol %in% input$mouse_exercise_type,
                                   Duration %in% input$mouse_acute_biopsy
      )
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_mouse_AA)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_mouse_AA))
    }, error=function(e) NULL)
  })
  
  output$plot_mouse_AA <- renderPlot({ 
    #show progress
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    #call module to make forest plot
    finalplot <- ModuleForestPlot(data_mouse_AA(), paste(input$genename_metaanalysis_mouse),
                                  "#9D6807", 
                                  "acute aerobic exercise studies")
    #display forest plot
    return(finalplot)
  })
  
  
  # Mouse training forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_mouse_TA <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_mouse_TA["Nr4a3",]
      selectedata <- stats_mouse_TA[input$genename_metaanalysis_mouse,]
      selectedata <- DataForGeneNameMouse(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Sex %in% input$mouse_sex, 
                                   Age %in% input$mouse_age, 
                                   Muscle %in% input$mouse_muscle, 
                                   Condition %in% input$mouse_disease,
                                   
                                   Protocol %in% input$mouse_training_protocol,
                                   Duration %in% input$mouse_training_duration
      )
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_mouse_TA)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_mouse_TA))
    }, error=function(e) NULL)
  })
  
  output$plot_mouse_TA <- renderPlot({ 
    #show progress
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    #call module to make forest plot
    finalplot <- ModuleForestPlot(data_mouse_TA(), paste(input$genename_metaanalysis_mouse),
                                  "#9D6807", 
                                  "aerobic training studies")
    #display forest plot
    return(finalplot)
  })
  
  
  # Mouse inactivity forest plot
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  data_mouse_IN <- reactive({
    tryCatch({  
      #select genes With feather
      selectedata <- stats_mouse_IN["Nr4a3",]
      selectedata <- stats_mouse_IN[input$genename_metaanalysis_mouse,]
      selectedata <- DataForGeneNameMouse(selectedata)
      #load module for selection of population of interest
      selectedata <- dplyr::filter(selectedata,
                                   Sex %in% input$mouse_sex, 
                                   Age %in% input$mouse_age, 
                                   Muscle %in% input$mouse_muscle, 
                                   Condition %in% input$mouse_disease,
                                   
                                   Protocol %in% input$mouse_inactivity_protocol,
                                   Duration %in% input$mouse_inactivity_duration
      )
      #subset specific data for acute studies
      selectedata <- dplyr::filter(selectedata,
                                   GEO %in% input$studies_mouse_IN)
      #Function to make meta-analysis table (adds a row with meta-analysis score)
      metadata <- MetaAnalysis(selectedata, nrow(stats_mouse_IN))
    }, error=function(e) NULL)
  })
  
  output$plot_mouse_IN <- renderPlot({ 
    #show progress
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    #call module to make forest plot
    finalplot <- ModuleForestPlot(data_mouse_IN(), paste(input$genename_metaanalysis_mouse),
                                  "#9D6807", 
                                  "inactivity studies")
    #display forest plot
    return(finalplot)
  })
  
  
  
  #=======================================================================================
  #
  # Code for timelines
  #
  #=======================================================================================
  
  # Acute exercise timeline plot and table
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  output$plot_human_timeline_acute <- renderPlot({
    #show progress bar
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)
    
    genename <- input$genename_metaanalysis_human
    
    res  <- timeline_acute_data
    colnames(res) <- gsub("X", "", colnames(res))
    colnames(res) <- gsub("\\..*", "", colnames(res))
    
    mydata <- data.frame(cessation=factor(colnames(res), levels=c('pre', '0_1', '2_3', '4_6', '24', '48', '72')),
                         logFC=as.numeric(res[genename,])) 
    
    ggplot(mydata, aes(x=cessation, y=logFC, fill=cessation)) + 
      geom_hline(yintercept=0, color="gray50", linetype="dashed") +
      geom_boxplot() +
      labs(x="Time after exercise (h)",
           y=paste(genename, ", log2(FC)", sep="")) +
      theme_bw() +
      theme(plot.title  = element_text(face="bold", color="black", size=12, angle=0),
            axis.text.x = element_text(color="black", size=10, angle=0, hjust = 0.5),
            axis.text.y = element_text(color="black", size=10, angle=0, hjust = 1),
            axis.title  = element_text(face="bold", color="black", size=12, angle=0),
            legend.text   = element_text(color="black", size=9, angle=0),
            legend.title  = element_text(face="bold", color="black", size=10, angle=0),
            legend.position="none") +
      scale_fill_brewer(palette="Reds", direction=-1)
  })
  
  output$table_human_timeline_acute <- renderTable(rownames = TRUE, align='c', { 
    res  <- timeline_acute_stats[input$genename_metaanalysis_human,]
    stats <- data.frame(logFC=signif(t(res[grepl('Median.[0-9]', colnames(res))]), 2),
                        p.value=t(res[grepl('P.Value', colnames(res))]),
                        adj.P.Val=t(res[grepl('adj.P.Val', colnames(res))]))
    
    validate(need(!all(is.na(stats[,2])),  "This gene is undetectable in too many studies to calculate the timeline."))
    
    colnames(stats) <- c('logFC', 'p.value', 'adj.P.Val')
    ANOVA <- c("", res[grepl('F_', colnames(res))])
    names(ANOVA) <- c('logFC', 'p.value', 'adj.P.Val')
    stats <- rbind(ANOVA, stats)
    stats$significance <- ''
    stats$significance[stats$adj.P.Val < 0.05] <- "*"
    stats$significance[stats$adj.P.Val < 0.01] <- "**"
    stats$significance[stats$adj.P.Val < 0.001] <- "***"
    stats$p.value <- scientific(stats$p.value, 1)
    stats$adj.P.Val <- scientific(stats$adj.P.Val, 1)
    rownames(stats) <- c('F-test',
                         '0-1h vs Pre', 
                         '2-3h vs Pre',
                         '4-6h vs Pre', 
                         '24h vs Pre',
                         '48h vs Pre')
    return(stats)
  })
  
  
  # Inactivity timeline plot and table
  #=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#
  output$plot_human_timeline_inactivity      <- renderPlot({
    #show progress bar
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Calculating", value = 1)

    genename <- input$genename_metaanalysis_human
    
    mydata <- data.frame(cessation=gsub("\\..*", "", colnames(timeline_inactivity_data)),
                         logFC=as.numeric(timeline_inactivity_data[genename,]))
    mydata$cessation <- factor(mydata$cessation, levels=c('PRE', 'W0_1', 'W1_2', 'W2_9'))
    
    active <- ggplot(mydata, aes(x=cessation, y=logFC, fill=cessation)) + 
      theme_bw() + 
      theme(plot.title  = element_text(face="bold", color="black", size=12, angle=0),
            axis.text.x = element_text(color="black", size=10, angle=0, hjust = 0.5),
            axis.text.y = element_text(color="black", size=10, angle=0, hjust = 1),
            axis.title  = element_text(face="bold", color="black", size=12, angle=0),
            legend.text   = element_text(color="black", size=9, angle=0),
            legend.title  = element_text(face="bold", color="black", size=10, angle=0),
            legend.position="none") +
      geom_hline(yintercept=0, color="gray50", linetype="dashed") +
      geom_boxplot() +
      labs(x="Inactivity duration (weeks)",
           y=paste(genename, ", log2(fold-change)", sep="")) + 
      scale_fill_brewer(palette="Blues", direction=1) +
      scale_x_discrete(breaks=levels(mydata$cessation),
                       labels=c('Pre', '<1', '1-2', '>2'))
    return(active)
  })
  
  output$table_human_timeline_inactivity <- renderTable(rownames = TRUE, align='c', { 
    
    res  <- timeline_inactivity_stats[input$genename_metaanalysis_human,]
    
    stats <- data.frame(logFC=signif(t(res[grepl('Median.W', colnames(res))]), 2),
                        p.value=t(res[grepl('P.Value', colnames(res))]),
                        adj.P.Val=t(res[grepl('adj.P.Val', colnames(res))]))
    colnames(stats) <- c('logFC', 'p.value', 'adj.P.Val')
    
    validate(need(!all(is.na(stats[,2])),  "This gene is undetectable in too many studies to calculate the timeline."))
    
    ANOVA <- c("", res[grepl('F_', colnames(res))])
    names(ANOVA) <- c("logFC", 'p.value', 'adj.P.Val')
    stats <- rbind(ANOVA, stats)
    stats$significance <- ''
    stats$significance[stats$adj.P.Val < 0.05] <- "*"
    stats$significance[stats$adj.P.Val < 0.01] <- "**"
    stats$significance[stats$adj.P.Val < 0.001] <- "***"
    stats$p.value <- scientific(stats$p.value, 1)
    stats$adj.P.Val <- scientific(stats$adj.P.Val, 1)
    rownames(stats) <- c('F-test',
                         '<1 week vs Pre',
                         '1-2 weeks vs Pre',
                         '>2 weeks vs Pre')
    return(stats)
  })
  

  

  #=======================================================================================
  #
  # Correlations - human
  #
  #=======================================================================================

  #subset data for correlations
  corr_data_human <- eventReactive(input$updateCorrHuman, {
    validate(need(input$human_corr_protocol, "Please select at least one exercise protocol."))
    validate(need(input$human_muscle, 'No "Muscle" criteria selected'))
    validate(need(input$human_sex, 'No "Sex" criteria selected'))
    validate(need(input$human_age, 'No "Age" criteria selected'))
    validate(need(input$human_fitness, 'No "Fitness" criteria selected'))
    validate(need(input$human_weight, 'No "Weight" criteria selected'))
    validate(need(input$human_disease, 'No "Health Status" criteria selected'))
    
    tryCatch({
        studies <- data.frame(colnames(correlations_data_human), 
                         str_split_fixed(colnames(correlations_data_human), "_", 12)[,3:12])
        colnames(studies) <- c('FileName', 'Protocol', 'Exercisetype', 
                               'Muscle', 'Sex', 'Age', 'Training',
                               'Obesity', 'Disease', 'Biopsy', 'Duration')
        
        studies <- dplyr::filter(studies,
                                 Protocol %in% input$human_corr_protocol,
                                 Muscle %in% input$human_muscle, 
                                 Sex %in% input$human_sex, 
                                 Age %in% input$human_age, 
                                 Training %in% input$human_fitness,
                                 Obesity %in% input$human_weight,
                                 Disease %in% input$human_disease
        )
        
        #only keep rows with enough observations
        selectedata <- correlations_data_human[colnames(correlations_data_human) %in% studies$FileName]
        selectedata <- selectedata[rowSums(is.na(selectedata)) < ncol(selectedata)/2,]
        
        return(selectedata)
    }, error=function(e) NULL)
  })
    
  #calculate spearman correlation
  corr_stats_human <- reactive({
    validate(need(!is.null(corr_data_human()),     " "))
    
    withProgress(message = 'Calculating', value = 0, max=9, {
      
      selectedata <- corr_data_human()

        #select data for gene of interest
        genename <- input$genename_metaanalysis_human
        geneofinterest <- as.numeric(selectedata[genename,])
        
        #If input gene changes, recalculate
        validate(need(input$genename_metaanalysis_human == genename,     
                      "Please re-calculate correlation with the new selection "))
        
        estimate <- function(x) cor.test(x, geneofinterest, method="spearman", exact=F)$estimate
        p.value  <- function(x) cor.test(x, geneofinterest, method="spearman", exact=F)$p.value
        
        if(nrow(selectedata < 100)){
          Spearman.r <- apply(selectedata[1:nrow(selectedata),], 1, estimate)
          Spearman.p <- apply(selectedata[1:nrow(selectedata),], 1, p.value)
        } else {
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
        }
        incProgress(0.4, detail="Making table")
        Spearman.adj.P.Val <- p.adjust(Spearman.p, method="bonferroni")
        Spearman.r <- round(Spearman.r, digits=3)
        Spearman.p <- signif(Spearman.p, digits=2)
        Spearman.adj.P.Val <- signif(Spearman.adj.P.Val, digits=2)
        coeff <- data.frame(Spearman.r, Spearman.adj.P.Val)
        colnames(coeff) <- c("Spearman.r", "adj.P.Val")
        coeff <- coeff[order(coeff$adj.P.Val),]
        
        return(coeff)
    })
  })
  
  #make table output
  output$corr_table_human <- DT::renderDataTable(escape = FALSE, 
                                          rownames = T, 
                                          selection = "single", {
                                            validate(need(!is.null(corr_stats_human()),   
                                                          "Start by selecting a gene in the list of official gene names"))
                                            
                                            corr_stats_human()
                                          })
  
  # Make plot output
  output$corr_plot_human      <- renderPlot({ 
    validate(need(!is.null(corr_data_human()),     " "))
    validate(need(input$corr_table_human_rows_selected!="",  "Click on a gene in the table to display the correlation")) 
    
    selectedata <- corr_data_human()

    #collect names of the 2 genes to correlate
    Gene1name <- input$genename_metaanalysis_human
    Gene2name <- rownames(corr_stats_human()[input$corr_table_human_rows_selected,])
    
    #find data from the 2 genes and merge
    Gene1 <- selectedata[Gene1name,]
    Gene2 <- selectedata[Gene2name,]
    data  <- data.frame(t(Gene1), t(Gene2))
    data <- cbind(data, str_split_fixed(rownames(data), "_", 12))
    colnames(data) <- c("Gene1", "Gene2", "logFC", "GEO",
                        "Protocol", "Exercise type", "Muscle", 
                        "Sex", "Age", "Training", "Obesity", "Disease", 
                        "Biopsy time", "Duration")
    active <- ggplot(data, aes(x=Gene2, y=Gene1)) +
      geom_smooth(method=lm, se=F, fullrange=TRUE, size=0.75, color="black") +
      geom_point(aes(x=Gene2, y=Gene1, 
                     color=Protocol,
                     shape=Protocol),
                 size=3) +
      labs(x=paste(rownames(Gene2), ", log2(fold-change)", sep=""),
           y=paste(input$genename_metaanalysis_human, ", log2(fold-change)", sep=""),
           title="") +
      theme_bw() + theme + theme(legend.position="right") + 
      scale_shape_manual(values=c(15,16,17,18,15,16,17,18,15,16,17,18))
    return(active) 
  })
  
  # Make correlation description
  output$corr_description_human <- renderText({
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Collecting information on selected genes", value = 1)
    
    validate(need(!is.null(corr_data_human()),     " "))
    validate(need(input$corr_table_human_rows_selected!="",  " ")) 
    
    #find gene selected in the table and annotate with ENTREZID
    GENENAME <- rownames(corr_stats_human()[input$corr_table_human_rows_selected,])
    ENTREZID <- correlations_annotation_human[correlations_annotation_human$SYMBOL %in% GENENAME, 3][1]
    print(c(GENENAME, ENTREZID))
    validate(need(ENTREZID!="",  "No information available for this gene.")) 
    
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
    } else data_html <- "Cannot connect to NCBI."
    
    return(data_html)
    })
  
  output$corr_link_human <- renderUI({
    validate(need(!is.null(corr_data_human()),     " "))
    validate(need(input$corr_table_human_rows_selected!="",  " ")) 
    
    #find gene selected in the table
    GENENAME <- corr_stats_human()
    GENENAME <- rownames(GENENAME[input$corr_table_human_rows_selected,])
    
    #Make link to genecard
    GeneCards <- paste("https://www.genecards.org/cgi-bin/carddisp.pl?gene=", GENENAME, sep="")
    GeneCards <- sprintf(paste0('<a href="', paste("https://www.genecards.org/cgi-bin/carddisp.pl?gene=", GENENAME, sep=""),
                                '" target="_blank">',
                                'Learn more about ', GENENAME, ' on GeneCards' ,'</a>'))
    GeneCards <- HTML(GeneCards)
    return(GeneCards)
  })
  
  
  #=======================================================================================
  #
  # Download buttons
  #
  #=======================================================================================
  output$download_data_human_AA <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Acute_Aerobic.csv" },
    content = function(file) {
      write.csv(stats_human_AA, file)
    })
  
  output$download_data_human_AR <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Acute_Resistance.csv" },
    content = function(file) {
      write.csv(stats_human_AR, file)
    })
  
  output$download_data_human_AH <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Acute_HIT.csv" },
    content = function(file) {
      write.csv(stats_human_AH, file)
    })
  
  output$download_data_human_TA <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Training_Aerobic.csv" },
    content = function(file) {
      write.csv(stats_human_TA, file)
    })
  
  output$download_data_human_TR <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Training_Resistance.csv" },
    content = function(file) {
      write.csv(stats_human_TR, file)
    })
  
  output$download_data_human_TH <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Training_HIT.csv" },
    content = function(file) {
      write.csv(stats_human_TH, file)
    })
  
  output$download_data_human_TC <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Training_Combined.csv" },
    content = function(file) {
      write.csv(stats_human_TC, file)
    })
  
  output$download_data_human_IN <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_Human_Inactivity.csv" },
    content = function(file) {
      write.csv(stats_human_IN, file)
    })
  
  
  output$download_data_mouse_AA <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_mouse_Acute_Aerobic.csv" },
    content = function(file) {
      write.csv(stats_mouse_AA, file)
    })
  output$download_data_mouse_TA <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_mouse_Training_Aerobic.csv" },
    content = function(file) {
      write.csv(stats_mouse_TA, file)
    })
  output$download_data_mouse_IN <- downloadHandler(
    filename = function() { "MetaMEx_v3.2207_mouse_Inactivity.csv" },
    content = function(file) {
      write.csv(stats_mouse_IN, file)
    })
  
  output$download_human_overview <- downloadHandler(
    filename = function() { 
      paste0( input$genename_metaanalysis_human,
              "_MetaMEx_v3.2207.csv") },
    content = function(file) {
      write.csv(data_human_overview(), file, row.names = F)
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

