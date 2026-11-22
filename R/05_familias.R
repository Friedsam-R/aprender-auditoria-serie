source("R/00_helpers.R")
library(tidyr)
library(ggplot2)
stopifnot(l10n_info()$`UTF-8`)

series <- cargar_series()$series
dir.create("output/figuras", showWarnings = FALSE, recursive = TRUE)

# Familia = prefijo del nombre de columna (regla 3 del diseno); sin significado semantico asegurado
familias <- bind_rows(lapply(names(series), \(id) {
  cols <- setdiff(names(series[[id]]), claves)
  tibble(id = id, columna = cols,
         familia = str_to_lower(stringi::stri_trans_general(str_replace(cols, "[_0-9].*$", ""), "Latin-ASCII")))
}))
largo <- familias |> count(id, familia, name = "columnas")

# Control: la suma de columnas por edicion coincide con las columnas de datos de cada base
control <- largo |> summarise(n = sum(columnas), .by = id) |>
  inner_join(tibble(id = names(series), esperado = vapply(series, \(d) length(setdiff(names(d), claves)), numeric(1))), by = "id")
stopifnot(all(control$n == control$esperado))
stopifnot(all(largo$columnas[largo$familia == "mdesemp"] == 4), sum(largo$familia == "mdesemp") == 12)

ediciones_por_familia <- largo |> summarise(ediciones = n_distinct(id), .by = familia) |> arrange(desc(ediciones), familia)
write_csv(largo, "output/tablas/familias_por_edicion.csv")
write_csv(ediciones_por_familia, "output/tablas/familias_resumen.csv")

orden_ids <- names(series)
frecuentes <- ediciones_por_familia |> filter(ediciones >= 4)
graf <- expand_grid(id = orden_ids, familia = frecuentes$familia) |>
  left_join(largo, by = c("id", "familia")) |>
  mutate(columnas = replace_na(columnas, 0), id = factor(id, orden_ids),
         familia = factor(familia, rev(frecuentes$familia)))

fig <- ggplot(graf, aes(x = id, y = familia)) +
  geom_tile(aes(fill = columnas > 0), color = "white") +
  geom_text(aes(label = ifelse(columnas > 0, columnas, "")), size = 2.6, color = "white") +
  scale_fill_manual(values = c(`TRUE` = paleta$azul, `FALSE` = paleta$gris_claro), guide = "none") +
  scale_x_discrete(position = "top") +
  labs(title = "Familias de variables por edición",
       subtitle = "Familias presentes en al menos 4 de las 12 bases. Número = cantidad de columnas.\nLas familias se definen por prefijo del nombre de columna y no garantizan igual significado.",
       x = NULL, y = NULL, caption = "Fuente: bases agregadas de Aprender (datos abiertos). Elaboración propia.") +
  tema_informe() + theme(panel.grid = element_blank())
alto <- max(4, 0.28 * nrow(frecuentes) + 2)
ggsave("output/figuras/fig1_familias_por_edicion.png", fig, width = 8.5, height = alto, dpi = 150, bg = "white")

print(head(as.data.frame(ediciones_por_familia), 15), row.names = FALSE)
cat("\nFamilias totales:", nrow(ediciones_por_familia), "| presentes en 12 ediciones:", sum(ediciones_por_familia$ediciones == 12),
    "| mostradas (>=4 ediciones):", nrow(frecuentes), "\n")
writeLines(capture.output(sessionInfo()), "output/sessioninfo_05.txt")
cat("Fase 5 OK\n")
