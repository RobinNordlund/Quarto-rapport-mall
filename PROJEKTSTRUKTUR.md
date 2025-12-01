# Projektstruktur - Quarto-rapportmall

```
quarto-rapport-mall/
│
├── README.md                    # Huvuddokumentation
├── SNABBGUIDE.md               # Steg-för-steg guide (5 min)
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
│   └── assets/
│       └── README.md           # Info om rapporthuvud
│
├── R/
│   └── functions/
│       └── visualisering_interaktiva_funktioner.R
│                                # Funktioner för interaktiva diagram
│
├── examples/                    # Exempel att lära av
│   ├── 01_enkel_rapport.qmd    # Minimal version (~50 rader)
│   ├── 02_fullstandig_rapport.qmd  # Alla features
│   └── data/                   # (Tom mapp för exempeldata)
│
└── docs/
    └── funktioner_katalog.md   # Fullständig funktionsdokumentation
```

## Filbeskrivningar

### Dokumentation

| Fil | Beskrivning | För vem |
|-----|-------------|---------|
| `README.md` | Översikt av mallprojektet | Alla |
| `SNABBGUIDE.md` | Kom igång på 5 minuter | Nybörjare |
| `docs/funktioner_katalog.md` | Detaljerad funktionsdokumentation | Utvecklare |

### Mall-filer

| Fil | Beskrivning | Ändra? |
|-----|-------------|--------|
| `template/rapport_mall.qmd` | Huvudmallen med instruktioner | ✅ Ja |
| `template/_quarto.yml` | Standardinställningar | Sällan |
| `template/styles/styles.css` | Styling och typsnitt | Sällan |
| `template/assets/README.md` | Info om bilder | Nej |

### Funktioner

| Fil | Beskrivning | Ändra? |
|-----|-------------|--------|
| `R/functions/visualisering_interaktiva_funktioner.R` | Tooltip och interaktivitet | Sällan |

### Exempel

| Fil | Beskrivning | Användning |
|-----|-------------|-----------|
| `examples/01_enkel_rapport.qmd` | Minimal exempel | Lär dig grunderna |
| `examples/02_fullstandig_rapport.qmd` | Alla features | Se alla möjligheter |

## Hur strukturen används

### För nya användare (första gången)

1. **Läs**: `SNABBGUIDE.md`
2. **Studera**: `examples/01_enkel_rapport.qmd`
3. **Kopiera**: `template/` till ditt projekt
4. **Anpassa**: `rapport_mall.qmd` efter dina behov

### För erfarna användare

1. **Kopiera**: `template/` till nytt projekt
2. **Kör**: Börja skriva direkt
3. **Referens**: `docs/funktioner_katalog.md` vid behov

### För utvecklare

1. **Studera**: `R/functions/visualisering_interaktiva_funktioner.R`
2. **Utöka**: Lägg till egna funktioner
3. **Dokumentera**: Uppdatera `funktioner_katalog.md`

## Storlek och omfattning

**Totalt antal filer**: ~15 filer

**Uppskattad storlek**:
- Dokumentation: ~50 KB
- Kod (R + CSS): ~25 KB
- Mall och exempel: ~30 KB
- **Total**: ~105 KB (mycket liten!)

**Tid att komma igång**:
- Läsa SNABBGUIDE: 5 min
- Kopiera och anpassa mall: 5 min
- Skapa första diagrammet: 5 min
- **Total**: 15 minuter till första rapporten

## Beroenden

**Obligatoriska R-paket**:
```r
- tidyverse
- ggiraph
- downloadthis
- htmltools
- glue
```

**Valfria R-paket** (för utökad funktionalitet):
```r
- sf (för kartor)
- readxl (för Excel)
- here (för sökvägar)
```

**Quarto**:
- Version 1.3 eller senare

## Uppdateringar och versionhantering

**Senaste version**: 1.0 (2025-12-01)

**Versionshistorik**:
- v1.0 (2025-12-01): Första release
  - Grundläggande mall
  - Interaktiva diagram
  - Dokumentation

**Planerade funktioner** (v1.1):
- Fler exempel-rapporter
- Kartfunktionalitet
- Temaväljare

## Felsökning och support

**Vanliga problem**:
1. "Funktionen hittas inte" → Kontrollera `source()` sökväg
2. "Tooltip visas inte" → Använd `*_interactive` geoms
3. "CSS fungerar inte" → Verifiera sökväg i YAML

**Få hjälp**:
- Internt: Kontakta statistikteamet
- E-post: statistisk.analys@stadshuset.goteborg.se
- Dokumentation: Se `docs/funktioner_katalog.md`

---

*För fullständig information, se README.md*
