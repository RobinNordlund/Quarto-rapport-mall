# =============================================================================
# TEMAN FÖR GGPLOT2-DIAGRAM
# =============================================================================
# Detta script innehåller anpassade ggplot2-teman för Göteborgs Stads rapporter.
# Temana följer stadens visuella identitet och är optimerade för olika
# diagramtyper (kartor, stapeldiagram, linjediagram).
#
# ANVÄNDNING:
# source("R/functions/tema_diagram.R")
# ggplot(data, aes(x, y)) + geom_line() + tema_s_h
#
# TILLGÄNGLIGA TEMAN:
# - tema_karta: För geografiska kartor (inga axlar/rutnät)
# - tema_inga_s: Diagram utan stödlinjer (rena axlar)
# - tema_s_v: Vertikala stödlinjer (för tidsserier)
# - tema_s_h: Horisontella stödlinjer (för stapeldiagram)
# - tema_s_h_v: Både horisontella och vertikala stödlinjer
# =============================================================================


#' Tema för kartor
#'
#' Renodlat tema för geografiska kartor där fokus ska vara på själva kartan.
#' Tar bort alla axlar, rutnät och axeletiketter.
#'
#' @details
#' Designprinciper:
#' - Ingen axeltext eller rutnät (kartan är fokus)
#' - Fetstil rubrik (16pt) för tydlighet
#' - Kursiv underrubrik (12pt) för kontext
#' - Fetstil legendtitel (10pt)
#' - Vänsterjusterad caption för källor
#'
#' @examples
#' library(ggplot2)
#' library(sf)
#' 
#' ggplot(goteborg_stadsdelar) +
#'   geom_sf(aes(fill = befolkning)) +
#'   scale_fill_viridis_c() +
#'   labs(
#'     title = "Befolkning per stadsdel",
#'     subtitle = "Göteborg 2024",
#'     fill = "Antal invånare",
#'     caption = "Källa: SCB"
#'   ) +
#'   tema_karta
#'
#' @seealso 
#' För diagram med axlar, använd istället: [tema_inga_s], [tema_s_v], [tema_s_h]
tema_karta <- theme(
  axis.title.x = element_blank(),
  axis.title.y = element_blank(), 
  axis.text.x = element_blank(), 
  axis.text.y = element_blank(), 
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank(),
  plot.title = element_text(size = 16, face = "bold"),
  plot.subtitle = element_text(size = 12, face = "italic"),
  legend.title = element_text(size = 10, face = "bold"), 
  plot.caption = element_text(hjust = 0)
)


#' Tema utan stödlinjer
#'
#' Rent diagram med bara axlar och tick-märken, inga rutnät. Passar bäst för
#' enkla diagram där stödlinjer skulle skapa visuellt brus, eller när exakta
#' värden visas med etiketter.
#'
#' @details
#' Designprinciper:
#' - Inga stödlinjer (varken horisontella eller vertikala)
#' - Tydliga axellinjer (mörkgrå)
#' - Tick-märken för att markera skalsteg
#' - 10px marginal runt hela diagrammet
#'
#' @examples
#' library(ggplot2)
#' 
#' # Punktdiagram där exakta värden är mindre viktiga
#' ggplot(data, aes(x = ålder, y = inkomst)) +
#'   geom_point() +
#'   labs(
#'     title = "Inkomst per ålder",
#'     x = "Ålder (år)",
#'     y = "Inkomst (tkr)"
#'   ) +
#'   tema_inga_s
#'
#' # Stapeldiagram med värden på staplarna
#' ggplot(data, aes(x = kategori, y = antal)) +
#'   geom_col() +
#'   geom_text(aes(label = antal), vjust = -0.5) +
#'   tema_inga_s
#'
#' @seealso 
#' För diagram där avläsning är viktig: [tema_s_h], [tema_s_v]
tema_inga_s <- theme(
  plot.title = element_text(face = "bold", size = 12),
  plot.subtitle = element_text(face = "italic", size = 10, margin = margin(b = 10)),
  axis.title.y = element_text(face = "bold", size = 10, margin = margin(r = 10)), 
  axis.title.x = element_text(face = "bold", size = 10, margin = margin(t = 10)),
  legend.title = element_text(face = "bold", size = 10), 
  panel.grid.major.x = element_blank(), 
  panel.grid.minor.x = element_blank(),
  panel.grid.minor.y = element_blank(), 
  panel.grid.major.y = element_blank(), 
  plot.margin = margin(t = 10, r = 10, b = 10, l = 10), 
  axis.line.y = element_line(color = "darkgrey"), 
  axis.line.x = element_line(color = "darkgrey"), 
  axis.ticks = element_line(color = "darkgrey", linewidth = 0.5), 
  axis.ticks.length = unit(0.2, "cm"),
  plot.caption = element_text(hjust = 0)
)


