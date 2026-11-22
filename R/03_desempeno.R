source("R/00_helpers.R")
stopifnot(l10n_info()$`UTF-8`)

series <- cargar_series()$series

# C6: celdas no numericas en columnas que no son claves
no_numericas <- vapply(series, \(d) {
  cols <- setdiff(names(d), claves)
  sum(vapply(cols, \(c) {
    x <- d[[c]]
    vacio <- is.na(x) | str_squish(x) == ""
    sum(!vacio & is.na(a_numero(x)))
  }, numeric(1)))
}, numeric(1))
stopifnot(all(no_numericas == 0))

# Columnas de desempeno (C7) y totales (C9)
desempeno <- bind_rows(lapply(names(series), \(id) {
  d <- series[[id]]
  cols <- grep("^mdesemp_", names(d), value = TRUE)
  stopifnot(length(cols) == 4)
  nivel1 <- grep("Por_debajo", cols, value = TRUE)
  m <- vapply(cols, \(c) a_numero(d[[c]]), numeric(nrow(d)))
  vacios <- sum(is.na(m))
  m[is.na(m)] <- 0
  tot <- colSums(m)
  names(tot) <- c("debajo", "basico", "satisfactorio", "avanzado")[match(cols, c(nivel1, grep("^mdesemp_B", cols, value = TRUE),
    grep("Satisfactorio", cols, value = TRUE), grep("Avanzado", cols, value = TRUE)))]
  tibble(
    id = id, nombre_primer_nivel = nivel1, total_ponderado = sum(tot),
    pct_debajo = 100 * tot[["debajo"]] / sum(tot), pct_basico = 100 * tot[["basico"]] / sum(tot),
    pct_satisfactorio = 100 * tot[["satisfactorio"]] / sum(tot), pct_avanzado = 100 * tot[["avanzado"]] / sum(tot),
    filas_con_total_cero = sum(rowSums(m) == 0), celdas_vacias_en_desempeno = vacios,
    celdas_no_numericas = no_numericas[[id]]
  )
}))
stopifnot(n_distinct(desempeno$nombre_primer_nivel) == 4)
tot <- setNames(desempeno$total_ponderado, desempeno$id)
stopifnot(abs(tot[["2023P"]] - 748350) < 1, abs(tot[["2024S"]] - 540038.3) < 1, abs(tot[["2025P"]] - 752018.3) < 1)

write_csv(desempeno, "output/tablas/desempeno_por_edicion.csv")
print(as.data.frame(desempeno |> mutate(across(where(is.numeric), \(x) round(x, 2)))), row.names = FALSE)
writeLines(capture.output(sessionInfo()), "output/sessioninfo_03.txt")
cat("\nFase 3 OK: C6, C7 y C9 reproducidos (valores solo de control; no comparables entre ediciones)\n")
