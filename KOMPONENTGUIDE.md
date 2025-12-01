# Komponentguide - Quarto-rapportmall

Guide för hur du använder de olika komponenterna i mallen.

---

## Highlight-box

### Vad är det?
En markerad ruta för att framhäva viktig information.

### När använder jag det?
- Viktiga notiser till läsaren
- Användarinstruktioner
- Sammanfattningar
- Kontaktinformation

### Syntax

```markdown
::: highlight-box
## Rubrik här

Text och innehåll här. Du kan använda:
- Punktlistor
- **Fetstil**
- Länkar

## Fler rubriker om du vill
:::
```

### Exempel 1: Användarinstruktion

```markdown
::: highlight-box
## Såhär använder du rapporten

- Hovra över diagram för mer information
- Klicka på nedladdningsknappen för att spara
- Använd innehållsförteckningen för navigation
:::
```

### Exempel 2: Viktig notis

```markdown
::: highlight-box
## OBS: Preliminära siffror

Dessa siffror är preliminära och kan komma att revideras.
Slutliga siffror publiceras 15 mars 2025.
:::
```

### Styling

Highlight-box stylas i `styles.css`:
- Bakgrund: `#D4DDE3` (ljusgrå/blå)
- Kant: `#3F5664` (mörkblå)
- Rundade hörn med padding

---

## Panel-tabset

### Vad är det?
Flikar som låter dig visa olika vyer av samma data eller olika diagram.

### När använder jag det?
- Jämföra antal vs andel
- Visa olika regioner
- Olika tidperioder
- Alternativa visualiseringar

### Syntax

```markdown
::: panel-tabset
### Flik 1

Innehåll för första fliken

### Flik 2

Innehåll för andra fliken

### Flik 3

Innehåll för tredje fliken
:::
```

### Exempel 1: Antal vs Andel

```markdown
::: panel-tabset
### Antal

```{r}
# Diagram med absoluta tal
ggplot(data, aes(x = kategori, y = antal)) +
  geom_col()
```

### Andel

```{r}
# Diagram med andelar
ggplot(data, aes(x = kategori, y = andel)) +
  geom_col()
```
:::
```

### Exempel 2: Regionsjämförelser

```markdown
::: panel-tabset
### Göteborg
Diagram och text om Göteborg

### Stockholm  
Diagram och text om Stockholm

### Malmö
Diagram och text om Malmö
:::
```

### Tips
- Använd tydliga fliknamn
- Håll innehållet konsekvent mellan flikar
- Max 4-5 flikar för läsbarhet

---

## Interaktiva diagram

### Grundkomponenter

Varje interaktivt diagram består av 4 steg:

#### Steg 1: Skapa tooltip

```r
tooltip_data <- data |>
  skapa_tooltip(
    gruppvars = c("år"),              # Gruppering
    grupp_labels = c(år = "År"),      # Etiketter
    data_vars = c("befolkning"),      # Data
    data_labels = c(befolkning = "Befolkning"),
    data_format = c(befolkning = "nummer")
  )
```

#### Steg 2: Joina tooltip

```r
plot_data <- data |>
  left_join(tooltip_data, by = "år")
```

#### Steg 3: Skapa ggplot

```r
plot <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(
    aes(data_id = år, tooltip = tooltip_text)
  ) +
  theme_minimal()
```

**OBS**: Använd alltid `*_interactive` versioner!

#### Steg 4: Gör interaktiv

```r
skapa_interaktiv_plot(
  plot_objekt = plot,
  export_data = plot_data,
  kolumn_mappning = c("År" = "år", "Befolkning" = "befolkning"),
  output_namn = "diagram_namn"
)
```

### Geom-typer som fungerar

| Geom | Interactive version | Användning |
|------|---------------------|------------|
| `geom_line()` | `geom_line_interactive()` | Tidsserier |
| `geom_point()` | `geom_point_interactive()` | Punktdiagram |
| `geom_col()` | `geom_col_interactive()` | Stapeldiagram |
| `geom_bar()` | `geom_bar_interactive()` | Stapeldiagram |
| `geom_area()` | `geom_area_interactive()` | Ytdiagram |
| `geom_sf()` | `geom_sf_interactive()` | Kartor |

### Tooltip-format

| Format | Exempel input | Exempel output |
|--------|---------------|----------------|
| `"nummer"` | `1234` | `"1 234"` |
| `"decimal"` | `1234.5` | `"1 234,5"` |
| `"procent"` | `23.4` | `"23,4 %"` |
| `"text"` | `"Stockholm"` | `"Stockholm"` |

