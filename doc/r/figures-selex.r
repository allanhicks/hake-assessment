make.selex.plot <- function(model,
                            subplot = 2,
                            agefactors = "Asel",
                            pan.letter = NULL){  ## If not null, this character will be placed on the panel
  ## Make a single selectivity plot for the MLE model provided
  SSplotSelex(model, subplot = subplot, agefactors = agefactors)
  if(!is.null(pan.letter)){
    panel.letter(pan.letter)
  }
}

calc.tv.selex <- function(model,
                          start.yr,
                          end.yr,
                          ages = 1:8,  ## ages to be included
                          probs = c(0.025, 0.975)){
  ## Calculate the data frame to use for the functions involving time varying selectivity
  ## Returns a list of length 4: The overall selex object, and data frames of median, lower, and upper quantiles
  ##  as calculated for the given probablities. The columns in the data frames are the years
  ##  and the rows are ages. Both row names and column names have been set properly.

  yrs <- start.yr:end.yr
  selex <- list()
  selex[[1]] <- matrix(NA, nrow = nrow(model$mcmc), ncol = 16)
  for(i in 1:nrow(model$mcmc)) {
    ind <- grep("AgeSel_1P_[1-9]_Fishery", names(model$mcmc))[1:5]
    selex[[1]][i,] <- randWalkSelex.fn(unlist(c(-1000,
                                                0, model$mcmc[i, ind],
                                                0, 0, 0, 0, 0, 0, 0, 0, 0)))
  }

  for(i in 2:length(yrs)){
    selex[[i]] <- selexYear.fn(model$mcmc, yrs[i])
  }
  ## Strip off unneeded ages
  for(i in 1:length(selex)){
    ## Remove the first column because it is age zero fish
    selex[[i]] <- selex[[i]][,-1]
    cols.to.remove <- NULL
    if(ages[1] > 1){
      cols.to.remove <- (1:(ages[1]-1))
    }
    if(ages[length(ages)] < ncol(selex[[i]])){
      cols.to.remove <- c(cols.to.remove, (ages[length(ages)]+1):ncol(selex[[i]]))
    }
    if(!is.null(cols.to.remove)){
      selex[[i]] <- selex[[i]][,-cols.to.remove]
    }
    if(ncol(selex[[i]]) == length(ages)){
      colnames(selex[[i]]) <- ages
    }else{
      cat("calc.tv.selex: Warning - length of ages vector (",length(ages),
          ") not equal to the number of columns in the selectivity data (",ncol(selex[[i]]),") for year ",yrs[i],"\n", sep="")
    }
  }

  selex.median <- as.data.frame(lapply(selex, function(x){apply(x, 2, median)}))
  names(selex.median) <- yrs
  selex.lower <- as.data.frame(lapply(selex, function(x){apply(x, 2, quantile, prob = probs[1])}))
  names(selex.lower) <- yrs
  selex.upper <- as.data.frame(lapply(selex, function(x){apply(x, 2, quantile, prob = probs[2])}))
  names(selex.upper) <- yrs

  return(list(selex = selex,
              lower = selex.lower,
              median = selex.median,
              upper = selex.upper))
}

make.tv.selex.plot <- function(selex.list  ## A list of time varying selectivites as returned by calc.tv.selex
                               ){
  ## Plot the time-varying selectivity of model
  oldpar <- par()

  par(mar=c(4,4,1,1))
  selex.dat <- t(selex.list$median)

  mountains(selex.dat,
            yvec = as.numeric(rownames(selex.dat)),
            rev = TRUE,
            cex.axis = 0.8)
  mtext(side=1,line=2,"Age")
  mtext(side=2,line=3,"Selectivity by year")

  par <- oldpar
}

