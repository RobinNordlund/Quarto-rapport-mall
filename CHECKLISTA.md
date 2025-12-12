# Checklista - Nytt projekt med Quarto-rapportmall

Använd denna checklista när du startar ett nytt rapportprojekt.

---

## ☐ Steg 1: Förberedelser (5 min)

### Skapa RStudio-projekt
- [ ] File > New Project > New Directory > New Project
- [ ] Namnge projektet (använd understreck: `befolkning_analys_2025`)
- [ ] Välj lämplig plats på din dator

### Kontrollera paket
```r
# Kör i R Console för att kontrollera installerade paket
required_packages <- c("tidyverse", "ggiraph", "downloadthis", "htmltools", "glue")
missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]

if(length(missing_packages) > 0) {
  install.packages(missing_packages)
} else {
  message("Alla paket är installerade!")
}
```

- [ ] Alla nödvändiga paket installerade
- [ ] Quarto installerat (kör `quarto check` i Terminal)

---

## ☐ Steg 2: Kopiera mall (5 min)

### Kopiera hela template/
- [ ] Kopiera hela `template/` till ditt projekt (innehåller nu allt!)
- [ ] Verifiera att filstrukturen ser korrekt ut

### Kontrollera struktur
```
ditt-projekt/
├── rapport_mall.qmd
├── _quarto.yml
├── styles/
│   └── styles.css
├── assets/
│   └── README.md
└── R/
    └── functions/
        ├── visualisering_interaktiva_funktioner.R
        └── visualisering_tema_diagram.R
```

**OBS:** Funktionerna finns nu i template/R/functions/!

---

## ☐ Steg 3: Anpassa mall (10 min)

### YAML-header
- [ ] Ändra `title` till din rapporttitel
- [ ] Lägg till ditt namn (valfritt)
- [ ] Kontrollera att inställningar i `_quarto.yml` är korrekta

### Rapporthuvud
- [ ] Behåll befintlig bild ELLER
- [ ] Ersätt `assets/rapporthuvud.svg` med din egen bild
- [ ] Uppdatera bildlänk i rapport_mall.qmd om du bytte namn

### Ladda funktioner
- [ ] Kontrollera att sökvägen i `source()` är korrekt
- [ ] Testa att funktioner laddas:
  ```r
  source("R/functions/visualisering_interaktiva_funktioner.R")
  source("R/functions/visualisering_tema_diagram.R")
  ```

---

## ☐ Steg 4: Ladda din data (5 min)

### Förbered data
- [ ] Placera rådata i `data/raw/` (skapa mapp om den inte finns)
- [ ] Läs in data i första R-chunken

```r
# Exempel
library(tidyverse)

# Från CSV
data <- read_csv("data/raw/min_data.csv")

# Från Excel
# library(readxl)
# data <- read_excel("data/raw/min_data.xlsx")

# Från RDS
# data <- readRDS("data/processed/bearbetad_data.rds")
```

- [ ] Data läses in utan fel
- [ ] Verifiera data med `glimpse(data)` eller `head(data)`

---

## ☐ Steg 5: Skapa första diagrammet (10 min)

### Tooltip och plot
- [ ] Välj variabler för tooltip
- [ ] Skapa tooltip med `skapa_tooltip()`
- [ ] Joina tooltip till data
- [ ] Skapa ggplot med `*_interactive` geoms
- [ ] Lägg till `aes(data_id = ..., tooltip = tooltip_text)`
- [ ] Välj lämpligt tema (tema_s_v, tema_s_h, etc.)

### Gör interaktiv
- [ ] Använd `skapa_interaktiv_plot()`
- [ ] Ange `kolumn_mappning` för export
- [ ] Välj beskrivande `output_namn`

### Testa
- [ ] Rendera rapporten (Ctrl/Cmd + Shift + K)
- [ ] Kontrollera att tooltip visas vid hover
- [ ] Testa nedladdningsknappar
- [ ] Testa helskärmslä

---

## ☐ Steg 6: Bygg vidare (löpande)

### Innehåll
- [ ] Ta bort eller anpassa exempeltext från mall
- [ ] Skriv din egen introduktion
- [ ] Lägg till fler sektioner efter behov
- [ ] Använd highlight-box för viktig information
- [ ] Använd panel-tabset för flikar

### Diagram
- [ ] Skapa fler diagram efter samma mönster
- [ ] Testa olika geom-typer (line, point, col, area)
- [ ] Experimentera med hover-effekter
- [ ] Prova olika teman för olika diagramtyper