#' Tema med vertikala stödlinjer
#'
#' Diagram med vertikala stödlinjer för att underlätta avläsning längs x-axeln.
#' Passar bäst för tidsserier och linjediagram där man vill kunna avläsa
#' värden vid specifika tidpunkter.
#'
#' @details
#' Designprinciper:
#' - Vertikala stödlinjer (major grid) för x-axel
#' - Inga horisontella stödlinjer
#' - Tydliga axlar och tick-märken
#'
#' Vanliga användningsfall:
#' - Tidsserier (år, månader längs x-axeln)
#' - Jämförelse över kategorier där x-axel är viktig
#'
#' @examples
#' library(ggplot2)
#' 
#' # Tidsserie
#' ggplot(data, aes(x = år, y = befolkning)) +
#'   geom_line() +
#'   geom_point() +
#'   labs(
#'     title = "Befolkningsutveckling",
#'     x = "År",
#'     y = "Antal invånare"
#'   ) +
#'   tema_s_v
#'
#' @seealso 
#' [tema_s_h] för horisontella linjer, [tema_s_h_v] för båda riktningar
tema_s_v <- theme(
  plot.title = element_text(face = "bold", size = 12),
  plot.subtitle = element_text(face = "italic", size = 10, margin = margin(b = 10)),
  axis.title.y = element_text(face = "bold", size = 10, margin = margin(r = 10)), 
  axis.title.x = element_text(face = "bold", size = 10, margin = margin(t = 10)),
  legend.title = element_text(face = "bold", size = 10), 
  panel.grid.minor.x = element_blank(),
  panel.grid.minor.y = element_blank(), 
  panel.grid.major.y = element_blank(), 
  plot.margin = margin(t = 10, r = 10, b = 10, l = 10), 
  axis.line.y = element_line(color = "darkgrey"), 
  axis.line.x = element_line(color = "darkgrey"), 
  axis.ticks = element_line(color = "darkgrey", linewidth = 0.5), 
  axis.ticks.length = unit(0.2, "cm"), 
  plot.caption = element_text(hjust = 0)
)


#' Tema med horisontella stödlinjer
#'
#' Diagram med horisontella stödlinjer för att underlätta avläsning längs y-axeln.
#' Passar bäst för stapeldiagram och andra diagram där man vill kunna avläsa
#' exakta värden på y-axeln.
#'
#' @details
#' Designprinciper:
#' - Horisontella stödlinjer (major grid) för y-axel
#' - Inga vertikala stödlinjer
#' - Tydliga axlar och tick-märken
#'
#' Vanliga användningsfall:
#' - Stapeldiagram (vertikala eller horisontella)
#' - Boxplots
#' - Alla diagram där y-värdet är viktigast att avläsa
#'
#' @examples
#' library(ggplot2)
#' 
#' # Stapeldiagram
#' ggplot(data, aes(x = stadsdel, y = befolkning)) +
#'   geom_col() +
#'   labs(
#'     title = "Befolkning per stadsdel",
#'     x = "Stadsdel",
#'     y = "Antal invånare"
#'   ) +
#'   tema_s_h
#'
#' # Horisontellt stapeldiagram (ofta bättre för många kategorier)
#' ggplot(data, aes(x = befolkning, y = reorder(stadsdel, befolkning))) +
#'   geom_col() +
#'   labs(
#'     title = "Befolkning per stadsdel",
#'     x = "Antal invånare",
#'     y = NULL
#'   ) +
#'   tema_s_h
#'
#' @seealso 
#' [tema_s_v] för vertikala linjer, [tema_s_h_v] för båda riktningar
tema_s_h <- theme(
  plot.title = element_text(face = "bold", size = 12),
  plot.subtitle = element_text(face = "italic", size = 10, margin = margin(b = 10)),
  axis.title.y = element_text(face = "bold", size = 10, margin = margin(r = 10)), 
  axis.title.x = element_text(face = "bold", size = 10, margin = margin(t = 10)),
  legend.title = element_text(face = "bold", size = 10), 
  panel.grid.major.x = element_blank(), 
  panel.grid.minor.x = element_blank(),
  panel.grid.minor.y = element_blank(), 
  plot.margin = margin(t = 10, r = 10, b = 10, l = 10), 
  axis.line.y = element_line(color = "darkgrey"), 
  axis.line.x = element_line(color = "darkgrey"), 
  axis.ticks = element_line(color = "darkgrey", linewidth = 0.5), 
  axis.ticks.length = unit(0.2, "cm"), 
  plot.caption = element_text(hjust = 0)
)


