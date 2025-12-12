# Projektstruktur - Quarto-rapportmall

```
quarto-rapport-mall/
│
├── README.md                    # Huvuddokumentation
├── SNABBGUIDE.md               # Steg-för-steg guide (5 min)
├── CHECKLISTA.md               # För nya projekt
├── KOMPONENTGUIDE.md           # Guide för komponenter
├── OVERSIKT.md                 # Snabböversikt
├── PROJEKTSTRUKTUR.md          # Detta dokument
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

## Filbeskrivningar

### Dokumentation

| Fil | Beskrivning | För vem |
|-----|-------------|---------|
| `README.md` | Översikt av mallprojektet | Alla |
| `SNABBGUIDE.md` | Kom igång på 5 minuter | Nybörjare |
| `CHECKLISTA.md` | Checklista för nya projekt | Alla |
| `KOMPONENTGUIDE.md` | Guide för komponenter | Alla |
| `OVERSIKT.md` | Snabböversikt | Alla som vill ha en snabb överblick |
| `PROJEKTSTRUKTUR.md` | Detta dokument | För förståelse av strukturen |
| `docs/funktioner_katalog.md` | Detaljerad funktionsdokumentation | Utvecklare |

### Mall-filer

| Fil | Beskrivning | Ändra? |
|-----|-------------|--------|
| `template/rapport_mall.qmd` | Huvudmallen med instruktioner och exempel | ✅ Ja |
| `template/_quarto.yml` | Standardinställningar för alla rapporter | Sällan |
| `template/styles/styles.css` | Styling och typsnitt | Sällan |
| `template/assets/README.md` | Info om bilder | Nej |

### Funktioner

| Fil | Beskrivning | Ändra? |
|-----|-------------|--------|
| `template/R/functions/visualisering_interaktiva_funktioner.R` | Tooltip och interaktivitet | Sällan |
| `template/R/functions/visualisering_tema_diagram.R` | Anpassade ggplot2-teman | Sällan |

## Viktig förändring från tidigare versioner

**Funktionerna finns nu i `template/R/functions/`!**

Tidigare låg funktionerna i projektrotens `R/functions/`, men nu ligger de direkt i template/-mappen. Detta gör det enklare att kopiera allt på en gång.

```
Före:
quarto-rapport-mall/
├── template/
│   └── rapport_mall.qmd
└── R/
    └── functions/

Nu:
quarto-rapport-mall/
└── template/
    ├── rapport_mall.qmd
    └── R/
        └── functions/
```

## Hur strukturen används

### För nya användare (första gången)

1. **Läs**: `SNABBGUIDE.md` (5 min)
2. **Kopiera**: Hela `template/` till ditt projekt
3. **Anpassa**: `rapport_mall.qmd` efter dina behov
4. **Utforska**: Öppna mallen och se exempel

### För erfarna användare

1. **Kopiera**: `template/` till nytt projekt
2. **Kör**: Börja skriva direkt
3. **Referens**: `docs/funktioner_katalog.md` vid behov

### För utvecklare

1. **Studera**: Funktionerna i `template/R/functions/`
2. **Utöka**: Lägg till egna funktioner
3. **Dokumentera**: Uppdatera `funktioner_katalog.md`
4. **Testa**: I `rapport_mall.qmd`

## Storlek och omfattning

**Totalt antal filer**: ~12 filer

**Uppskattad storlek**:
- Dokumentation: ~60 KB
- Kod (R + CSS): ~30 KB
- Mall: ~25 KB
- **Total**: ~115 KB (mycket liten!)

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

**Senaste version**: 1.1 (2025-12-12)

**Versionshistorik**:
- v1.1 (2025-12-12): Förenklad struktur
  - Flyttat funktioner till template/R/functions/
  - Lagt till visualisering_tema_diagram.R
  - Tagit bort examples/ (exempel finns i rapport_mall.qmd)
  - Uppdaterat dokumentation
  
- v1.0 (2025-12-01): Första release
  - Grundläggande mall
  - Interaktiva diagram
  - Dokumentation

## Felsökning och support

**Vanliga problem**:
1. "Funktionen hittas inte" → Funktionerna finns i `template/R/functions/`, kontrollera sökväg
2. "Tooltip visas inte" → Använd `*_interactive` geoms
3. "CSS fungerar inte" → Verifiera sökväg i `_quarto.yml`

**Få hjälp**:
- Internt: Kontakta statistikteamet
- E-post: statistisk.analys@stadshuset.goteborg.se
- Dokumentation: Se `docs/funktioner_katalog.md`

## Fördelar med den nya strukturen

### ✅ Enklare att kopiera
Allt ligger i `template/` - en enda mapp att kopiera

### ✅ Självständigt
Template fungerar direkt utan externa beroenden

### ✅ Lättare att underhålla
En struktur att förstå och uppdatera

### ✅ Tydligare exempel
rapport_mall.qmd visar hur allt används

### ✅ Flexiblare
Lätt att lägga till fler funktioner i template/R/functions/

---

*För fullständig information, se README.md*