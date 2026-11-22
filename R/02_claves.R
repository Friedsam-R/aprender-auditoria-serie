source("R/00_helpers.R")
library(tidyr)
stopifnot(l10n_info()$`UTF-8`)

series <- cargar_series()$series
canon <- sort(unique(series[["2025P"]]$jurisdiccion))
stopifnot(length(canon) == 24)

# Valores de jurisdiccion tal como estan en cada base
juris <- bind_rows(lapply(names(series), \(id) {
  d <- series[[id]]
  k <- intersect(c("cod_provincia", "jurisdiccion"), names(d))
  stopifnot(length(k) == 1)
  tibble(id = id, clave = k, valor_crudo = d[[k]]) |>
    filter(!is.na(valor_crudo)) |>
    count(id, clave, valor_crudo, name = "filas")
})) |>
  mutate(canonico = mapear_jurisdiccion(valor_crudo, canon), es_variante = valor_crudo != canonico)
stopifnot(!anyNA(juris$canonico))

# C2: jurisdicciones por edicion
resumen <- juris |>
  summarise(valores_distintos = n(), jurisdicciones = n_distinct(canonico),
            faltantes = paste(setdiff(canon, canonico), collapse = "; "), .by = id)
stopifnot(all(resumen$jurisdicciones[resumen$id != "2019S"] == 24), resumen$jurisdicciones[resumen$id == "2019S"] == 23,
          resumen$faltantes[resumen$id == "2019S"] == "Chubut")

# C3: variantes de ortografia
variantes <- juris |> filter(es_variante) |> select(id, valor_crudo, canonico, filas)
esperadas_var <- tibble::tribble(
  ~id, ~valor_crudo,
  "2016P", "Tierra del Fuego",
  "2016S", "Buenos aires", "2016S", "Tierra del Fuego",
  "2016Sm", "Buenos aires", "2016Sm", "Tierra del Fuego",
  "2017S", " Buenos Aires", "2017S", "Ciudad de Buenos Aires", "2017S", "Tierra del Fuego",
  "2018?", "Buenos aires", "2018?", "Tierra del Fuego",
  "2019S", "Buenos aires", "2019S", "Tierra del Fuego"
)
stopifnot(nrow(anti_join(variantes, esperadas_var, by = c("id", "valor_crudo"))) == 0,
          nrow(anti_join(esperadas_var, variantes, by = c("id", "valor_crudo"))) == 0)

# C4 y C5: categorias de sector y ambito
categorias <- bind_rows(lapply(names(series), \(id) {
  d <- series[[id]]
  bind_rows(
    count(tibble(variable = "sector", valor = d$sector), variable, valor, name = "filas"),
    count(tibble(variable = "ambito", valor = d$ambito), variable, valor, name = "filas")
  ) |> mutate(id = id, .before = 1)
}))
sin_datos <- categorias |> filter(valor == "Sin datos") |> select(id, variable, filas)
stopifnot(nrow(sin_datos) == 4, all(sin_datos$filas == 1), setequal(sin_datos$id, c("2016P", "2016S")))
sector_priv <- categorias |> filter(variable == "sector", str_detect(valor, "^Priv")) |> select(id, valor)
stopifnot(sector_priv$valor[sector_priv$id == "2016Sm"] == "Privada", all(sector_priv$valor[sector_priv$id != "2016Sm"] == "Privado"))

write_csv(resumen, "output/tablas/jurisdicciones_por_edicion.csv")
write_csv(variantes, "output/tablas/jurisdicciones_variantes.csv")
write_csv(categorias, "output/tablas/categorias_sector_ambito.csv")
print(as.data.frame(resumen), row.names = FALSE)
cat("\nVariantes de ortografia:\n"); print(as.data.frame(variantes), row.names = FALSE)
cat("\nFilas con 'Sin datos':\n"); print(as.data.frame(sin_datos), row.names = FALSE)
writeLines(capture.output(sessionInfo()), "output/sessioninfo_02.txt")
cat("\nFase 2 OK: C2 a C5 reproducidos\n")
