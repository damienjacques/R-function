plot_correlation <- function(df, var, method = "pearson"){
  
  require(ggplot2)
  require(reshape2)
  
  M <- cbind(df[,var], df[,-which(colnames(df)==var)])
  colnames(M)[1] <- var
  M <- cor(M, use="complete", method= method)
  M[upper.tri(M)] <- NA
  M <- melt(M)
  colnames(M) <- c("Var1", "Var2", "Correlation")
  M <- M[!is.na(M$Correlation),]
  M$Var1 <- as.factor(M$Var1)
  M$Var2 <- as.factor(M$Var2)
  M$Correlation <- round(M$Correlation, digits=2)
  M$label <- M$Correlation
  
  g <- ggplot(M, aes(as.factor(Var1), as.factor(Var2))) + 
    geom_raster(aes(fill = abs(Correlation))) + 
    scale_fill_gradient2(low="#cd0000", mid="#f2f6c3",high="#006400",limits=c(0, 1), midpoint=0.5, name = paste0("|", method," correlation|")) + 
    scale_x_discrete(expand=c(0,0)) + 
    scale_y_discrete(expand=c(0,0)) +
    geom_text(aes(as.factor(Var1), as.factor(Var2), label = label), color = "black", size = 4) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text.x=element_text(size = 10, angle = 90),
      panel.grid.major = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      axis.ticks = element_blank(),
      legend.justification = c(1, 0),
      legend.position = c(0.4,0.75),
      legend.direction = "horizontal",
      legend.text = element_text(size = 10, angle = 45)) +
    guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                                 title.position = "top", title.hjust = 0.5))
  
  return(g)
}