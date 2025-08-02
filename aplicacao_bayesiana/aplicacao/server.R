
function(input, output, session) {

  # Separar os inputs para facilitar o layout lado a lado
  output$input_rho <- renderUI({
    req(input$crit)
    label <- if (input$crit == "ACC") "Minimum admissible probability:" else "Minimum coverage probability:"
    numericInput("rho", label, value = 0.9, min = 0, max = 1, step = 0.01)
  })
  
  output$input_len <- renderUI({
    req(input$crit)
    label <- if (input$crit == "ACC") "Interval length:" else "Maximum admissible length:"
    numericInput("len", label, value = 0.25, min = 0.01, max = 1, step = 0.01)
  })
  
  resultado_texto <- eventReactive(input$estimar, {
    validate(
      need(!is.null(input$crit), "Selecione o critério."),
      need(!is.null(input$c) && input$c > 0, "Informe um valor válido para c."),
      need(!is.null(input$d) && input$d > 0, "Informe um valor válido para d."),
      need(!is.null(input$rho) && input$rho >= 0 && input$rho <= 1, "Informe um valor de rho válido."),
      need(!is.null(input$len) && input$len > 0 && input$len <= 1, "Informe um valor de comprimento válido.")
    )
    

    n_estimado <- if (input$crit == "ACC") {
      mss.bb(
        crit = "ACC",
        c = input$c,
        d = input$d,
        rho.min = input$rho,
        len = input$len,
        R = 1000
      )
    } else {
      mss.bb(
        crit = "ALC",
        c = input$c,
        d = input$d,
        rho = input$rho,
        len.max = input$len,
        R = 1000
      )
    }
    
    paste0("The minimum sample size is ", as.character(n_estimado), ".", collapse = "\n")
  })
  
  output$resultado <- renderText({
    resultado_texto()
  })
  
  output$grafico_beta <- renderPlot({
    req(input$estimar)  
    
    validate(
      need(!is.null(input$c) && input$c > 0, ""),
      need(!is.null(input$d) && input$d > 0, "")
    )
    
    theta <- seq(0, 1, length.out = 1000)
    dens <- dbeta(theta, shape1 = input$c, shape2 = input$d)
    df <- data.frame(theta = theta, densidade = dens)
    
    ggplot(df, aes(x = theta, y = densidade)) +
      geom_line(color = "blue", size = 1) +
      labs(
        title = bquote("Beta(" * .(input$c) * ", " * .(input$d) * ")"),
        x = expression(theta),
        y = expression(pi*(theta))
      ) +
      theme_bw()
  })
  
  #################################
  
  output$input_ic_dinamico <- renderUI({
    req(input$crit_ic)
    
    if (input$crit_ic == "ACC") {
      numericInput("valor_ic", "Interval length:", value = NULL, min = 0.01, max = 1, step = 0.01)
    } else {
      numericInput("valor_ic", "Min. coverage probability:", value = NULL, min = 0, max = 1, step = 0.01)
    }
  })
  
  resultado_ic <- eventReactive(input$calcular_ic, {
    validate(
      need(!is.null(input$crit_ic), "Select a criterion."),
      need(!is.null(input$c_ic) && input$c_ic > 0, "Insert a valid value for c."),
      need(!is.null(input$d_ic) && input$d_ic > 0, "Insert a valid value for d."),
      need(!is.null(input$xn_ic) && input$xn_ic >= 0, "Insert a valid value for Number of successes."),
      need(!is.null(input$n_ic) && input$n_ic > 1, "Insert a valid value for Sample size."),
      need(input$xn_ic <= input$n_ic, "The number of successes cannot be greater than the sample size.")
    )
    
    a_post <- input$c_ic + input$xn_ic
    b_post <- input$d_ic + input$n_ic - input$xn_ic
    
    if (input$crit_ic == "ACC") {
      hd.beta(c = a_post, d = b_post, len = input$valor_ic)
    } else {
      hd.beta(c = a_post, d = b_post, rho = input$valor_ic)
    }
    
  })
  
  output$resultado_ic <- renderText({
    intervalo <- resultado_ic()
    lim_inf <- intervalo[1]
    lim_sup <- intervalo[2]
    
    paste0(
      "The credible interval for θ with probability equals to 95% is [",
      round(lim_inf, 4), "; ",
      round(lim_sup, 4), "]."
    )
  })
  
  output$grafico_ic <- renderPlot({
    intervalo <- resultado_ic()
    req(intervalo)
    
    a_post <- input$c_ic + input$xn_ic
    b_post <- input$d_ic + input$n_ic - input$xn_ic
    
    theta <- seq(0, 1, length.out = 1000)
    dens <- dbeta(theta, shape1 = a_post, shape2 = b_post)
    df <- data.frame(theta = theta, densidade = dens)
    
    intervalo <- resultado_ic()
    lim_inf <- intervalo[1]
    lim_sup <- intervalo[2]
    
    df_intervalo <- df %>% 
      filter(theta >= lim_inf & theta <= lim_sup)
    
    ggplot(df, aes(x = theta, y = densidade)) +
      geom_area(data = df_intervalo, fill = "darkgreen", alpha = 0.5) +
      geom_line(color = "darkgreen", size = 1.2) +
      geom_vline(xintercept = c(lim_inf, lim_sup), linetype = "dashed", color = "red") +
      annotate("text", x = lim_inf, y = max(dens), 
               label = paste0("", round(lim_inf, 3)), 
               hjust = 1.1, color = "black") +
      annotate("text", x = lim_sup, y = max(dens), 
               label = paste0("", round(lim_sup, 3)), 
               hjust = -0.1, color = "black") +
      labs(
        title = bquote("Beta(" * .(a_post) * ", " * .(b_post) * ")"),
        x = expression(theta),
        y = bquote(pi(theta ~ "|" ~ x[n]))
      ) +
      theme_bw()
  })
  
  
  hide(id = "loading-content", anim = TRUE, animType = "fade")

}
