# Diseño del proyecto 3

**Catálogo y auditoría de la serie de bases agregadas de Aprender (2016-2025): qué se puede y qué no se puede comparar entre ediciones**

Estado: v0.2 (19 de noviembre de 2026). Las fases 1 a 6 se ejecutaron en R 4.3.3 y reprodujeron los hechos C1 a C10, verificados antes en Python. La fase 7 (publicación) no se ejecutó.

Convención: **[V]** verificado, **[S]** supuesto, **[P]** pendiente.

---

## 1. Pregunta y alcance

**Pregunta.** Entre las 12 bases agregadas de Matemática de Aprender publicadas como datos abiertos, ¿qué elementos (claves geográficas, categorías, columnas de desempeño, nivel socioeconómico, familias de variables) se pueden armonizar entre ediciones, y cuáles no?

**Producto.** Un catálogo reproducible y una auditoría, con la evidencia de cada hallazgo (archivo, columna, valor).

**Fuera de alcance:** cualquier serie o comparación de desempeño entre ediciones, el emparejamiento de los ítems de los cuestionarios, Lengua, el Relevamiento Anual y cualquier juicio sobre la calidad de datos de una jurisdicción.

## 2. Reglas fijadas antes de calcular

1. **No se grafica ni se interpreta ninguna evolución del desempeño.** Se calcula el total ponderado y la distribución por nivel de cada edición solo como control interno de lectura, con la leyenda "no comparable entre ediciones".
2. **Normalización de jurisdicciones:** recortar espacios, pasar a minúsculas y quitar tildes; más dos reglas manuales ("Ciudad de Buenos Aires" equivale a "Ciudad Autónoma de Buenos Aires", y cualquier valor que empiece con "Tierra del Fuego" equivale al nombre largo de 2025). La lista canónica es la de las 24 jurisdicciones de la base de 2025.
3. **Familias de variables:** prefijo del nombre de columna (todo lo anterior al primer guion bajo o dígito), en minúsculas y sin tildes. Es una agrupación formal, **sin significado semántico asegurado**.
4. **NSE:** columnas cuyo nombre empieza con "NSE". Se clasifica por sufijo: *niveles* (Bajo, Medio, Alto) o *quintiles* (Q1 a Q5).
5. **Todo hallazgo se reporta con su evidencia** y se rotula como verificado, supuesto o pendiente.
6. Un resultado "no hay nada raro" se publica igual que uno con hallazgos.

## 3. Datos

| Edición | Nivel | Tipo | Filas × columnas | Clave de provincia |
|---|---|---|---|---|
| 2016 | Primaria | no indicado | 1.173 × 308 | `cod_provincia` |
| 2016 | Secundaria | no indicado | 1.142 × 545 | `cod_provincia` |
| 2016 | Secundaria (muestra 2°-3° año) | muestral | 86 × 522 | `cod_provincia` |
| 2017 | Secundaria | no indicado | 1.178 × 1.092 | `cod_provincia` |
| 2018 | no indicado | no indicado | 1.197 × 669 | `cod_provincia` |
| 2019 | Secundaria 5°-6° | censal | 1.178 × 1.414 | `cod_provincia` |
| 2021 | Primaria 6° | censal | 1.186 × 836 | `jurisdiccion` |
| 2022 | Secundaria 5°-6° | censal | 1.213 × 1.229 | `jurisdiccion` |
| 2022 | Primaria 6° | muestral | 84 × 603 | `jurisdiccion` |
| 2023 | Primaria 6° | censal | 1.195 × 1.022 | `jurisdiccion` |
| 2024 | Secundaria 5°-6° | censal | 1.175 × 1.035 | `jurisdiccion` |
| 2025 | Primaria 6° | censal | 1.191 × 361 | `jurisdiccion` |

Todas las dimensiones son [V]. "No indicado" significa que el nivel o el tipo no figura en el nombre del archivo; no se supone. El nivel de la base de 2018 queda como **[P]**. Más el diccionario `2011_-_2024__-_Diccionario_bases_aprender_anonimizadas.xlsx` (16 hojas).

Formato: separador `;`, decimal `,`, UTF-8 con BOM. Las dos bases muestrales (2016 secundaria y 2022 primaria) no traen `departamento`. Todas las columnas que no son claves se leen como numéricas sin celdas no numéricas, en las 12 bases [V].

## 4. Hechos verificados que el código debe reproducir

