# Funktionskatalog - Visualiseringsfunktioner

Fullständig dokumentation av funktionerna i `visualisering_interaktiva_funktioner.R`.

---

## Översikt

Detta R-skript innehåller två huvudfunktioner för att skapa interaktiva diagram i Quarto-rapporter:

1. **`skapa_tooltip()`** - Genererar HTML-formaterade tooltips
2. **`skapa_interaktiv_plot()`** - Skapar interaktiva diagram med nedladdning och helskärm

---

## skapa_tooltip()

### Beskrivning

Genererar HTML-formaterade tooltips som visas när man hovrar över datapunkter i ett giraffe-diagram. Tooltips kan innehålla både grupperingsvariabler (t.ex. region, år) och datavariabler (t.ex. antal, andel) med anpassad formatering för svenska talformat.

### Syntax

```r
skapa_tooltip(
  data,
  gruppvars,
  data_vars,
  grupp_labels = NULL,
  data_labels = NULL,
  data_format = NULL,
  decimaler = 1
)
```

### Parametrar

| Parameter | Typ | Beskrivning |
|-----------|-----|-------------|
| `data` | data.frame | Data frame med data för diagrammet |
| `gruppvars` | character | Vektor med namn på grupperingsvariabler som ska visas som rubrik i tooltip (t.ex. `c("region", "år")`) |
| `data_vars` | character | Vektor med namn på datavariabler som ska visas i tooltip-innehållet (t.ex. `c("antal", "andel")`) |
| `grupp_labels` | named character | (Valfri) Etiketter för gruppvariabler. Om NULL används variabelnamnen. Format: `c("region" = "Region", "år" = "År")` |
| `data_labels` | named character | (Valfri) Etiketter för datavariabler. Om NULL används variabelnamnen. Format: `c("antal" = "Antal", "andel" = "Andel (%)")` |
| `data_format` | named character | (Valfri) Format för varje datavariabel: "nummer", "decimal", "procent" eller "text". Om NULL används "text" för alla |
| `decimaler` | numeric | (Valfri) Antal decimaler för "decimal" och "procent"-format (default 1) |

### Formattyper

- **"nummer"**: Avrundade heltal med mellanslag som tusenavskiljare  
  Exempel: `1234` → `"1 234"`

- **"decimal"**: Decimaltal med mellanslag som tusenavskiljare och komma som decimaltecken  
  Exempel: `1234.5` → `"1 234,5"`

- **"procent"**: Som "decimal" men med %-tecken  
  Exempel: `23.4` → `"23,4 %"`

- **"text"**: Ingen formatering, visar värdet som det är  
  Exempel: `"Stockholm"` → `"Stockholm"`

### Returvärde

Data frame med en kolumn `tooltip_text` som innehåller HTML-formaterad text.

### Exempel

#### Enkel tooltip med en variabel

```r
data |>
  mutate(tooltip = skapa_tooltip(
    data = cur_data(),
    gruppvars = c("region"),
    data_vars = c("antal"),
    grupp_labels = c("region" = "Region"),
    data_labels = c("antal" = "Antal"),
    data_format = c("antal" = "nummer")
  )$tooltip_text)
```

#### Tooltip med flera variabler

```r
tooltip_data <- data |>
  skapa_tooltip(
    data = cur_data(),
    gruppvars = c("region", "år"),
    data_vars = c("antal", "andel"),
    grupp_labels = c("region" = "Region", "år" = "År"),
    data_labels = c("antal" = "Antal personer", "andel" = "Andel"),
    data_format = c("antal" = "nummer", "andel" = "procent"),
    decimaler = 1
  )

# Joina tillbaka till ursprungsdata
plot_data <- data |>
  left_join(tooltip_data, by = c("region", "år"))
```

#### Tooltip med anpassade decimaler

```r
tooltip_data <- data |>
  skapa_tooltip(
    data = cur_data(),
    gruppvars = c("månad"),
    data_vars = c("temperatur", "nederbörd"),
    data_labels = c("temperatur" = "Temperatur", "nederbörd" = "Nederbörd"),
    data_format = c("temperatur" = "decimal", "nederbörd" = "decimal"),
    decimaler = 2  # Två decimaler
  )
```

