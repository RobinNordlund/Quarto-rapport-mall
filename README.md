# Quarto-rapportmall för Göteborgs Stad

En standardiserad mall för att skapa interaktiva Quarto-rapporter med enhetlig design och funktionalitet.

## Översikt

Denna mall ger dig:

- ✅ **Enhetlig design** med Göteborgs Stads grafiska profil
- ✅ **Interaktiva diagram** med hover-effekter och nedladdningsfunktioner
- ✅ **Färdiga komponenter** som highlight-box och tabbar
- ✅ **CSS-styling** för typsnitt, färger och layout
- ✅ **Dokumenterade funktioner** för visualisering

## Snabbstart

**5 minuter till din första rapport:**

1. **Kopiera mallen**
   ```bash
   # Kopiera template/-mappen till ditt projekt
   cp -r template/ mitt-projekt/
   ```

2. **Anpassa**
   - Öppna `rapport_mall.qmd`
   - Ändra titel och författare i YAML
   - Byt ut `rapporthuvud.svg` mot din egen bild

3. **Rendera**
   ```r
   quarto::quarto_render("rapport_mall.qmd")
   ```

👉 **Se [SNABBGUIDE.md](SNABBGUIDE.md) för steg-för-steg instruktioner**

## Innehåll

```
projekt/
├── template/                    # DIN ARBETSMAPP
│   ├── _quarto.yml             # Globala inställningar (viktigt!)
│   ├── template.qmd            # Din utgångspunkt
│   ├── exempel/                # Lär dig från färdiga exempel
│   │   ├── 01_enkel_rapport.qmd
│   │   └── 02_avancerad_rapport.qmd
│   └── styles/
│       └── styles.css          # Göteborg Stads styling
│
├── R/
│   └── functions/
│       └── visualisering_interaktiva_funktioner.R  # Funktioner för diagram
│
├── docs/
│   └── anvandning.md           # Fullständig användarguide
│
├── data/                       # Din data (ej i Git om känslig)
│   ├── raw/                    # Originaldata (ÄNDRAS ALDRIG)
│   └── processed/              # Bearbetad data (.rds)
│
└── output/
    └── reports/                # Färdiga rapporter hamnar här
```

## Features

### 🎨 Design och layout

- **Typografi**: Aptos (brödtext) och Cambria (rubriker)
- **Färgschema**: Göteborgs Stads färgpalett (#3F5664)
- **Responsiv layout**: Fungerar på desktop och mobil
- **Innehållsförteckning**: Automatisk och klickbar

### 📊 Interaktiva diagram

- **Hover-effekter**: Visa detaljerad data vid hover
- **Nedladdning**: PNG (diagram) och Excel/CSV (data)
- **Helskärm**: Förstora diagram för presentation
- **Anpassningsbara tooltips**: Formatera efter behov

### 🧩 Återanvändbara komponenter

- **Highlight-box**: Framhäv viktig information
- **Panel-tabset**: Organisera innehåll i flikar
- **Interaktiva kartor**: Geografisk visualisering

## Krav

**R-paket:**
```r
install.packages(c(
  "tidyverse",
  "ggiraph",
  "downloadthis",
  "htmltools",
  "glue",
  "here"
))
```

**Quarto:**
- Version 1.3 eller senare
- Installera från [quarto.org](https://quarto.org)

## Exempel

### Enkelt linjediagram

```r
library(tidyverse)
source("R/functions/visualisering_interaktiva_funktioner.R")

# Skapa tooltip
tooltip_data <- data |>
  skapa_tooltip(
    gruppvars = c("år"),
    grupp_labels = c(år = "År"),
    data_vars = c("befolkning"),
    data_labels = c(befolkning = "Befolkning"),
    data_format = c(befolkning = "nummer")
  )

# Joina tillbaka
plot_data <- data |>
  left_join(tooltip_data, by = "år")

# Skapa plot
p <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(
    aes(tooltip = tooltip_text, data_id = år)
  ) +
  theme_minimal()

# Gör interaktiv
skapa_interaktiv_plot(
  plot_objekt = p,
  export_data = plot_data,
  kolumn_mappning = c("År" = "år", "Befolkning" = "befolkning"),
  output_namn = "befolkning_utveckling"
)
```

Se `examples/` för fler exempel!

## Dokumentation

- **[SNABBGUIDE.md](SNABBGUIDE.md)** - Kom igång på 5 minuter
- **[docs/funktioner_katalog.md](docs/funktioner_katalog.md)** - Fullständig funktionsdokumentation
- **[examples/](examples/)** - Konkreta exempel att utgå från

## Användning

### Kopiera mallen

```bash
# 1. Skapa ditt projekt
mkdir mitt-projekt
cd mitt-projekt

# 2. Kopiera template/
cp -r ../quarto-rapport-mall/template/* .

# 3. Kopiera R-funktioner
mkdir -p R/functions
cp ../quarto-rapport-mall/R/functions/visualisering_interaktiva_funktioner.R R/functions/
```

### Anpassa efter behov

1. **YAML-header**: Ändra titel, författare, datum
2. **Rapporthuvud**: Byt ut `assets/rapporthuvud.svg`
3. **CSS**: Anpassa färger i `styles/styles.css` om önskat
4. **Innehåll**: Ersätt exempeltext med din analys

### Best practices

- ✅ Använd `skapa_tooltip()` för alla interaktiva diagram
- ✅ Testa alltid att diagram fungerar i renderad HTML
- ✅ Använd beskrivande namn för output-filer
- ✅ Dokumentera vad dina diagram visar i caption
- ✅ Följ kodprinciperna i `kodprinciper_r_goteborg.md`

## Vanliga frågor

**Q: Funktionerna hittas inte när jag renderar?**  
A: Se till att `source()` körs i början av din .qmd-fil och att sökvägen är korrekt.

**Q: Tooltips visas inte i renderad HTML?**  
A: Kontrollera att du använder `_interactive` versioner av geoms (t.ex. `geom_line_interactive`) och att `data_id` och `tooltip` är mappade i `aes()`.

**Q: CSS-styling fungerar inte?**  
A: Verifiera att `css: styles/styles.css` finns i YAML och att sökvägen stämmer relativt till din .qmd-fil.

**Q: Hur ändrar jag färger i diagram?**  
A: Använd `scale_color_gbg_*()` och `scale_fill_gbg_*()` funktionerna från MASTERSCRIPT.R eller anpassa manuellt.

## Support och feedback

**Kontakt:**
- E-post: statistisk.analys@stadshuset.goteborg.se
- Intern dokumentation: [Statistik och analys](https://goteborg.se/wps/portal/enhetssida/statistik-och-analys)

**Problem eller förslag?**
- Skapa ett issue på GitHub
- Kontakta utvecklingsteamet
- Föreslå förbättringar via e-post

## Licens

MIT License - se [LICENSE](LICENSE) för detaljer.

---

*Senast uppdaterad: 2025-12-01*

*Utvecklad av Stadsledningskontoret, Göteborgs Stad*