make.tv.selex.uncertainty.plot <- function(selex.list  ## A list of time varying selectivites as returned by calc.tv.selex
                                           ){
  ## Plot the time-varying selectivity of model with uncertainty
  oldpar <- par()

  par(mar=c(4,4,1,1))

  single.yr.sel <- function(sel.med,   ## vector of selectivity medians for any given year
                            sel.lower, ## vector of selectivity lower quantile for any given year
                            sel.upper, ## vector of selectivity upper quantile for any given year
                            year,
                            ages,
                            yAdjust){
    lines(ages, yAdjust + sel.med, type="b", pch = 20)
    segments(x0 = ages, y0 = yAdjust + sel.upper,
             x1 = ages, y1 = yAdjust + sel.lower)
    polygon(x = c(ages, rev(ages)),
            y = yAdjust + c(sel.upper, rev(sel.lower)),
            col = rgb(0, 0, 1, 0.2), lty = 3)
  }

  selex.med <- selex.list$median
  selex.lower <- selex.list$lower
  selex.upper <- selex.list$upper

  ages <- as.numeric(rownames(selex.med))
  yrs <- as.numeric(colnames(selex.med))

  plot(0,
       type = "n",
       xlim = c(min(ages), max(ages)),
       ylim = -1 * (max(yrs) - c(0, length(yrs))),
       yaxt = "n",
       pch = 20,
       xlab = "",
       ylab = "")
  label <- yrs
  axis(2, las = 1, at = -yrs + 0.5, lab = label)
  for(y in yrs){
    single.yr.sel(selex.med[,names(selex.med) %in% y],
                  selex.lower[,names(selex.lower) %in% y],
                  selex.upper[,names(selex.upper) %in% y],
                  y,
                  ages,
                  yAdjust = -y)
  }
  abline(h = -c(min(yrs)-1, yrs), col = rgb(0, 0, 0, 0.2))

  par <- oldpar
}

make.multiple.tv.selex.uncertainty.plots <- function(tv.sel.list ## A list of outputs from calc.tv.selex function
                                                     ){
  ## Takes a list of outputs from the calc.tv.selex function, and calls
  ##  make.tv.selex.uncertainty.plot for each of the items, placing
  ##  them side-by-side with single labels for Age and Selectivity by year.
  ## This allows the user to select how they want to break up the plots by year

  oldpar <- par()
  par(mfrow=c(1, length(tv.sel.list)), oma=c(1,1,0,0))
  for(i in 1:length(tv.sel.list)){
    make.tv.selex.uncertainty.plot(tv.sel.list[[i]])
  }
  mtext(side = 1, line = -1, outer = TRUE, text="Age")
  mtext(side = 2, outer = TRUE, text="Selectivity by year")
  par <- oldpar
}

make.selex.uncertainty.lines.plot <- function(model,
                                              ages = 1:8,
                                              type = 1, ## 1 = Fishery, any other value is the survey
                                              selex.list = NULL,  ## A list of time varying selectivites as returned by calc.tv.selex
                                                                  ## *Only used when type=1 (fishery)
                                              probs = c(0.025, 0.975)
                                              ){
  ## Plots estimated selectivity lines from each sample in the posterior distribution
  if(type == 1 & is.null(selex.list)){
    stop("make.mcmc.selex.uncertainty.plot: Error - when type = 1, you must supply a selex.list.\n")
  }
  oldpar <- par()
  par(mar=c(4,4,1,1))
  sel.med <- selex.list$median

  if(type == 1){
    selex <- selex.list$selex[[1]]
    ## The indexing below will give you the last year in the series.
    ## Need to check this to make sure it is correct.
    selex.med <- selex.list$median[,ncol(selex.list$med)]
    selex.lower <- selex.list$lower[,ncol(selex.list$lower)]
    selex.upper <- selex.list$upper[,ncol(selex.list$upper)]
    seg.color <- rgb(0.1, 0.1, 1, 0.8)
  }else{
    selex <- model$mcmc[,grep("Selex_std_2_Fem_A_", names(model$mcmc))]
    selex.med <- apply(selex,2,median)
    selex.lower <- apply(selex, 2, quantile, prob = probs[1])
    selex.upper <- apply(selex, 2, quantile, prob = probs[2])
    seg.color <- rgb(1,0.1,0.1,0.8)
  }
  plot(ages,
       selex.med[ages],
       type = "b",
       ylim = c(0, 1),
       pch = 20,
       xlab = "Age",
       ylab = "Selectivity",
       xaxt = "n",
       las = 1)
  for(i in 1:nrow(selex)) {
    lines(ages, selex[i, ages], col = rgb(0, 0, 0, 0.1))
  }
  segments(ages,
           selex.upper[ages],
           ages,
           selex.lower[ages],
           col = seg.color,
           lwd = 3)
  points(ages,
         selex.med[ages],
         pch = 16,
         cex = 1.5,
         col = seg.color)
  axis(1, at = ages)
  par <- oldpar

}
