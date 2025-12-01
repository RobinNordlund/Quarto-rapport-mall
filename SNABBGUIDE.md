# Snabbguide - Kom igång på 5 minuter

Denna guide tar dig från noll till en färdig Quarto-rapport med interaktiva diagram.

---

## Steg 1: Kopiera mallen (1 minut)

### I RStudio

1. **Skapa nytt RStudio-projekt**
   - File > New Project > New Directory > New Project
   - Namnge projektet (t.ex. "befolkning_analys_2025")

2. **Kopiera template-filer**
   ```r
   # Kör i R Console
   file.copy(
     from = "sökväg/till/quarto-rapport-mall/template",
     to = ".",
     recursive = TRUE
   )
   ```

3. **Kopiera R-funktioner**
   ```r
   dir.create("R/functions", recursive = TRUE)
   file.copy(
     from = "sökväg/till/quarto-rapport-mall/R/functions/visualisering_interaktiva_funktioner.R",
     to = "R/functions/"
   )
   ```

### Alternativt: I Terminal/Kommandotolk

```bash
# Skapa projektmapp
mkdir min-rapport
cd min-rapport

# Kopiera filer
cp -r ../quarto-rapport-mall/template/* .
mkdir -p R/functions
cp ../quarto-rapport-mall/R/functions/visualisering_interaktiva_funktioner.R R/functions/
```

---

## Steg 2: Anpassa innehåll (2 minuter)

### Öppna och anpassa rapport_mall.qmd

```yaml
---
title: "Din rapporttitel här"           # ÄNDRA
author: "Ditt namn"                     # ÄNDRA
date: today                             # Visar dagens datum automatiskt
format:
  html:
    css: styles/styles.css
    toc: true
    toc-depth: 2
    toc-title: "Innehåll:"
    toc-location: right
execute:
  echo: false
lang: sv
---
```

### Byt rapporthuvud (valfritt)

1. Ersätt `assets/rapporthuvud.svg` med din egen bild
2. Eller behåll den befintliga

### Ladda dina funktioner

I första R-chunken:

```r
# Ladda nödvändiga funktioner
source("R/functions/visualisering_interaktiva_funktioner.R")

# Om du använder MASTERSCRIPT från Göteborgs Stad
source("sökväg/till/MASTERSCRIPT.R", encoding = 'UTF-8')

# Ladda paket
library(tidyverse)
library(ggiraph)
library(downloadthis)
library(htmltools)
library(glue)
```

---

## Steg 3: Skapa ditt första interaktiva diagram (2 minuter)

### Mall för interaktivt linjediagram

```r
# 1. SKAPA TOOLTIP
tooltip_data <- din_data |>
  skapa_tooltip(
    gruppvars = c("år"),                    # Gruppering (visas som rubrik)
    grupp_labels = c(år = "År"),           # Etiketter för gruppering
    data_vars = c("befolkning"),           # Datavärden (visas som innehåll)
    data_labels = c(befolkning = "Befolkning"),
    data_format = c(befolkning = "nummer")  # Format: nummer/decimal/procent/text
  )

# 2. JOINA TILLBAKA TILL DATA
plot_data <- din_data |>
  left_join(tooltip_data, by = "år")

# 3. SKAPA GGPLOT MED _INTERACTIVE
plot <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(
    aes(tooltip = tooltip_text, data_id = år),
    linewidth = 0.6
  ) +
  labs(
    title = "Befolkningsutveckling",
    x = "",
    y = "Antal"
  ) +
  theme_minimal()

# 4. GÖR INTERAKTIV MED NEDLADDNING
skapa_interaktiv_plot(
  plot_objekt = plot,
  export_data = plot_data,
  kolumn_mappning = c("År" = "år", "Befolkning" = "befolkning"),
  output_namn = "befolkning_utveckling",
  width = 8,
  height = 5
)
```

### Sätt in i din rapport