### Tooltip-design

Tooltips visas med följande design:
- Vit bakgrund med rundade hörn och skugga
- Grupperingsvariabler visas som fetstil rubrik (14px, mörkgrå)
- Datavariabler visas som brödtext (12px, mellangrå)
- Flera rader separeras med `<br/>`

### Tips och tricks

1. **Använd beskrivande etiketter**: Skriv ut hela ord istället för förkortningar
2. **Tänk på ordning**: Första gruppvariabeln visas överst i tooltip
3. **Testa formatering**: Kontrollera att decimaltal och procenttal ser rätt ut
4. **Tomma etiketter**: Om du inte vill ha etikett, sätt den till `""` istället för att utesluta den

---

## skapa_interaktiv_plot()

### Beskrivning

Omvandlar ett ggplot2-diagram till ett interaktivt giraffe-diagram med hover-effekter, nedladdningsknappar (PNG, Excel, CSV) och helskärmläge. Används främst i Quarto-rapporter för att ge användaren möjlighet att både interagera med och ladda ner diagram och underliggande data.

### Syntax

```r
skapa_interaktiv_plot(
  plot_objekt,
  export_data,
  kolumn_mappning,
  output_namn = "diagram",
  width = 8,
  height = 5,
  dpi = 300,
  hover_r = NULL,
  hover_inv_opacity = NULL,
  dropdown_id = NULL
)
```

### Parametrar

| Parameter | Typ | Beskrivning |
|-----------|-----|-------------|
| `plot_objekt` | ggplot | Ett ggplot2-objekt som ska göras interaktivt. **Viktigt**: Måste innehålla giraffe-aesthetics (`data_id` och `tooltip`) |
| `export_data` | data.frame | Data frame med data som ska kunna laddas ner (vanligtvis samma data som används i diagrammet) |
| `kolumn_mappning` | named vector/list | Mappar om kolumnnamn för export. Format: `c("gammalt_namn" = "Nytt Namn")` |
| `output_namn` | character | Filnamn för nedladdade filer (utan filändelse). Default: "diagram" |
| `width` | numeric | Bredd på diagrammet i tum (default 8) |
| `height` | numeric | Höjd på diagrammet i tum (default 5) |
| `dpi` | numeric | Upplösning för PNG-export (default 300) |
| `hover_r` | numeric | (Valfri) Radie i pixlar för hover-effekt på punkter. NULL = ingen effekt. Användbart för scatterplots (t.ex. `hover_r = 5`) |
| `hover_inv_opacity` | numeric | (Valfri) Opacitet (0-1) för icke-hovererade element. NULL = ingen effekt. Användbart för att framhäva hoverad datapunkt (t.ex. `0.3`) |
| `dropdown_id` | character | (Valfri) Unikt ID för dropdown-menyn. NULL = genereras automatiskt. Används om du vill ha flera diagram på samma sida |

### Returvärde

Ett htmltools-objekt som kan renderas direkt i Quarto.

### Exempel

#### Grundläggande linjediagram

```r
# 1. Skapa tooltip
tooltip_data <- data |>
  skapa_tooltip(
    data = cur_data(),
    gruppvars = c("år"),
    data_vars = c("antal"),
    data_format = c("antal" = "nummer")
  )

# 2. Joina tillbaka
plot_data <- data |>
  left_join(tooltip_data, by = "år")

# 3. Skapa ggplot med _interactive geoms
p <- plot_data |>
  ggplot(aes(x = år, y = antal, group = region, color = region)) +
  geom_line_interactive(aes(data_id = region, tooltip = tooltip_text)) +
  theme_minimal()

# 4. Gör interaktiv
skapa_interaktiv_plot(
  plot_objekt = p,
  export_data = plot_data,
  kolumn_mappning = c("år" = "År", "antal" = "Antal", "region" = "Region"),
  output_namn = "befolkning_utveckling"
)
```

#### Punktdiagram med hover-effekt

