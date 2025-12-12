# Quarto-rapportmall - Snabböversikt

**Standardiserad mall för interaktiva rapporter | Version 1.1 | 2025-12-12**

---

## Vad är det här?

En färdig mall för att skapa professionella, interaktiva rapporter i Quarto med:

- ✅ Enhetlig design och grafisk profil
- ✅ Interaktiva diagram med hover-effekter
- ✅ Nedladdningsfunktioner (PNG, Excel, CSV)
- ✅ Färdiga komponenter (highlight-box, tabbar)
- ✅ Anpassade ggplot2-teman för olika diagramtyper
- ✅ Fullständig dokumentation

## Kom igång på 5 minuter

```r
# 1. Kopiera template/ till ditt projekt (innehåller nu allt!)
# 2. Öppna rapport_mall.qmd
# 3. Ändra titel och författare
# 4. Rendera med Ctrl+Shift+K
```

**Resultat**: En färdig interaktiv HTML-rapport!

---

## Features

### 🎨 Design
- Göteborgs Stads färgpalett
- Typsnitt: Aptos & Cambria
- Responsiv layout
- Klickbar innehållsförteckning

### 📊 Diagram
- **Hover**: Visa data vid hover
- **Nedladdning**: PNG, Excel, CSV
- **Helskärm**: Förstora diagram
- **Anpassningsbara tooltips**
- **5 färdiga teman**: För olika diagramtyper

### 🧩 Komponenter
- **Highlight-box**: Framhäv viktig info
- **Panel-tabset**: Organisera i flikar
- **Interaktiva kartor**: Geografisk data

---

## Exempel

### Enkelt linjediagram med tema och tooltip

```r
# 1. Skapa tooltip
tooltip_data <- data |>
  skapa_tooltip(
    gruppvars = c("år"),
    data_vars = c("befolkning"),
    data_format = c("befolkning" = "nummer")
  )

# 2. Joina
plot_data <- data |> left_join(tooltip_data, by = "år")

# 3. Skapa plot med tema
p <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(aes(data_id = år, tooltip = tooltip_text)) +
  tema_s_v  # Vertikala stödlinjer för tidsserier

# 4. Gör interaktiv
skapa_interaktiv_plot(
  plot_objekt = p,
  export_data = plot_data,
  kolumn_mappning = c("År" = "år", "Befolkning" = "befolkning"),
  output_namn = "befolkning"
)
```

**Resultat**: Interaktivt diagram med nedladdning!

---

## Struktur

```
quarto-rapport-mall/
├── README.md              # Översikt
├── SNABBGUIDE.md         # Steg-för-steg
├── CHECKLISTA.md         # För nya projekt
├── KOMPONENTGUIDE.md     # Guide för komponenter
│
├── template/             # ★ KOPIERA DENNA ★
│   ├── rapport_mall.qmd  # Mall med exempel
│   ├── _quarto.yml
│   ├── styles/styles.css
│   ├── assets/
│   └── R/functions/      # Funktioner (NYA PLATSEN!)
│       ├── visualisering_interaktiva_funktioner.R
│       └── visualisering_tema_diagram.R
│
└── docs/                 # Dokumentation
    └── funktioner_katalog.md
```

**Nytt i v1.1:** Funktioner ligger nu i `template/R/functions/`!

---

## Dokumentation

| Fil | För vem | Tid att läsa |
|-----|---------|--------------|
| `SNABBGUIDE.md` | Nybörjare | 5 min |
| `README.md` | Alla | 10 min |
| `CHECKLISTA.md` | Vid nytt projekt | 15 min |
| `KOMPONENTGUIDE.md` | För komponenter | 15 min |
| `funktioner_katalog.md` | Utvecklare | 30 min |

---

## Krav

**R-paket**:
```r
install.packages(c("tidyverse", "ggiraph", "downloadthis", 
                   "htmltools", "glue"))
```

**Quarto**: Version 1.3+

**Tid**: 15 min från noll till första rapporten

---

## Teman för diagram

**Välj rätt tema för ditt diagram:**

| Diagramtyp | Tema | När använda |
|------------|------|-------------|
| Kartor | `tema_karta` | Geografiska kartor |
| Enkla diagram | `tema_inga_s` | Värden visas som text |
| Tidsserier | `tema_s_v` | Linjediagram över tid |
| Stapeldiagram | `tema_s_h` | Vertikala/horisontella staplar |
| Scatterplots | `tema_s_h_v` | Punktdiagram |

---

## Support

**Internt**: statistisk.analys@stadshuset.goteborg.se

**Dokumentation**: 
- Snabbstart: `SNABBGUIDE.md`
- Fullständig: `README.md`
- Komponenter: `KOMPONENTGUIDE.md`
- Funktioner: `docs/funktioner_katalog.md`
- Exempel: `template/rapport_mall.qmd`

---

## Nästa steg

1. **Läs**: `SNABBGUIDE.md` (5 min)
2. **Kopiera**: `template/` till ditt projekt
3. **Utforska**: `rapport_mall.qmd` för exempel
4. **Skapa**: Din första rapport!

---

## Vad är nytt i v1.1?

- ✨ **Förenklad struktur**: Funktioner ligger nu i `template/R/functions/`
- 🎨 **Nya teman**: 5 färdiga ggplot2-teman för olika diagramtyper
- 📚 **Bättre exempel**: Allt finns i `rapport_mall.qmd`
- 🗑️ **Rensat**: Tagit bort examples/ - exempel finns i mallen

---

**Frågor? Kontakta statistikteamet!**

*Mall skapad av Stadsledningskontoret, Göteborgs Stad | MIT License*