source("R/00_helpers.R")
library(readxl)
stopifnot(l10n_info()$`UTF-8`)

archivo_dic <- list.files("data/raw", pattern = "Diccionario.*aprender.*\\.xlsx$", ignore.case = TRUE, full.names = TRUE)
stopifnot("Falta el diccionario en Excel (.xlsx) en data/raw" = length(archivo_dic) == 1)
ruta <- archivo_dic
hojas <- excel_sheets(ruta)
stopifnot(length(hojas) == 16, !any(str_starts(hojas, "2025")))   # C10: no hay hoja de 2025

# Equivalencia entre bases y hojas (supuesto S3 del diseno: mismo ano y nivel)
equivalencia <- tibble::tribble(
  ~id, ~hoja,
  "2016P", "2016 Estudiantes - APRENDER Pri", "2016S", "2016 Estudiantes - APRENDER Sec",
  "2016Sm", "2016 Muestra APRENDER - Sec", "2017S", "2017 Estudiantes - APRENDER Sec",
  "2018?", "2018 Estudiantes - APRENDER", "2019S", "2019 Estudiantes - APRENDER",
  "2021P", "2021 Estudiantes - APRENDER", "2022S", "2022 Estudiantes - APRENDER",
  "2022Pm", "2022 Muestra APRENDER - Pri", "2023P", "2023 Estudiantes - APRENDER",
  "2024S", "2024 Estudiantes - APRENDER Sec", "2025P", NA_character_
)
stopifnot(all(na.omit(equivalencia$hoja) %in% hojas))

variables_hoja <- bind_rows(lapply(setdiff(hojas, "Presentacion"), \(h) {
  d <- read_excel(ruta, sheet = h, col_types = "text", .name_repair = "minimal")
  tibble(hoja = h, variables = sum(!is.na(d[[1]])))
}))
stopifnot(nrow(variables_hoja) == 15)

disponibilidad <- equivalencia |>
  left_join(variables_hoja, by = "hoja") |>
  mutate(hay_diccionario = !is.na(hoja))
hojas_sin_base <- variables_hoja |> filter(!hoja %in% equivalencia$hoja)

write_csv(disponibilidad, "output/tablas/diccionario_disponibilidad.csv")
write_csv(hojas_sin_base, "output/tablas/diccionario_hojas_sin_base.csv")
print(as.data.frame(disponibilidad), row.names = FALSE)
cat("\nHojas del diccionario sin base agregada en la carpeta:\n"); print(as.data.frame(hojas_sin_base), row.names = FALSE)
writeLines(capture.output(sessionInfo()), "output/sessioninfo_06.txt")
cat("\nFase 5 (diccionario) OK: C10 reproducido\n")