```r
p <- data |>
  mutate(
    tooltip = skapa_tooltip(
      cur_data(),
      gruppvars = c("stad"),
      data_vars = c("befolkning", "yta"),
      data_format = c("befolkning" = "nummer", "yta" = "decimal")
    )$tooltip_text
  ) |>
  ggplot(aes(x = yta, y = befolkning)) +
  geom_point_interactive(
    aes(data_id = stad, tooltip = tooltip),
    size = 3
  ) +
  theme_minimal()

skapa_interaktiv_plot(
  plot_objekt = p,
  export_data = data,
  kolumn_mappning = c("stad" = "Stad", "befolkning" = "Befolkning"),
  output_namn = "stad_jamforelse",
  hover_r = 5,              # Förstora punkter vid hover
  hover_inv_opacity = 0.3   # Tona ner andra punkter
)
```

#### Stapeldiagram med anpassad storlek

```r
p <- data |>
  ggplot(aes(x = kategori, y = värde)) +
  geom_col_interactive(
    aes(data_id = kategori, tooltip = tooltip_text),
    fill = "#0076bc"
  ) +
  theme_minimal()

skapa_interaktiv_plot(
  plot_objekt = p,
  export_data = data,
  kolumn_mappning = c("kategori" = "Kategori", "värde" = "Värde"),
  output_namn = "fordelning",
  width = 10,   # Bredare diagram
  height = 6    # Högre diagram
)
```

### Vad funktionen skapar

1. **Interaktivt diagram**: Via giraffe-paketet med hover-effekter
2. **Dropdown-meny** med tre nedladdningsalternativ:
   - **PNG**: Högupplöst bild av diagrammet (300 DPI)
   - **Excel**: Data i .xlsx-format
   - **CSV**: Data i .csv-format
3. **Helskärmsknapp**: Visa diagrammet i fullskärm

### Tekniska detaljer

- Skapar en temporär mapp `temp_plots/` för PNG-filer
- Använder JavaScript för dropdown och helskärmsfunktionalitet
- Genererar unika ID:n för att undvika konflikter mellan diagram
- Tooltips visas med transparent bakgrund och följer muspekaren
- Hover-effekter styrs via CSS (`fill-opacity`, `stroke-width`, `r`, `opacity`)

### Krav för interaktivitet

För att hover-effekter ska fungera måste diagrammet innehålla:

1. **Interactive geoms**: Använd `*_interactive()` versioner
   - `geom_line_interactive()`
   - `geom_point_interactive()`
   - `geom_col_interactive()`
   - `geom_bar_interactive()`
   - `geom_area_interactive()`
   - `geom_sf_interactive()` (för kartor)

2. **Aesthetics**: Lägg till `data_id` och `tooltip` i `aes()`
   ```r
   geom_line_interactive(
     aes(data_id = variabel, tooltip = tooltip_text)
   )
   ```

### Tips och tricks

1. **Hover-radie**: Använd `hover_r` för punktdiagram för bättre användarupplevelse
2. **Tona ner**: Använd `hover_inv_opacity` för att framhäva hoverad datapunkt
3. **Filnamn**: Välj beskrivande `output_namn` så det är tydligt vad som laddas ner
4. **Kolumnnamn**: Använd `kolumn_mappning` för att göra exporterad data användarvänlig
5. **Flera diagram**: Om du har många diagram på samma sida, överväg att sätta unika `dropdown_id`

### Vanliga fel

| Problem | Orsak | Lösning |
|---------|-------|---------|
| Tooltip visas inte | Glömt `_interactive` i geom | Använd `geom_*_interactive()` |
| Hover fungerar inte | `data_id` eller `tooltip` saknas | Lägg till i `aes()` |
| Fel vid nedladdning | `temp_plots/` kan inte skapas | Kontrollera skrivbehörigheter |
| Fel kolumnnamn | `kolumn_mappning` matchar inte data | Verifiera att kolumnnamnen stämmer |

---

## Komplett arbetsflöde

Här är ett komplett exempel som visar hur båda funktionerna används tillsammans:

