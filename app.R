install.packages(c("shiny", "Rtsne", "ggplot2", "palmerpenguins"))
library(shiny)
library(Rtsne)
library(ggplot2)
library(palmerpenguins)
penguin_data <- na.omit(palmerpenguins::penguins[, c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")])
ui <- fluidPage(
titlePanel("t-SNE Visualization of Palmer Penguins"),
sidebarLayout(
sidebarPanel(
sliderInput("perplexity", "Perplexity:",
min = 5, max = 50, value = 30, step = 1)
),
mainPanel(
plotOutput("tsnePlot")
)
)
)
server <- function(input, output) {
tsne_result <- reactive({
set.seed(42)  # Ensure reproducibility
Rtsne(penguin_data, perplexity = input$perplexity, verbose = FALSE)$Y
})
output$tsnePlot <- renderPlot({
tsne_data <- as.data.frame(tsne_result())
colnames(tsne_data) <- c("Dim1", "Dim2")
ggplot(tsne_data, aes(x = Dim1, y = Dim2)) +
geom_point(color = "blue", alpha = 0.7, size = 3) +
labs(title = paste("t-SNE with Perplexity =", input$perplexity),
x = "Dimension 1", y = "Dimension 2") +
theme_minimal()
})
}
shinyApp(ui = ui, server = server)
shiny::runApp("app.R")
