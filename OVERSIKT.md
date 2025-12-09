# Quarto-rapportmall - Snabböversikt

**Standardiserad mall för interaktiva rapporter | Version 1.0 | 2025-12-01**

---

## Vad är det här?

En färdig mall för att skapa professionella, interaktiva rapporter i Quarto med:

- ✅ Enhetlig design och grafisk profil
- ✅ Interaktiva diagram med hover-effekter
- ✅ Nedladdningsfunktioner (PNG, Excel, CSV)
- ✅ Färdiga komponenter (highlight-box, tabbar)
- ✅ Fullständig dokumentation

## Kom igång på 5 minuter

```r
# 1. Kopiera template/ till ditt projekt
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

### 🧩 Komponenter
- **Highlight-box**: Framhäv viktig info
- **Panel-tabset**: Organisera i flikar
- **Interaktiva kartor**: Geografisk data

---

## Exempel

### Enkelt linjediagram med tooltip

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

# 3. Skapa plot
p <- plot_data |>
  ggplot(aes(x = år, y = befolkning)) +
  geom_line_interactive(aes(data_id = år, tooltip = tooltip_text))

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
│
├── template/             # ★ KOPIERA DENNA ★
│   ├── rapport_mall.qmd
│   ├── examples/         # Exempel
│   ├── styles/styles.css
│   └── assets/
│
├── R/functions/          # Funktioner
└── docs/                 # Dokumentation
```

---

## Dokumentation

| Fil | För vem | Tid att läsa |
|-----|---------|--------------|
| `SNABBGUIDE.md` | Nybörjare | 5 min |
| `README.md` | Alla | 10 min |
| `CHECKLISTA.md` | Vid nytt projekt | 15 min |
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

## Support

**Internt**: statistisk.analys@stadshuset.goteborg.se

**Dokumentation**: 
- Snabbstart: `SNABBGUIDE.md`
- Fullständig: `README.md`
- Funktioner: `docs/funktioner_katalog.md`

**Exempel**: Se `examples/` för konkreta exempel

---

## Nästa steg

1. **Läs**: `SNABBGUIDE.md` (5 min)
2. **Testa**: `examples/01_enkel_rapport.qmd`
3. **Kopiera**: `template/` till ditt projekt
4. **Skapa**: Din första rapport!

---

**Frågor? Kontakta statistikteamet!**

*Mall skapad av Stadsledningskontoret, Göteborgs Stad | MIT License*