```markdown
## Min första analys

Här är befolkningsutvecklingen:

```{r}
#| label: befolkning-diagram

# Din kod här (från ovan)
```
```

---

## Steg 4: Använd färdiga komponenter

### Highlight-box (för viktig information)

```markdown
::: highlight-box
## OBS: Viktig information

- Punktlista med viktig info
- Något användaren måste veta
:::
```

### Panel-tabset (för flikar)

```markdown
::: panel-tabset
### Flik 1
Innehåll för första fliken

### Flik 2
Innehåll för andra fliken
:::
```

---

## Steg 5: Rendera rapporten

### I RStudio

1. **Klicka på "Render" knappen** (eller Ctrl/Cmd + Shift + K)
2. Rapporten öppnas automatiskt i Viewer eller webbläsare

### I R Console

```r
quarto::quarto_render("rapport_mall.qmd")
```

### I Terminal

```bash
quarto render rapport_mall.qmd
```

---

## Nästa steg

### Utforska exempel

Se `examples/` för konkreta exempel:
- `01_enkel_rapport.qmd` - Minimal version
- `02_fullstandig_rapport.qmd` - Alla features

### Läs dokumentation

- [funktioner_katalog.md](docs/funktioner_katalog.md) - Alla funktioner dokumenterade
- [README.md](README.md) - Fullständig översikt

### Anpassa efter behov

1. **Ändra färger**: Redigera `styles/styles.css`
2. **Lägg till fler funktioner**: Utöka `visualisering_interaktiva_funktioner.R`
3. **Anpassa layout**: Ändra `_quarto.yml`

---

## Vanliga fel och lösningar

### "Funktionen hittas inte"

**Problem:** `skapa_interaktiv_plot()` finns inte

**Lösning:**
```r
# Kontrollera att source() körs FÖRE användning
source("R/functions/visualisering_interaktiva_funktioner.R")
```

### "Tooltip visas inte"

**Problem:** Hover-effekt fungerar inte

**Lösning:**
- Använd `geom_*_interactive()` istället för `geom_*()`
- Se till att `aes(tooltip = tooltip_text, data_id = ...)` är mappat
- Verifiera att `tooltip_data` har joimats korrekt

### "CSS fungerar inte"

**Problem:** Styling visas inte

**Lösning:**
```yaml
# Kontrollera att sökvägen är korrekt i YAML
format:
  html:
    css: styles/styles.css  # Relativ sökväg från .qmd-fil
```

### "Temp-mapp saknas"

**Problem:** Fel vid nedladdning av PNG

**Lösning:**
```r
# Funktionen skapar mappen automatiskt, men om fel uppstår:
dir.create("temp_plots", showWarnings = FALSE)
```

---

## Tips för effektivt arbete

### Arbetsgång

1. ✅ Börja med mall
2. ✅ Testa ett enkelt diagram först
3. ✅ Bygg vidare gradvis
4. ✅ Rendera ofta för att fånga fel tidigt

### Kodning

- 💡 Kommentera din kod
- 💡 Ge chunks beskrivande labels
- 💡 Använd `#|` för chunk-options (modern syntax)
- 💡 Dela upp komplexa pipes i steg vid felsökning

### Organisation

- 📁 Håll data i `data/` (lägg till i .gitignore om känslig)
- 📁 Spara mellanresultat i `output/processed/`
- 📁 Använd `here::here()` för filsökvägar

---

## Hjälp och support

**Internt:**
- Kontakta statistikteamet
- Se intern wiki/dokumentation

**Externt:**
- [Quarto dokumentation](https://quarto.org)
- [ggiraph dokumentation](https://davidgohel.github.io/ggiraph/)
- [tidyverse dokumentation](https://www.tidyverse.org)

---

**Lycka till med din rapport! 🎉**

Om du har frågor eller förslag på förbättringar, hör av dig till:  
statistisk.analys@stadshuset.goteborg.se
