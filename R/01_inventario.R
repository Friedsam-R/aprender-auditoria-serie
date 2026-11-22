source("R/00_helpers.R")
stopifnot(l10n_info()$`UTF-8`)

cat_bases <- listar_bases()
stopifnot(nrow(cat_bases) == 12, !anyDuplicated(cat_bases$id))

series <- lapply(cat_bases$archivo, \(f) leer_base(file.path("data/raw", f)))
names(series) <- cat_bases$id

inventario <- cat_bases |>
  mutate(
    filas = vapply(series, nrow, numeric(1))[id],
    columnas = vapply(series, ncol, numeric(1))[id],
    clave_provincia = vapply(series, \(d) intersect(c("cod_provincia", "jurisdiccion"), names(d))[1], character(1))[id],
    tiene_departamento = vapply(series, \(d) "departamento" %in% names(d), logical(1))[id]
  ) |>
  select(id, anio, nivel, tipo, filas, columnas, clave_provincia, tiene_departamento, archivo)

# C1: dimensiones esperadas
esperadas <- tibble::tribble(
  ~id, ~filas, ~columnas,
  "2016P", 1173, 308, "2016S", 1142, 545, "2016Sm", 86, 522, "2017S", 1178, 1092,
  "2018?", 1197, 669, "2019S", 1178, 1414, "2021P", 1186, 836, "2022S", 1213, 1229,
  "2022Pm", 84, 603, "2023P", 1195, 1022, "2024S", 1175, 1035, "2025P", 1191, 361
)
chequeo <- inventario |> inner_join(esperadas, by = "id", suffix = c("", "_esp"))
stopifnot(nrow(chequeo) == 12, all(chequeo$filas == chequeo$filas_esp), all(chequeo$columnas == chequeo$columnas_esp))
# Las dos muestrales no traen departamento
stopifnot(identical(sort(inventario$id[!inventario$tiene_departamento]), c("2016Sm", "2022Pm")))

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
dir.create("output/tablas", showWarnings = FALSE, recursive = TRUE)
saveRDS(list(catalogo = cat_bases, series = series), "data/processed/series.rds")
write_csv(inventario, "output/tablas/inventario_archivos.csv")
print(as.data.frame(select(inventario, -archivo)), row.names = FALSE)
writeLines(capture.output(sessionInfo()), "output/sessioninfo_01.txt")
cat("\nFase 1 OK: 12 bases, dimensiones C1 reproducidas\n")
