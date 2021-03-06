# This file is part of POMAShiny.

# POMAShiny is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAShiny is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAShiny. If not, see <https://www.gnu.org/licenses/>.

observe_helpers(help_dir = "help_mds")

Univ_analisis <- 
  eventReactive(input$play_test,
                ignoreNULL = TRUE, {
                  withProgress(message = "Please wait",{
                    
                    data <- Outliers()$data
                    
                    ##
                    
                    if (input$univariate_test == "ttest"){
                      
                      validate(need(length(levels(as.factor(Biobase::pData(data)[,1]))) == 2, "Only two groups allowed."))
                      
                      param_ttest <- POMA::PomaUnivariate(data, method = "ttest", 
                                                          paired = input$paired_ttest, var_equal = input$var_ttest)
                      return(list(param_ttest = param_ttest))
                    }
                    
                    ##
                    
                    else if (input$univariate_test == "anova"){
                      
                      validate(need(length(levels(as.factor(Biobase::pData(data)[,1]))) > 2, "More than two groups required."))
                      
                      if(ncol(Biobase::pData(data)) > 1){
                        
                        param_anova <- POMA::PomaUnivariate(data, method = "anova")
                        param_ancova <- POMA::PomaUnivariate(data, method = "anova", covariates = TRUE)
                        return(list(param_anova = param_anova, param_ancova = param_ancova))
                      }
                      else{
                        
                        param_anova <- POMA::PomaUnivariate(data, method = "anova")
                        return(list(param_anova = param_anova))
                      }

                    }
                    
                    ##
                    
                    else if (input$univariate_test == "mann"){
                      
                      validate(need(length(levels(as.factor(Biobase::pData(data)[,1]))) == 2, "Only two groups allowed."))
                      
                      non_param_mann <- POMA::PomaUnivariate(data, method = "mann", paired = input$paired_mann)
                      return(list(non_param_mann = non_param_mann))
                      
                    }
                    
                    ##
                    
                    else if (input$univariate_test == "kruskal"){
                      
                      validate(need(length(levels(as.factor(Biobase::pData(data)[,1]))) > 2, "More than two groups required."))
                      
                      non_param_kru <- POMA::PomaUnivariate(data, method = "kruskal")
                      return(list(non_param_kru = non_param_kru))
                    }
                    })
                  })

####

output$matriu_anova <- DT::renderDataTable({
  
  param_anova <- Univ_analisis()$param_anova
  DT::datatable(param_anova,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_anova")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_anova")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_anova"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(param_anova)))
})

output$matriu_ancova <- DT::renderDataTable({
  
  param_ancova <- Univ_analisis()$param_ancova
  DT::datatable(param_ancova,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_ancova")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_ancova")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_ancova"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(param_ancova)))
})

output$matriu_ttest <- DT::renderDataTable({

  param_ttest <- Univ_analisis()$param_ttest
                
        DT::datatable(param_ttest,
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_ttest")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_ttest")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_ttest"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(param_ttest)))
})

###

output$matriu_mann <- DT::renderDataTable({
  
  non_param_mann <- Univ_analisis()$non_param_mann
    
  DT::datatable(non_param_mann, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_mann")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_mann")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_mann"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(non_param_mann)))
})

###

output$matriu_kruskal <- DT::renderDataTable({
  
  non_param_kru <- Univ_analisis()$non_param_kru
  
  DT::datatable(non_param_kru, 
                filter = 'top',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename=paste0(Sys.Date(), "POMA_kruskal")),
                                   list(extend="excel",
                                        filename=paste0(Sys.Date(), "POMA_kruskal")),
                                   list(extend="pdf",
                                        filename=paste0(Sys.Date(), "POMA_kruskal"))),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(non_param_kru)))
})