### Hover-effekter

```r
# Förstora punkter vid hover
skapa_interaktiv_plot(
  ...,
  hover_r = 5  # Radie i pixlar
)

# Tona ner andra element
skapa_interaktiv_plot(
  ...,
  hover_inv_opacity = 0.3  # 0 = osynlig, 1 = fullt synlig
)
```

---

## Kodchunks

### Chunk-options

Använd `#|` syntax (modern Quarto):

```r
```{r}
#| label: mitt-diagram
#| fig-cap: "Detta är en bildtext"
#| fig-width: 8
#| fig-height: 5
#| echo: false
#| warning: false

# Din kod här
```
```

### Användbara options

| Option | Värden | Beskrivning |
|--------|--------|-------------|
| `label` | text | Unikt namn (obligatoriskt för figurer) |
| `echo` | true/false | Visa kod i output? |
| `warning` | true/false | Visa varningar? |
| `message` | true/false | Visa meddelanden? |
| `fig-cap` | text | Bildtext |
| `fig-width` | nummer | Bredd i tum |
| `fig-height` | nummer | Höjd i tum |
| `include` | true/false | Inkludera chunk i output? |

---

## Länkar och referenser

### Interna länkar

```markdown
Se [Avsnitt 2](#avsnitt-2) för mer information.

## Avsnitt 2
```

### Externa länkar

```markdown
[Göteborgs Stad](https://goteborg.se)
```

### Bilder

```markdown
![Bildtext](sökväg/till/bild.png)

<!-- Med storlek -->
![Bildtext](sökväg/till/bild.png){width=50%}
```

---

## Formatering

### Text

```markdown
**Fetstil**
*Kursiv*
`Kod inline`
~~Genomstruken~~
```

### Listor

```markdown
**Punktlista:**
- Punkt 1
- Punkt 2
  - Underpunkt

**Numrerad lista:**
1. Första
2. Andra
3. Tredje
```

### Citat

```markdown
> Detta är ett citat
> som kan sträcka sig över flera rader
```

---

## Best practices

### Struktur

✅ **Gör:**
- Använd tydliga sektionsrubriker
- Numrera chunks beskrivande
- Håll chunks fokuserade (en uppgift per chunk)
- Kommentera komplex kod

❌ **Undvik:**
- Långa chunks (>50 rader)
- Generiska chunk-labels (`chunk1`, `chunk2`)
- Kod utan kommentarer

### Diagram

✅ **Gör:**
- Använd beskrivande titlar och captions
- Formatera axlar läsbart
- Välj färger med kontrast i åtanke
- Testa tooltips

❌ **Undvik:**
- Fler än 7 färger i samma diagram
- Småttryckta etiketter
- Diagram utan titel

### Innehåll

✅ **Gör:**
- Skriv för din målgrupp
- Förklara vad diagram visar
- Ange källor
- Använd highlight-box för viktigt

❌ **Undvik:**
- Diagram utan kontext
- Jargong utan förklaring
- Långa textstycken utan struktur

---

## Snabbreferens

### Tooltip-mall

```r
tooltip_data <- DATA |>
  skapa_tooltip(
    gruppvars = c("GRUPPERING"),
    grupp_labels = c(GRUPPERING = "Etikett"),
    data_vars = c("DATAVARIABEL"),
    data_labels = c(DATAVARIABEL = "Etikett"),
    data_format = c(DATAVARIABEL = "nummer/decimal/procent/text")
  )
```

### Interaktivt diagram-mall

```r
# 1. Tooltip
tooltip_data <- data |> skapa_tooltip(...)

# 2. Join
plot_data <- data |> left_join(tooltip_data, by = "...")

# 3. ggplot
plot <- plot_data |>
  ggplot(aes(...)) +
  geom_X_interactive(aes(data_id = ..., tooltip = tooltip_text))

# 4. Interaktiv
skapa_interaktiv_plot(
  plot_objekt = plot,
  export_data = plot_data,
  kolumn_mappning = c("Ny" = "gammal"),
  output_namn = "namn"
)
```

### Highlight-box mall

```markdown
::: highlight-box
## Rubrik

Innehåll
:::
```

### Panel-tabset mall

```markdown
::: panel-tabset
### Flik 1
Innehåll

### Flik 2
Innehåll
:::
```

---

**För fler exempel, se:**
- `examples/01_enkel_rapport.qmd`
- `examples/02_fullstandig_rapport.qmd`
- `template/rapport_mall.qmd`
