# Datos

Los archivos de datos **no se suben al repositorio** (`data/raw/` está en `.gitignore`).

Guardar en `data/raw/` los 12 CSV y el diccionario **con sus nombres originales de descarga**; los scripts los buscan por patrón y no hace falta renombrarlos.

| Código | Archivo | Filas × columnas |
|---|---|---|
| 2016P | `2016 Base APRENDER Primaria - Agregada - Desempeños de Matematica(in).csv` | 1.173 × 308 |
| 2016S | `2016 Base APRENDER Secundaria - Agregada - Desempeños de Matematica(in).csv` | 1.142 × 545 |
| 2016Sm | `2016 Base APRENDER Secundaria - Muestra 2-3 año - Agregada - Desempeños de Matematica(in).csv` | 86 × 522 |
| 2017S | `2017 Base APRENDER Secundaria - Agregada - Desempeños de Matematica(in).csv` | 1.178 × 1.092 |
| 2018? | `2018 Base APRENDER - Agregada - Desempeños de Matematica(in).csv` | 1.197 × 669 |
| 2019S | `2019 Base APRENDER - Censal - Secundaria 5-6 año - Agregada - Desempeños de Matematica(in).csv` | 1.178 × 1.414 |
| 2021P | `2021 Base APRENDER - Censal - Primaria 6 grado - Agregada - Desempeños de Matematica(in).csv` | 1.186 × 836 |
| 2022Pm | `2022 Base APRENDER - Muestral - Primaria 6 grado - Agregada - Desempeños de Matematica(in).csv` | 84 × 603 |
| 2022S | `2022 Base APRENDER - Censal - Secundaria 5-6 año - Agregada - Desempeños de Matematica(in).csv` | 1.213 × 1.229 |
| 2023P | `2023 Base APRENDER - Censal - Primaria 6 grado - Agregada - Desempeños de Matematica(in).csv` | 1.195 × 1.022 |
| 2024S | `2024 Base APRENDER - Censal - Secundaria 5-6 año - Agregada - Desempeños de Matematica(in).csv` | 1.175 × 1.035 |
| 2025P | `2025 Base APRENDER - Censal - Primaria 6 grado - Agregada - Desempeños de Matematica(in).csv` | 1.191 × 361 |

Más el diccionario en **Excel** (el archivo con 16 hojas, cuyo nombre es parecido a `2011 - 2024  - Diccionario bases aprender anonimizadas.xlsx`). No sirven las versiones en CSV que traen una sola hoja.

- Formato de los CSV: separador `;`, decimal `,`, UTF-8 con BOM.
- Fuente: datos abiertos de la Subsecretaría de Información y Evaluación Educativa (Secretaría de Educación de la Nación): https://www.argentina.gob.ar/educacion/evaluacion-e-informacion-educativa
- Son bases agregadas (por jurisdicción, sector y ámbito; la mayoría también por departamento) con conteos ya ponderados. Verificar los términos de uso del portal antes de reutilizar o redistribuir.