#' Tema med horisontella och vertikala stödlinjer
#'
#' Fullständigt rutnät med både horisontella och vertikala stödlinjer.
#' Passar för komplexa diagram där avläsning längs båda axlarna är viktig,
#' eller scatterplots där man vill se mönster i båda dimensionerna.
#'
#' @details
#' Designprinciper:
#' - Både horisontella och vertikala major grid-linjer
#' - Inga minor grid-linjer (för att undvika visuellt brus)
#' - Tydliga axlar och tick-märken
#'
#' Vanliga användningsfall:
#' - Scatterplots där båda axlar är kontinuerliga
#' - Heatmaps
#' - Komplexa tidsserier med flera variabler
#'
#' @examples
#' library(ggplot2)
#' 
#' # Scatterplot
#' ggplot(data, aes(x = inkomst, y = bostadsyta, color = stadsdel)) +
#'   geom_point(size = 3, alpha = 0.6) +
#'   labs(
#'     title = "Bostadsyta vs inkomst",
#'     x = "Medianinkomst (tkr)",
#'     y = "Bostadsyta (kvm)",
#'     color = "Stadsdel"
#'   ) +
#'   tema_s_h_v
#'
#' # Komplex tidsserie med flera linjer
#' ggplot(data, aes(x = år, y = värde, color = kategori)) +
#'   geom_line(linewidth = 1) +
#'   labs(
#'     title = "Utveckling över tid",
#'     x = "År",
#'     y = "Värde",
#'     color = "Kategori"
#'   ) +
#'   tema_s_h_v
#'
#' @seealso 
#' [tema_s_h] för enbart horisontella, [tema_s_v] för enbart vertikala linjer
tema_s_h_v <- theme(
  plot.title = element_text(face = "bold", size = 12),
  plot.subtitle = element_text(face = "italic", size = 10, margin = margin(b = 10)),
  axis.title.y = element_text(face = "bold", size = 10, margin = margin(r = 10)), 
  axis.title.x = element_text(face = "bold", size = 10, margin = margin(t = 10)),
  legend.title = element_text(face = "bold", size = 10), 
  panel.grid.minor.x = element_blank(),
  panel.grid.minor.y = element_blank(), 
  plot.margin = margin(t = 10, r = 10, b = 10, l = 10), 
  axis.line.y = element_line(color = "darkgrey"), 
  axis.line.x = element_line(color = "darkgrey"), 
  axis.ticks = element_line(color = "darkgrey", linewidth = 0.5), 
  axis.ticks.length = unit(0.2, "cm"), 
  plot.caption = element_text(hjust = 0)
)


# =============================================================================
# SNABBGUIDE: VILKET TEMA SKA JAG VÄLJA?
# =============================================================================
#
# KARTOR → tema_karta
#   Geografiska kartor där fokus är på kartan själv
#
# ENKLA DIAGRAM (värden visas som text) → tema_inga_s
#   T.ex. staplar med siffror ovanpå
#
# TIDSSERIER → tema_s_v
#   Linjediagram över tid där man vill kunna peka ut specifika år
#
# STAPELDIAGRAM → tema_s_h
#   Vertikala eller horisontella staplar där höjd/längd är viktig
#
# SCATTERPLOTS / KOMPLEXA DIAGRAM → tema_s_h_v
#   När avläsning längs båda axlar är viktig
#
# =============================================================================