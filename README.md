# Quarto-rapportmall för Göteborgs Stad

En standardiserad mall för att skapa interaktiva Quarto-rapporter med enhetlig design och funktionalitet.

## Översikt

Denna mall ger dig:

- ✅ **Enhetlig design** med Göteborgs Stads grafiska profil
- ✅ **Interaktiva diagram** med hover-effekter och nedladdningsfunktioner
- ✅ **Färdiga komponenter** som highlight-box och tabbar
- ✅ **CSS-styling** för typsnitt, färger och layout
- ✅ **Dokumenterade funktioner** för visualisering
- ✅ **Anpassade ggplot2-teman** för enhetliga diagram

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
quarto-rapport-mall/
├── README.md                    # Huvuddokumentation
├── SNABBGUIDE.md               # Steg-för-steg guide (5 min)
├── CHECKLISTA.md               # För nya projekt
├── KOMPONENTGUIDE.md           # Guide för komponenter
├── OVERSIKT.md                 # Snabböversikt
├── LICENSE                      # MIT License
├── .gitignore                   # Git-ignorering
│
├── template/                    # ★ KOPIERA DENNA MAPP ★
│   ├── rapport_mall.qmd        # Huvudmallen med instruktioner
│   ├── _quarto.yml             # Quarto-konfiguration
│   │
│   ├── styles/
│   │   └── styles.css          # CSS-styling (typsnitt, färger)
│   │
│   ├── assets/
│   │   └── README.md           # Info om rapporthuvud
│   │
│   └── R/
│       └── functions/
│           ├── visualisering_interaktiva_funktioner.R
│           └── visualisering_tema_diagram.R
│
└── docs/
    └── funktioner_katalog.md   # Fullständig funktionsdokumentation
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
- **Anpassade teman**: 5 färdiga ggplot2-teman för olika diagramtyper

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

### Enkelt linjediagram med tema

```r
library(tidyverse)
source("R/functions/visualisering_interaktiva_funktioner.R")
source("R/functions/visualisering_tema_diagram.R")

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

# Skapa plot med anpassat tema
p <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(
    aes(tooltip = tooltip_text, data_id = år)
  ) +
  labs(
    title = "Befolkningsutveckling",
    x = "År",
    y = "Antal invånare"
  ) +
  tema_s_v  # Tema med vertikala stödlinjer för tidsserier

# Gör interaktiv
skapa_interaktiv_plot(
  plot_objekt = p,
  export_data = plot_data,
  kolumn_mappning = c("År" = "år", "Befolkning" = "befolkning"),
  output_namn = "befolkning_utveckling"
)
```

Se `template/rapport_mall.qmd` för fler exempel!

## Dokumentation

- **[SNABBGUIDE.md](SNABBGUIDE.md)** - Kom igång på 5 minuter
- **[CHECKLISTA.md](CHECKLISTA.md)** - Checklista för nya projekt
- **[KOMPONENTGUIDE.md](KOMPONENTGUIDE.md)** - Guide för alla komponenter
- **[docs/funktioner_katalog.md](docs/funktioner_katalog.md)** - Fullständig funktionsdokumentation
- **[template/rapport_mall.qmd](template/rapport_mall.qmd)** - Arbetande mall med exempel

## Användning

### Kopiera mallen

**Alternativ 1: Kopiera bara template/**
```bash
# 1. Skapa ditt projekt
mkdir mitt-projekt
cd mitt-projekt

# 2. Kopiera hela template/ (inklusive R/functions/)
cp -r ../quarto-rapport-mall/template/* .
```

**Alternativ 2: Klona hela repositoryt**
```bash
# 1. Klona från GitHub
git clone https://github.com/ditt-användarnamn/quarto-rapport-mall.git

# 2. Kopiera template till nytt projekt
cp -r quarto-rapport-mall/template/* mitt-projekt/
```

### Anpassa efter behov

1. **YAML-header**: Ändra titel, författare, datum
2. **Rapporthuvud**: Byt ut `assets/rapporthuvud.svg`
3. **CSS**: Anpassa färger i `styles/styles.css` om önskat
4. **Innehåll**: Ersätt exempeltext med din analys

### Best practices

- ✅ Använd `skapa_tooltip()` för alla interaktiva diagram
- ✅ Välj lämpligt tema från `visualisering_tema_diagram.R`
- ✅ Testa alltid att diagram fungerar i renderad HTML
- ✅ Använd beskrivande namn för output-filer
- ✅ Dokumentera vad dina diagram visar i caption
- ✅ Följ kodprinciperna i `kodprinciper_r_goteborg.md`

## Vanliga frågor

**Q: Funktionerna hittas inte när jag renderar?**  
A: Funktionerna finns nu i `template/R/functions/`. Se till att sökvägen i `source()` stämmer: `source("R/functions/visualisering_interaktiva_funktioner.R")`

**Q: Tooltips visas inte i renderad HTML?**  
A: Kontrollera att du använder `_interactive` versioner av geoms (t.ex. `geom_line_interactive`) och att `data_id` och `tooltip` är mappade i `aes()`.

**Q: CSS-styling fungerar inte?**  
A: Verifiera att `css: styles/styles.css` finns i YAML och att sökvägen stämmer relativt till din .qmd-fil.

**Q: Vilket tema ska jag använda för mitt diagram?**  
A: Se `visualisering_tema_diagram.R` för vägledning:
- Kartor → `tema_karta`
- Tidsserier → `tema_s_v`
- Stapeldiagram → `tema_s_h`
- Scatterplots → `tema_s_h_v`

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

*Senast uppdaterad: 2025-12-12*

*Utvecklad av Stadsledningskontoret, Göteborgs Stad*