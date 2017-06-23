library("ggplot2")
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$clustertPlot <- renderPlot({
    num_clus <- input$bins
    file_csv <- read.csv("path_to_csv_file")
    
    #Eliminating Unnecssary columns(text) from CSV
    tableFromCSV <- file_csv[, -c(1, 1)]
    
    #For normalizing
    tableFromCSV_Scaled <- scale(tableFromCSV)
    set.seed(42)
    
    # K- Means Algorithm
    clusterData <- kmeans(tableFromCSV, num_clus, nstart = 30)
    
    #plotting Cluster
    plot(
      tableFromCSV[c("House", "District")],
      col = clusterData$cluster,
      pch = 6,
      main = "Clustering"
    )
    points(
      clusterData$centers,
      pch = 4,
      cex = 3,
      lwd = 2,
      col = "blue"
    )
    lines(clusterData$centers, col = "black", lwd = 2)
    print(clusterData)
    
    #NOrmalizarion for distance betweeen
    
    # m <- apply(tableFromCSV, 2, mean)
    # s <- apply(tableFromCSV, 2, sd)
    # z <- scale(tableFromCSV, m, s)
    #
    # distance <- dist(z)
    
    #centroids <- aggregate(age~height,tableFromCSV,mean)
    #clusplot(tableFromCSV, clusterData$cluster, color=TRUE, shade=TRUE, main="Cusplot",
    #         labels = 0, xlab = "Height", ylab = "Age", xlim=c(-60,70), ylim = c(-40,50))
  })
  
  output$barPlot <- renderPlot({
    num_clus <- input$bins
    file_csv <-
      read.csv("path_to_csv_file")
    tableFromCSV <- file_csv[, -c(1, 1)]
    
    #For normalizing
    tableFromCSV_Scaled <- scale(tableFromCSV)
    set.seed(42)
    clusterData <- kmeans(tableFromCSV, num_clus, nstart = 30)
    barplot(clusterData$centers)
    pie(clusterData$size)
    # Finding Optimal Cluster Value
    #library(factoextra)
    # fviz_nbclust(tableFromCSV, method = "wss", FUNcluster = kmeans) +
    # geom_vline(xintercept = 5, linetype = 3)
    # tableFromCSV <- file_csv[,-c(1,3)]
  })
  
  output$txt1 <- renderText({
    in_1 <- input$input1
    in_2 <- input$input2
    print(in_1)
    print(in_2)
  })
  
  output$txt <- renderUI({
    num_clus <- input$bins
    str2 <- ""
    str1 <- paste("There are ", num_clus, " Cluster")
    
    #Start Time
    start.time <- Sys.time()
    
    file_csv <-
      read.csv("path_to_csv_file")
    tableFromCSV <- file_csv[, -c(1, 1)]
    
    #For normalizing
    tableFromCSV_Scaled <- scale(tableFromCSV)
    set.seed(42)
    clusterData <- kmeans(tableFromCSV, num_clus, nstart = 30)
    out <- cbind(tableFromCSV, clusterNum = clusterData$cluster)
    print(out)
    print(clusterData$centers)
    # Calculate Time
    end.time <- Sys.time()
    time_taken <- end.time - start.time
    print(time_taken)
    str1 <-
      paste(str1,
            ", <br> Time Taken",
            time_taken,
            " ,<br> Each Cluster Size : ",
            clusterData$size)
    j <- 0
    for (i in 1:num_clus) {
      k <- i + 1
      if (!(k > num_clus))
        for (j in k:num_clus) {
          m <- i + num_clus
          p <- j + num_clus
          t <-
            sqrt(
              (clusterData$centers[i] -  clusterData$centers[j]) ^ 2 + (clusterData$centers[m] -  clusterData$centers[p]) ^
                2
            )
          str2 <-
            paste(str2, "Cluster ", i, ":", j, " has distance ", t, "<br>", sep = " ")
        }
    }
    HTML(paste(str1, str2,  sep = '<br/>'))
    
  })
})