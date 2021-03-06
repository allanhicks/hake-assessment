# Andy changing row names here, original is below:
make.reference.points.table <- function(model,                ## model is an mcmc run and is the output of the r4ss package's function SSgetMCMC
                                        xcaption = "default", ## Caption to use
                                        xlabel   = "default", ## Latex label to use
                                        font.size = 9,        ## Size of the font for the table
                                        space.size = 10,       ## Size of the spaces for the table
                                        placement = "H"       ## Placement of table
                                        ){
  ## Returns an xtable in the proper format for the executive summary reference points

  unfish.fem.bio <- fmt0(round(quantile(model$mcmc$SSB_Unfished,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  unfish.recr <- fmt0(round(quantile(model$mcmc$Recr_Virgin,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)


  f.spawn.bio.bf40 <- fmt0(round(quantile(model$mcmc$SSB_SPRtgt,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  spr.msy.proxy <- c("\\textbf{--}","40\\%","\\textbf{--}")
  exp.frac.spr <- paste0(round(100*quantile(model$mcmc$Fstd_SPRtgt,prob=c(0.025,0.5,0.975)),1), "\\%")
  yield.bf40 <- fmt0(round(quantile(model$mcmc$TotYield_SPRtgt,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)

  fem.spawn.bio.b40 <- fmt0(round(quantile(model$mcmc$SSB_Btgt,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  spr.b40 <- paste0(round(100*quantile(model$mcmc$SPR_Btgt,prob=c(0.025,0.5,0.975)),1), "\\%")
  exp.frac.b40 <- paste0(round(100*quantile(model$mcmc$Fstd_Btgt,prob=c(0.025,0.5,0.975)),1), "\\%")
  yield.b40 <- fmt0(round(quantile(model$mcmc$TotYield_Btgt,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)

  fem.spawn.bio.bmsy <- fmt0(round(quantile(model$mcmc$SSB_MSY,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  spr.msy <- paste0(round(100*quantile(model$mcmc$SPR_MSY,prob=c(0.025,0.5,0.975)),1), "\\%")
  exp.frac.sprmsy <- paste0(round(100*quantile(model$mcmc$Fstd_MSY,prob=c(0.025,0.5,0.975)),1), "\\%")
  msy <- fmt0(round(quantile(model$mcmc$TotYield_MSY,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)

  tab <- rbind(unfish.fem.bio, unfish.recr,
               f.spawn.bio.bf40, spr.msy.proxy, exp.frac.spr, yield.bf40,
               fem.spawn.bio.b40, spr.b40, exp.frac.b40, yield.b40,
               fem.spawn.bio.bmsy, spr.msy, exp.frac.sprmsy, msy)
  descr <- c("Unfished female spawning biomass ($B_0$, thousand t)",
             "Unfished recruitment ($R_0$, millions)",
             "Female spawning biomass at $\\Fforty$ ($\\Bforty$, thousand t)",
             "SPR at $\\Fforty$",
             "Exploitation fraction corresponding to SPR",
             "Yield at $\\Bforty$ (thousand t)",
             "Female spawning biomass ($B_{40\\%}$, thousand t)",
             "SPR at $B_{40\\%}$",
             "Exploitation fraction resulting in $B_{40\\%}$",
             "Yield at $B_{40\\%}$ (thousand t)",
             "Female spawning biomass ($B_{\\text{MSY}}$, thousand t)",
             "SPR at MSY",
             "Exploitation fraction corresponding to SPR at MSY",
             "MSY (thousand t)")
  tab <- cbind(descr, tab)

  colnames(tab) <- c("\\textbf{Quantity}",
                     "\\specialcell{\\textbf{2.5\\supscr{th}}\\\\\\textbf{percentile}}",
                     "\\specialcell{\\textbf{Median}}",
                     "\\specialcell{\\textbf{97.5\\supscr{th}}\\\\\\textbf{percentile}}")
  addtorow <- list()
  addtorow$pos <- list()
  addtorow$pos[[1]] <- 2
  addtorow$pos[[2]] <- 6
  addtorow$pos[[3]] <- 10
  addtorow$command <- c("\\textbf{\\underline{Reference points (equilibrium) based on $\\Fforty$}} \\\\",
                        "\\textbf{\\underline{Reference points (equilibrium) based on $B_{40\\%}$ (40\\% of $B_0$)}} \\\\",
                        "\\textbf{\\underline{Reference points (equilibrium) based on estimated MSY}} \\\\")
  ## Make the size string for font and space size
  size.string <- paste0("\\fontsize{",font.size,"}{",space.size,"}\\selectfont")
  return(print(xtable(tab, caption=xcaption, label=xlabel, align=get.align(ncol(tab), just="c")),
               caption.placement = "top", include.rownames=FALSE, sanitize.text.function=function(x){x},
               size=size.string, add.to.row=addtorow, table.placement=placement))
}

# Original function before Andy changing row names:
make.reference.points.table.orig <- function(model,                ## model is an mcmc run and is the output of the r4ss package's function SSgetMCMC
                                        xcaption = "default", ## Caption to use
                                        xlabel   = "default", ## Latex label to use
                                        font.size = 9,        ## Size of the font for the table
                                        space.size = 10,       ## Size of the spaces for the table
                                        placement = "H"       ## Placement of table
                                        ){
  ## Returns an xtable in the proper format for the executive summary reference points

  unfish.fem.bio <- fmt0(round(quantile(model$mcmc$SSB_Unfished,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  unfish.recr <- fmt0(round(quantile(model$mcmc$Recr_Virgin,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)


  f.spawn.bio.bf40 <- fmt0(round(quantile(model$mcmc$SSB_SPRtgt,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  spr.msy.proxy <- c("\\textbf{--}","40\\%","\\textbf{--}")
  exp.frac.spr <- paste0(round(100*quantile(model$mcmc$Fstd_SPRtgt,prob=c(0.025,0.5,0.975)),1), "\\%")
  yield.bf40 <- fmt0(round(quantile(model$mcmc$TotYield_SPRtgt,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)

  fem.spawn.bio.b40 <- fmt0(round(quantile(model$mcmc$SSB_Btgt,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  spr.b40 <- paste0(round(100*quantile(model$mcmc$SPR_Btgt,prob=c(0.025,0.5,0.975)),1), "\\%")
  exp.frac.b40 <- paste0(round(100*quantile(model$mcmc$Fstd_Btgt,prob=c(0.025,0.5,0.975)),1), "\\%")
  yield.b40 <- fmt0(round(quantile(model$mcmc$TotYield_Btgt,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)

  fem.spawn.bio.bmsy <- fmt0(round(quantile(model$mcmc$SSB_MSY,prob=c(0.025,0.5,0.975))/2e6,3) * 1000, 0)
  spr.msy <- paste0(round(100*quantile(model$mcmc$SPR_MSY,prob=c(0.025,0.5,0.975)),1), "\\%")
  exp.frac.sprmsy <- paste0(round(100*quantile(model$mcmc$Fstd_MSY,prob=c(0.025,0.5,0.975)),1), "\\%")
  msy <- fmt0(round(quantile(model$mcmc$TotYield_MSY,prob=c(0.025,0.5,0.975))/1e6,3) * 1000, 0)

  tab <- rbind(unfish.fem.bio, unfish.recr,
               f.spawn.bio.bf40, spr.msy.proxy, exp.frac.spr, yield.bf40,
               fem.spawn.bio.b40, spr.b40, exp.frac.b40, yield.b40,
               fem.spawn.bio.bmsy, spr.msy, exp.frac.sprmsy, msy)
  descr <- c("Unfished female \\emph{B} (\\emph{B\\subscr{0}}, thousand t)",
             "Unfished recruitment (\\emph{R\\subscr{0}}, millions)",
             "Female spawning biomass (\\emph{B\\subscr{F40\\%}} thousand t)",
             "\\emph{SPR\\subscr{MSY-proxy}}",
             "Exploitation fraction corresponding to SPR",
             "Yield at \\emph{B\\subscr{F40\\%}} (thousand t)",
             "Female spawning biomass (\\emph{B\\subscr{40\\%}} thousand t)",
             "\\emph{SPR\\subscr{B40\\%}}",
             "Exploitation fraction resulting in \\emph{B\\subscr{40\\%}}",
             "Yield at \\emph{B\\subscr{40\\%}} (thousand t)",
             "Female spawning biomass (\\emph{B\\subscr{MSY}} thousand t)",
             "\\emph{SPR\\subscr{MSY}}",
             "Exploitation fraction corresponding to \\emph{SPR\\subscr{MSY}}",
             "\\emph{MSY} (thousand t)")
  tab <- cbind(descr, tab)

  colnames(tab) <- c("\\textbf{Quantity}",
                     "\\specialcell{\\textbf{2.5\\supscr{th}}\\\\\\textbf{percentile}}",
                     "\\specialcell{\\textbf{Median}}",
                     "\\specialcell{\\textbf{97.5\\supscr{th}}\\\\\\textbf{percentile}}")
  addtorow <- list()
  addtorow$pos <- list()
  addtorow$pos[[1]] <- 2
  addtorow$pos[[2]] <- 6
  addtorow$pos[[3]] <- 10
  addtorow$command <- c("\\textbf{\\underline{Reference points (equilibrium) based on \\emph{F\\subscr{40\\%}}}} \\\\",
                        "\\textbf{\\underline{Reference points (equilibrium) based on \\emph{B\\subscr{40\\%}}}} \\\\",
                        "\\textbf{\\underline{Reference points (equilibrium) based on estimated \\emph{MSY}}} \\\\")
  ## Make the size string for font and space size
  size.string <- paste0("\\fontsize{",font.size,"}{",space.size,"}\\selectfont")
  return(print(xtable(tab, caption=xcaption, label=xlabel, align=get.align(ncol(tab), just="c")),
               caption.placement = "top", include.rownames=FALSE, sanitize.text.function=function(x){x},
               size=size.string, add.to.row=addtorow, table.placement=placement))
}