| # | Hecho | Valor |
|---|---|---|
| C1 | Cantidad de bases y dimensiones | 12, según la tabla de la sección 3 |
| C2 | Jurisdicciones distintas por edición (con la regla 2) | 24 en todas, salvo 2019: **23, falta Chubut** |
| C3 | Valores de jurisdicción distintos del canónico | 2016 primaria: "Tierra del Fuego". 2016 secundaria y su muestra, 2018 y 2019: "Buenos aires" y "Tierra del Fuego". 2017: " Buenos Aires" (con espacio inicial), "Ciudad de Buenos Aires" y "Tierra del Fuego" |
| C4 | Filas con "Sin datos" en sector y en ámbito | 2016 primaria: 1 y 1; 2016 secundaria: 1 y 1; resto: 0 |
| C5 | Etiqueta de sector | "Privada" en la muestra 2016; "Privado" en las demás |
| C6 | Celdas no numéricas en columnas de datos | 0 en las 12 bases |
| C7 | Columnas `mdesemp_*` | 4 en cada base. El primer nivel tiene cuatro nombres distintos: `Por_debajo_del_Nivel_Básico`, `Por_debajo_de_básico`, `Por_debajo_del_nivel_básico`, `Por_debajo_del_básico` |
| C8 | NSE | Sin columnas en 2016, 2017 y 2018. Quintiles en 2019 (`NSE_quintiles_Q1..Q5`). Niveles en 2021, 2022 muestral y 2023. Ambos en 2022 secundaria. Quintiles en 2024 (`NSE_nivel_Q1..Q5`) y en 2025 (`NSE_nivel_Q1_NSE_más_bajo..`) |
| C9 | Total ponderado de control | 2023 primaria, 748.350; 2024 secundaria, 540.038,3; 2025 primaria, 752.018,3 |
| C10 | Diccionario | 16 hojas (una de presentación y 15 de ediciones). No hay hoja de 2025 |

## 5. Entregables

Tablas (CSV): inventario de archivos; variantes de jurisdicción; categorías de sector y ámbito; columnas de desempeño por edición; catálogo de NSE; familias de variables por edición; disponibilidad del diccionario. Una figura (matriz de familias por edición) y un informe en Quarto con una **guía de compatibilidad** (qué se puede armonizar y qué no).

## 6. Limitaciones

1. Las familias por prefijo no garantizan que dos columnas con el mismo prefijo midan lo mismo en distintas ediciones.
2. No se empareja ningún ítem de cuestionario entre ediciones.
3. El diccionario documenta las bases de estudiantes, no necesariamente las columnas de las bases agregadas.
4. El nivel de la base de 2018 y el tipo de varias ediciones no figuran en los nombres de archivo.
5. No se evalúa la comparabilidad del desempeño: eso requiere las notas técnicas de cada edición, que no se leyeron.
6. Los hallazgos describen los archivos publicados; no explican por qué son así.

## 7. Registro de supuestos

| ID | Supuesto | Test | Si falla | Carga | Estado |
|---|---|---|---|---|---|
| S1 | `cod_provincia` contiene nombres de jurisdicción y no códigos | Valores únicos | n/a | Alta | Confirmado |
| S2 | Las dos reglas manuales de nombres son correctas | Revisión de los valores afectados | Ajustar la tabla de equivalencias | Media | Supuesto |
| S3 | Cada hoja del diccionario corresponde a la edición con el mismo año y nivel | Comparar años y niveles | Corregir la tabla | Baja | Supuesto |
| S4 | El nivel de la base de 2018 es desconocido | Consultar a la Secretaría | Declarar la limitación | Media | Pendiente |

## 8. Estructura del repositorio y hoja de ruta

Repositorio propuesto: `aprender-auditoria-serie`. Scripts `R/00_helpers.R`, `01_inventario.R`, `02_claves.R`, `03_desempeno.R`, `04_nse.R`, `05_familias.R`, `06_diccionario.R`, informe `reports/informe.qmd`, y la documentación en `docs/`.

| Fase | Contenido | Terminada cuando |
|---|---|---|
| 0 | Repo y documentación | Primer commit sin datos |
| 1 | Inventario | C1 reproducido |
| 2 | Claves y categorías | C2 a C5 reproducidos |
| 3 | Desempeño | C6, C7 y C9 reproducidos |
| 4 | NSE | C8 reproducido |
| 5 | Familias y diccionario | Tablas y figura guardadas; C10 reproducido |
| 6 | Informe Quarto | Renderiza sin errores y declara limitaciones |
| 7 | Publicación | Repo público y enlace del informe |

## 9. Estado de ejecución

- Las seis fases de código corrieron en R 4.3.3 y reprodujeron C1 a C10 [V]. Los conteos de familias por edición (103 combinaciones) y los totales ponderados coinciden con un cálculo independiente en Python [V].
- 28 familias por prefijo; solo `ap` y `mdesemp` están en las 12 bases [V].
- Hojas del diccionario sin base agregada en la carpeta: 2016 muestra primaria, 2017 primaria, 2019 muestra secundaria y 2024 primaria [V].
- No se interpretan los totales ponderados entre ediciones, y el nivel de la base de 2018 sigue sin determinar [P].
