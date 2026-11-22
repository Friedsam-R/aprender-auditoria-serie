source("R/00_helpers.R")
stopifnot(l10n_info()$`UTF-8`)

series <- cargar_series()$series

nse <- bind_rows(lapply(names(series), \(id) {
  cols <- grep("^NSE", names(series[[id]]), value = TRUE)
  niveles <- any(str_detect(cols, "^NSE_nivel_(Bajo|Medio|Alto)$"))
  quintiles <- any(str_detect(cols, "Q[1-5]"))
  tibble(
    id = id, columnas_nse = length(cols),
    tipo = case_when(niveles & quintiles ~ "niveles y quintiles", niveles ~ "niveles", quintiles ~ "quintiles", TRUE ~ "ninguno"),
    nombres = paste(cols, collapse = " | ")
  )
}))

esperado <- tibble::tribble(
  ~id, ~tipo,
  "2016P", "ninguno", "2016S", "ninguno", "2016Sm", "ninguno", "2017S", "ninguno", "2018?", "ninguno",
  "2019S", "quintiles", "2021P", "niveles", "2022S", "niveles y quintiles", "2022Pm", "niveles",
  "2023P", "niveles", "2024S", "quintiles", "2025P", "quintiles"
)
chk <- inner_join(nse, esperado, by = "id", suffix = c("", "_esp"))
stopifnot(nrow(chk) == 12, all(chk$tipo == chk$tipo_esp))

write_csv(nse, "output/tablas/nse_por_edicion.csv")
print(as.data.frame(select(nse, id, columnas_nse, tipo)), row.names = FALSE)
writeLines(capture.output(sessionInfo()), "output/sessioninfo_04.txt")
cat("\nFase 4 OK: C8 reproducido\n")
