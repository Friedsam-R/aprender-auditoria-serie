library(dplyr)
library(stringr)
library(readr)

# Paleta del proyecto (azul oscuro y grises). Inspiracion de color, sin logos ni escudos.
paleta <- list(azul = "#242C4F", gris_oscuro = "#333333", gris_medio = "#9EA1B1", gris_claro = "#E7E7E7")

tema_informe <- function() {
  ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", color = paleta$azul),
      plot.subtitle = ggplot2::element_text(color = paleta$gris_oscuro),
      plot.caption = ggplot2::element_text(color = paleta$gris_oscuro),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(color = paleta$gris_claro)
    )
}

# Recortar espacios, pasar a minusculas y quitar tildes (regla 2 del diseno)
normalizar <- function(x) {
  x |> stringi::stri_trans_general("Latin-ASCII") |> str_squish() |> str_to_lower()
}

claves <- c("cod_provincia", "jurisdiccion", "departamento", "sector", "ambito")

listar_bases <- function(dir = "data/raw") {
  f <- list.files(dir, pattern = "^20[0-9]{2}[_ ]Base[_ ]APRENDER.*\\.csv$")
  tibble(archivo = f) |>
    mutate(
      anio = as.integer(substr(archivo, 1, 4)),
      nivel = case_when(
        str_detect(archivo, "Primaria") ~ "Primaria",
        str_detect(archivo, "Secundaria") ~ "Secundaria",
        TRUE ~ "no indicado"
      ),
      tipo = case_when(
        str_detect(archivo, "Censal") ~ "censal",
        str_detect(archivo, "Muestr") ~ "muestral",
        TRUE ~ "no indicado"
      ),
      id = paste0(anio, case_when(nivel == "Primaria" ~ "P", nivel == "Secundaria" ~ "S", TRUE ~ "?"),
                  if_else(str_detect(archivo, "Muestr"), "m", ""))
    ) |>
    arrange(anio, id)
}

# trim_ws = FALSE para no perder espacios iniciales (por ejemplo " Buenos Aires" en 2017)
leer_base <- function(ruta) {
  read_delim(ruta, delim = ";", col_types = cols(.default = col_character()),
             locale = locale(decimal_mark = ",", encoding = "UTF-8"), trim_ws = FALSE)
}

a_numero <- function(x) suppressWarnings(as.numeric(str_replace(x, ",", ".")))

mapear_jurisdiccion <- function(x, canon) {
  n <- normalizar(x)
  cn <- normalizar(canon)
  out <- canon[match(n, cn)]
  out[!is.na(n) & n == "ciudad de buenos aires"] <- canon[cn == "ciudad autonoma de buenos aires"]
  out[!is.na(n) & str_detect(n, "^tierra del fuego")] <- canon[str_detect(cn, "^tierra del fuego")]
  out
}

cargar_series <- function() readRDS("data/processed/series.rds")
