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

observe({
  
  data <- Outliers()$norm_table %>% select_if(is.numeric)
  x <- colnames(data)
  
  updateSelectizeInput(session, "sel_boxplot", choices = x, selected = NULL)
  
})

##

output$boxPlotly <- renderPlotly({
  
  to_boxplot <- Outliers()$data
  to_boxplot <- POMA::PomaBoxplots(to_boxplot, group = "features", feature_name = input$sel_boxplot, jitter = input$jitter_bx) + 
    theme(legend.title = element_blank())
  
  if(isTRUE(input$split_bx)){
    ggplotly(to_boxplot + theme(axis.title.y = element_blank())) %>% layout(boxmode = "group") %>% plotly::config(
      toImageButtonOptions = list(format = "png"),
      displaylogo = FALSE,
      collaborate = FALSE,
      modeBarButtonsToRemove = c(
        "sendDataToCloud", "zoom2d", "select2d",
        "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
      )
    )
  }
  else{
    ggplotly(to_boxplot + theme(axis.title.y = element_blank())) %>% plotly::config(
      toImageButtonOptions = list(format = "png"),
      displaylogo = FALSE,
      collaborate = FALSE,
      modeBarButtonsToRemove = c(
        "sendDataToCloud", "zoom2d", "select2d",
        "lasso2d", "autoScale2d", "hoverClosestCartesian", "hoverCompareCartesian"
      )
    )
  }

})