### Formatering
- [ ] Lägg till beskrivande captions
- [ ] Formatera axlar och etiketter
- [ ] Välj lämpliga färger

---

## ☐ Steg 7: Kvalitetskontroll (15 min)

### Kodkvalitet
- [ ] Alla chunks har beskrivande labels
- [ ] Kommentarer finns där koden är komplex
- [ ] Inga onödiga varningar eller meddelanden
- [ ] Kod följer tidyverse-stil

### Innehåll
- [ ] Stavkontroll genomförd
- [ ] Alla siffror och fakta kontrollerade
- [ ] Källor angivna i captions
- [ ] Tabeller och diagram har beskrivande titlar

### Funktionalitet
- [ ] Alla tooltips fungerar
- [ ] Nedladdning fungerar för alla diagram
- [ ] Helskärm fungerar
- [ ] Innehållsförteckning är korrekt
- [ ] Länkar fungerar (om några finns)

### Testrendering
- [ ] Rendera från rent R-session (Session > Restart R)
- [ ] Kontrollera i olika webbläsare (Chrome, Firefox)
- [ ] Testa på annan dator (om möjligt)

---

## ☐ Steg 8: Dokumentation (5 min)

### README (om projektet ska delas)
- [ ] Skapa README.md i projektmappen
- [ ] Beskriv vad rapporten handlar om
- [ ] Lista datakällor
- [ ] Förklara hur man kör rapporten

### Kod-dokumentation
- [ ] Kommentera viktiga funktioner
- [ ] Förklara komplexa transformationer
- [ ] Dokumentera antaganden

---

## ☐ Steg 9: Dela och publicera

### För intern delning
- [ ] Rendera till HTML
- [ ] Dela HTML-fil via e-post/nätverk
- [ ] ELLER pusha till GitHub (se nedan)

### För GitHub
- [ ] Initiera Git: `git init`
- [ ] Lägg till .gitignore
- [ ] Committa filer: `git add .` och `git commit -m "feat: Initial commit"`
- [ ] Skapa repo på GitHub
- [ ] Pusha: `git push -u origin main`

### För webb-publicering
- [ ] Använd Quarto Pub: `quarto publish quarto-pub`
- [ ] ELLER GitHub Pages
- [ ] ELLER intern server

---

## ☐ Steg 10: Underhåll

### Regelbundet
- [ ] Uppdatera data när ny data tillgänglig
- [ ] Rendera om rapport
- [ ] Kontrollera att allt fungerar

### Vid problem
- [ ] Kontrollera SNABBGUIDE.md för vanliga fel
- [ ] Se funktioner_katalog.md för funktionsdetaljer
- [ ] Se rapport_mall.qmd för exempel
- [ ] Kontakta statistikteamet vid behov

---

## Tips för effektivt arbete

**Arbetsflöde:**
1. ✅ Testa ofta - rendera efter varje nytt diagram
2. ✅ Committa ofta om du använder Git
3. ✅ Spara mellanresultat som .rds-filer
4. ✅ Håll kod organiserad i numrerade chunks

**Kodning:**
- 💡 Använd rapport_mall.qmd som referens
- 💡 Använd `View()` för att inspektera data
- 💡 Skriv kommentarer medan du kodar
- 💡 Dela upp komplicerad kod i flera steg

**Felsökning:**
- 🔧 Rendera ofta för att fånga fel tidigt
- 🔧 Läs felmeddelanden noggrant
- 🔧 Googla specifika felmeddelanden
- 🔧 Testa kod rad för rad i Console

---

## Hjälp och resurser

**Internt:**
- E-post: statistisk.analys@stadshuset.goteborg.se
- Kollegor som använt mallen tidigare

**Dokumentation:**
- README.md - översikt
- SNABBGUIDE.md - kom igång
- KOMPONENTGUIDE.md - guide för komponenter
- funktioner_katalog.md - funktionsdetaljer
- rapport_mall.qmd - arbetande exempel

**Externt:**
- [Quarto dokumentation](https://quarto.org)
- [ggiraph dokumentation](https://davidgohel.github.io/ggiraph/)
- [tidyverse dokumentation](https://www.tidyverse.org)

---

**Lycka till med ditt projekt! 🎉**

*Spara denna checklista och använd den varje gång du startar ett nytt rapportprojekt.*