```r
# 0. LADDA PAKET OCH FUNKTIONER
library(tidyverse)
library(ggiraph)
library(downloadthis)
source("R/functions/visualisering_interaktiva_funktioner.R")

# 1. FÖRBERED DATA
data <- tibble(
  år = 2015:2024,
  befolkning = c(1000, 1100, 1150, 1200, 1300, 1350, 1400, 1450, 1500, 1550),
  region = "Göteborg"
)

# 2. SKAPA TOOLTIP
tooltip_data <- data |>
  skapa_tooltip(
    data = cur_data(),
    gruppvars = c("år", "region"),
    grupp_labels = c("år" = "År", "region" = "Region"),
    data_vars = c("befolkning"),
    data_labels = c("befolkning" = "Befolkning"),
    data_format = c("befolkning" = "nummer")
  )

# 3. JOINA TILLBAKA
plot_data <- data |>
  left_join(tooltip_data, by = c("år", "region"))

# 4. SKAPA GGPLOT MED INTERACTIVE GEOMS
plot <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(
    aes(data_id = år, tooltip = tooltip_text),
    linewidth = 0.6,
    color = "#0076bc"
  ) +
  geom_point_interactive(
    aes(data_id = år, tooltip = tooltip_text),
    size = 2,
    color = "#0076bc"
  ) +
  scale_y_continuous(
    labels = scales::comma_format(big.mark = " "),
    expand = expansion(mult = c(0, 0.1))
  ) +
  labs(
    title = "Befolkningsutveckling över tid",
    subtitle = "Göteborg, 2015-2024",
    x = "",
    y = "Antal invånare",
    caption = "Källa: SCB"
  ) +
  theme_minimal()

# 5. GÖR INTERAKTIV
skapa_interaktiv_plot(
  plot_objekt = plot,
  export_data = plot_data,
  kolumn_mappning = c(
    "År" = "år",
    "Befolkning" = "befolkning",
    "Region" = "region"
  ),
  output_namn = "befolkning_utveckling",
  width = 8,
  height = 5,
  hover_r = 3
)
```

---

## Felsökning

### Tooltip visas inte

**Symptom**: Inga tooltips visas när du hovrar över diagram

**Möjliga orsaker och lösningar**:

1. Använder standard geom istället för interactive:
   ```r
   # FEL
   geom_line()
   
   # RÄTT
   geom_line_interactive()
   ```

2. Tooltip inte mappad i aes():
   ```r
   # FEL
   geom_line_interactive(aes(data_id = år))
   
   # RÄTT
   geom_line_interactive(aes(data_id = år, tooltip = tooltip_text))
   ```

3. Tooltip-data inte joinad:
   ```r
   # Glöm inte att joina!
   plot_data <- data |>
     left_join(tooltip_data, by = "år")
   ```

### Fel vid nedladdning

**Symptom**: Felmeddelande när du försöker ladda ner PNG

**Lösning**: Funktionen skapar automatiskt `temp_plots/`, men om fel uppstår:
```r
dir.create("temp_plots", showWarnings = FALSE)
```

### Konstiga tecken i tooltips

**Symptom**: Å, Ä, Ö visas fel

**Lösning**: Se till att filen sparas med UTF-8 encoding:
```r
source("R/functions/visualisering_interaktiva_funktioner.R", encoding = "UTF-8")
```

---

## Best practices

1. **Testa tooltips först**: Skapa enkla tooltips innan du gör komplexa
2. **Använd beskrivande namn**: Både i `data_labels` och `kolumn_mappning`
3. **Formatera konsekvent**: Använd samma format för liknande variabler
4. **Dokumentera**: Kommentera vad varje chunk gör
5. **Rendera ofta**: Fånga fel tidigt genom att rendera ofta
6. **Följ kodprinciper**: Se `kodprinciper_r_goteborg.md`

---

## Versionshistorik

**Version 1.0** (2025-12-01)
- Första versionen av funktionerna
- Stöd för interaktiva diagram med tooltips
- Nedladdning av PNG, Excel och CSV
- Helskärmsläge

---

*För frågor eller förbättringsförslag, kontakta: statistisk.analys@stadshuset.goteborg.se*
