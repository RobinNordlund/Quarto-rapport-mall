# =============================================================================
# VISUALISERINGSFUNKTIONER FÃ–R INTERAKTIVA DIAGRAM
# =============================================================================
# Dessa funktioner skapar interaktiva ggplot2-diagram med hover-effekter,
# nedladdningsknappar och helskÃ¤rmslÃ¤ge fÃ¶r Quarto-rapporter.
# =============================================================================


#' Skapa tooltip-text fÃ¶r interaktiva diagram
#'
#' Genererar HTML-formaterade tooltips som visas nÃ¤r man hovrar Ã¶ver datapunkter
#' i ett giraffe-diagram. Tooltips kan innehÃ¥lla bÃ¥de grupperingsvariabler
#' (t.ex. region, Ã¥r) och datavariabler (t.ex. antal, andel) med anpassad
#' formatering fÃ¶r svenska talformat.
#'
#' @param data Data frame med data fÃ¶r diagrammet
#' @param gruppvars Character-vektor med namn pÃ¥ grupperingsvariabler som ska 
#'   visas som rubrik i tooltip (t.ex. c("region", "Ã¥r"))
#' @param data_vars Character-vektor med namn pÃ¥ datavariabler som ska visas 
#'   i tooltip-innehÃ¥llet (t.ex. c("antal", "andel"))
#' @param grupp_labels Named character-vektor med etiketter fÃ¶r gruppvariabler.
#'   Om NULL anvÃ¤nds variabelnamnen. Format: c("region" = "Region", "Ã¥r" = "Ã…r")
#' @param data_labels Named character-vektor med etiketter fÃ¶r datavariabler.
#'   Om NULL anvÃ¤nds variabelnamnen. Format: c("antal" = "Antal", "andel" = "Andel (%)")
#' @param data_format Named character-vektor som anger format fÃ¶r varje datavariabel.
#'   MÃ¶jliga vÃ¤rden: "nummer" (heltal med mellanslag), "decimal" (decimaltal), 
#'   "procent" (decimaltal med %-tecken), eller "text" (oformaterat).
#'   Om NULL anvÃ¤nds "text" fÃ¶r alla. Format: c("antal" = "nummer", "andel" = "procent")
#' @param decimaler Antal decimaler fÃ¶r "decimal" och "procent"-format (default 1)
#'
#' @return Data frame med en kolumn 'tooltip_text' som innehÃ¥ller HTML-formaterad text
#'
#' @examples
#' # Enkel tooltip med antal
#' data |>
#'   mutate(tooltip = skapa_tooltip(
#'     data = cur_data(),
#'     gruppvars = c("region"),
#'     data_vars = c("antal"),
#'     grupp_labels = c("region" = "Region"),
#'     data_labels = c("antal" = "Antal"),
#'     data_format = c("antal" = "nummer")
#'   )$tooltip_text)
#'
#' # Tooltip med flera variabler och anpassad formatering
#' data |>
#'   mutate(tooltip = skapa_tooltip(
#'     data = cur_data(),
#'     gruppvars = c("region", "Ã¥r"),
#'     data_vars = c("antal", "andel"),
#'     grupp_labels = c("region" = "Region", "Ã¥r" = "Ã…r"),
#'     data_labels = c("antal" = "Antal personer", "andel" = "Andel"),
#'     data_format = c("antal" = "nummer", "andel" = "procent"),
#'     decimaler = 1
#'   )$tooltip_text)
#'
#' @details
#' Formatering:
#' - "nummer": Avrundade heltal med mellanslag som tusenavskiljare (t.ex. "1 234")
#' - "decimal": Decimaltal med mellanslag som tusenavskiljare och komma som 
#'   decimaltecken (t.ex. "1 234,5")
#' - "procent": Som "decimal" men med %-tecken (t.ex. "23,4 %")
#' - "text": Ingen formatering, visar vÃ¤rdet som det Ã¤r
#'
#' Tooltip-design:
#' - Vit bakgrund med rundade hÃ¶rn och skugga
#' - Grupperingsvariabler visas som fetstil rubrik (14px, mÃ¶rkgrÃ¥)
#' - Datavariabler visas som brÃ¶dtext (12px, mellangrÃ¥)
#' - Flera rader separeras med <br/>
skapa_tooltip <- function(data, gruppvars, data_vars, 
                          grupp_labels = NULL, data_labels = NULL,
                          data_format = NULL, decimaler = 1) {
  
  # SÃ¤tt default labels till variabelnamn om inte angivet
  if (is.null(grupp_labels)) {
    grupp_labels <- setNames(gruppvars, gruppvars)
  }
  if (is.null(data_labels)) {
    data_labels <- setNames(data_vars, data_vars)
  }
  if (is.null(data_format)) {
    data_format <- setNames(rep("text", length(data_vars)), data_vars)
  }
  
  data |> 
    group_by(across(all_of(gruppvars))) |> 
    summarise(
      tooltip_text = paste0(
        "<div style='padding: 10px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.15);'>",
        # Rubrikdel - anvÃ¤nd gruppvariablerna
        paste(
          sapply(gruppvars, function(var) {
            paste0("<strong style='font-size: 14px; color: #333;'>",
                   grupp_labels[var], ": ", first(get(var)), "</strong>")
          }),
          collapse = "<br/>"
        ),
        "<br/>",
        "<span style='color: #666; font-size: 12px;'>",
        # Datadel
        if (n() > 1) {
          # Flera rader
          paste(
            sapply(1:n(), function(i) {
              paste(
                sapply(data_vars, function(var) {
                  val <- get(var)[i]
                  label <- ifelse(is.null(data_labels[var]) || is.na(data_labels[var]) || data_labels[var] == "", 
                                  "", 
                                  paste0(data_labels[var], ": "))
                  
                  formatted_val <- switch(
                    data_format[var],
                    "nummer" = format(round(val), big.mark = " "),
                    "decimal" = format(round(val, decimaler), big.mark = " ", decimal.mark = ","),
                    "procent" = paste0(format(round(val, decimaler), big.mark = " ", decimal.mark = ","), " %"),
                    as.character(val)
                  )
                  paste0(label, formatted_val)
                }),
                collapse = ": "
              )
            }),
            collapse = "<br/>"
          )
        } else {
          # En rad
          paste(
            sapply(data_vars, function(var) {
              val <- first(get(var))
              
              formatted_val <- switch(
                data_format[var],
                "nummer" = format(round(val), big.mark = " "),
                "decimal" = format(round(val, decimaler), big.mark = " ", decimal.mark = ","),
                "procent" = paste0(format(round(val, decimaler), big.mark = " ", decimal.mark = ","), " %"),
                as.character(val)
              )
              paste0(data_labels[var], ": ", formatted_val)
            }),
            collapse = "<br/>"
          )
        },
        "</span></div>"
      ),
      .groups = "drop"
    )
}


#' Skapa interaktivt diagram med nedladdningsfunktion
#'
#' Omvandlar ett ggplot2-diagram till ett interaktivt giraffe-diagram med
#' hover-effekter, nedladdningsknappar (PNG, Excel, CSV) och helskÃ¤rmslÃ¤ge.
#' AnvÃ¤nds frÃ¤mst i Quarto-rapporter fÃ¶r att ge anvÃ¤ndaren mÃ¶jlighet att bÃ¥de
#' interagera med och ladda ner diagram och underliggande data.
#'
#' @param plot_objekt Ett ggplot2-objekt som ska gÃ¶ras interaktivt. Viktigt:
#'   Diagrammet mÃ¥ste innehÃ¥lla giraffe-aesthetics som data_id och tooltip fÃ¶r
#'   att hover-effekter ska fungera (se exempel)
#' @param export_data Data frame med data som ska kunna laddas ner (vanligtvis
#'   samma data som anvÃ¤nds i diagrammet)
#' @param kolumn_mappning Named list/vector som mappar om kolumnnamn fÃ¶r export.
#'   Format: c("gammalt_namn" = "Nytt Namn"). AnvÃ¤nds fÃ¶r att gÃ¶ra exporterad
#'   data mer lÃ¤svÃ¤nlig
#' @param output_namn Filnamn fÃ¶r nedladdade filer (utan filÃ¤ndelse). 
#'   Default: "diagram"
#' @param width Bredd pÃ¥ diagrammet i tum (default 8)
#' @param height HÃ¶jd pÃ¥ diagrammet i tum (default 5)
#' @param dpi UpplÃ¶sning fÃ¶r PNG-export (default 300)
#' @param hover_r Radie i pixlar fÃ¶r hover-effekt pÃ¥ punkter. NULL = ingen effekt.
#'   AnvÃ¤ndbart fÃ¶r scatterplots (t.ex. hover_r = 5)
#' @param hover_inv_opacity Opacitet (0-1) fÃ¶r icke-hovererade element. NULL = 
#'   ingen effekt. AnvÃ¤ndbart fÃ¶r att framhÃ¤va hoverad datapunkt (t.ex. 0.3)
#' @param dropdown_id Unikt ID fÃ¶r dropdown-menyn. NULL = genereras automatiskt.
#'   AnvÃ¤nds om du vill ha flera diagram pÃ¥ samma sida
#'
#' @return Ett htmltools-objekt som kan renderas direkt i Quarto
#'
#' @examples
#' # GrundlÃ¤ggande linjediagram
#' p <- data |>
#'   mutate(
#'     tooltip = skapa_tooltip(
#'       cur_data(),
#'       gruppvars = c("Ã¥r"),
#'       data_vars = c("antal"),
#'       data_format = c("antal" = "nummer")
#'     )$tooltip_text
#'   ) |>
#'   ggplot(aes(x = Ã¥r, y = antal, group = region, color = region)) +
#'   geom_line_interactive(aes(data_id = region, tooltip = tooltip)) +
#'   theme_minimal()
#'
#' skapa_interaktiv_plot(
#'   plot_objekt = p,
#'   export_data = data,
#'   kolumn_mappning = c("Ã¥r" = "Ã…r", "antal" = "Antal", "region" = "Region"),
#'   output_namn = "befolkning_utveckling"
#' )
#'
#' # Punktdiagram med hover-effekt
#' p <- data |>
#'   mutate(
#'     tooltip = skapa_tooltip(
#'       cur_data(),
#'       gruppvars = c("stad"),
#'       data_vars = c("befolkning", "yta"),
#'       data_format = c("befolkning" = "nummer", "yta" = "decimal")
#'     )$tooltip_text
#'   ) |>
#'   ggplot(aes(x = yta, y = befolkning)) +
#'   geom_point_interactive(aes(data_id = stad, tooltip = tooltip), size = 3) +
#'   theme_minimal()
#'
#' skapa_interaktiv_plot(
#'   plot_objekt = p,
#'   export_data = data,
#'   kolumn_mappning = c("stad" = "Stad", "befolkning" = "Befolkning"),
#'   output_namn = "stad_jamforelse",
#'   hover_r = 5,              # FÃ¶rstora punkter vid hover
#'   hover_inv_opacity = 0.3   # Tona ner andra punkter
#' )
#'
#' @details
#' Funktionen skapar:
#' 1. En interaktiv version av diagrammet med giraffe
#' 2. En dropdown-meny med tre nedladdningsalternativ:
#'    - PNG: HÃ¶gupplÃ¶st bild av diagrammet
#'    - Excel: Data i .xlsx-format
#'    - CSV: Data i .csv-format
#' 3. En helskÃ¤rmsknapp fÃ¶r att visa diagrammet i fullskÃ¤rm
#'
#' Tekniska detaljer:
#' - Skapar en temporÃ¤r mapp "temp_plots/" fÃ¶r PNG-filer
#' - AnvÃ¤nder JavaScript fÃ¶r dropdown och helskÃ¤rmsfunktionalitet
#' - Genererar unika ID:n fÃ¶r att undvika konflikter mellan diagram
#' - Tooltips visas med transparent bakgrund och fÃ¶ljer muspekaren
#' - Hover-effekter styrs via CSS (fill-opacity, stroke-width, r, opacity)
#'
#' Krav:
#' - Paketen ggiraph, downloadthis, htmltools, glue mÃ¥ste vara installerade
#' - FÃ¶r interaktivitet: AnvÃ¤nd *_interactive() funktioner frÃ¥n ggiraph
#'   (geom_line_interactive, geom_point_interactive, etc.)
#' - FÃ¶r hover: LÃ¤gg till aes(data_id = ..., tooltip = ...)
skapa_interaktiv_plot <- function(
    plot_objekt,
    export_data,
    kolumn_mappning,
    output_namn = "diagram",
    width = 8,
    height = 5,
    dpi = 300,
    hover_r = NULL,
    hover_inv_opacity = NULL,
    dropdown_id = NULL
) {
  
  # Skapa temp-mapp om den inte finns
  temp_dir <- "temp_plots"
  if (!dir.exists(temp_dir)) {
    dir.create(temp_dir)
  }
  
  # Generera unikt ID fÃ¶r att undvika konflikter om flera diagram pÃ¥ samma sida
  if (is.null(dropdown_id)) {
    dropdown_id <- paste0("dropdown_", sample(10000:99999, 1))
  }
  
  menu_id <- paste0(dropdown_id, "_menu")
  content_id <- paste0(dropdown_id, "_content")
  fullscreen_id <- paste0(dropdown_id, "_fullscreen")
  container_id <- paste0(dropdown_id, "_container")
  girafe_id <- paste0(dropdown_id, "_girafe")
  
  # FÃ¶rbered export_data med kolumnmappning
  export_data_formatted <- export_data |> 
    select(!!!kolumn_mappning)
  
  # Spara diagram som PNG i temp-mappen
  temp_png <- file.path(temp_dir, paste0("temp_", dropdown_id, ".png"))
  ggsave(
    filename = temp_png,
    plot = plot_objekt,
    width = width,
    height = height,
    dpi = dpi,
    bg = "white"
  )
  
  # Bygg hover CSS
  hover_css <- "fill-opacity: 1; stroke-width: 2;"
  if (!is.null(hover_r)) {
    hover_css <- paste0(hover_css, " r: ", hover_r, "px;")
  }
  
  # Bygg girafe options
  girafe_options <- list(
    opts_hover(css = hover_css),
    opts_tooltip(
      css = "background-color: transparent; padding: 0px; border: none;",
      opacity = 1,
      use_fill = FALSE,
      use_stroke = FALSE
    ),
    opts_toolbar(saveaspng = FALSE),
    opts_sizing(rescale = TRUE)
  )
  
  # LÃ¤gg till hover_inv om det angivits
  if (!is.null(hover_inv_opacity)) {
    girafe_options <- c(
      girafe_options,
      list(opts_hover_inv(css = paste0("opacity: ", hover_inv_opacity, ";")))
    )
  }
  
  # Skapa container fÃ¶r diagram och knappar
  htmltools::tags$div(
    id = container_id,
    style = "position: relative;",
    
    # Knappcontainer
    htmltools::tags$div(
      style = "position: absolute; top: 10px; right: 10px; z-index: 1000; display: flex; gap: 8px;",
      
      # Dropdown-meny fÃ¶r nedladdning
      htmltools::tags$div(
        style = "position: relative;",
        
        # Menyknapp (bara ikon)
        htmltools::tags$button(
          class = "btn btn-default btn-sm dropdown-toggle custom-download-menu",
          type = "button",
          id = menu_id,
          style = "display: flex; align-items: center; gap: 5px; padding: 6px 10px;",
          htmltools::tags$span(class = "fa fa-bars"),
          htmltools::tags$span(class = "caret", style = "margin-left: 3px;")
        ),
        
        # Dropdown-innehÃ¥ll
        htmltools::tags$div(
          class = "dropdown-menu custom-dropdown-content",
          id = content_id,
          style = "display: none; position: absolute; right: 0; background: white; border: 1px solid #ccc; border-radius: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.15); z-index: 1001; min-width: 180px; padding: 5px 0; margin-top: 5px;",
          
          # PNG
          download_file(
            path = temp_png,
            output_name = output_namn,
            button_label = "PNG (diagram)",
            button_type = "default",
            has_icon = TRUE,
            icon = "fa fa-image",
            self_contained = TRUE
          ),
          
          # Excel
          export_data_formatted |> 
            download_this(
              output_name = output_namn,
              output_extension = ".xlsx",
              button_label = "Excel (data)",
              button_type = "default",
              has_icon = TRUE,
              icon = "fa fa-file-excel-o",
              self_contained = TRUE
            ),
          
          # CSV
          export_data_formatted |> 
            download_this(
              output_name = output_namn,
              output_extension = ".csv",
              button_label = "CSV (data)",
              button_type = "default",
              has_icon = TRUE,
              icon = "fa fa-file-text-o",
              self_contained = TRUE
            )
        )
      ),
      
      # HelskÃ¤rmsknapp
      htmltools::tags$button(
        class = "btn btn-default btn-sm",
        type = "button",
        id = fullscreen_id,
        style = "display: flex; align-items: center; padding: 4px 8px; font-size: 11px; background-color: #3399cc !important; color: white !important; border-color: #3399cc !important;",
        title = "FÃ¶rstora",
        onmouseover = "this.style.backgroundColor='#0076bc'; this.style.borderColor='#0076bc';",
        onmouseout = "this.style.backgroundColor='#3399cc'; this.style.borderColor='#3399cc';",
        htmltools::tags$span(class = "fa fa-expand", style = "font-size: 10px;")
      )
    ),
    
    # JavaScript fÃ¶r dropdown och helskÃ¤rm
    htmltools::tags$script(htmltools::HTML(glue::glue("
      (function() {{
        function initDiagram_{dropdown_id}() {{
          var container = document.getElementById('{container_id}');
          var menuBtn = document.getElementById('{menu_id}');
          var menuContent = document.getElementById('{content_id}');
          var fullscreenBtn = document.getElementById('{fullscreen_id}');
          
          if (!container || !menuBtn || !menuContent || !fullscreenBtn) {{
            setTimeout(initDiagram_{dropdown_id}, 100);
            return;
          }}
          
          // Dropdown-funktionalitet
          menuBtn.addEventListener('click', function(e) {{
            e.stopPropagation();
            if (menuContent.style.display === 'none' || menuContent.style.display === '') {{
              menuContent.style.display = 'block';
            }} else {{
              menuContent.style.display = 'none';
            }}
          }});
          
          document.addEventListener('click', function(event) {{
            if (!menuBtn.contains(event.target) && !menuContent.contains(event.target)) {{
              menuContent.style.display = 'none';
            }}
          }});
          
          // HelskÃ¤rm-funktionalitet
          fullscreenBtn.addEventListener('click', function() {{
            if (!document.fullscreenElement) {{
              if (container.requestFullscreen) {{
                container.requestFullscreen();
              }} else if (container.webkitRequestFullscreen) {{
                container.webkitRequestFullscreen();
              }} else if (container.msRequestFullscreen) {{
                container.msRequestFullscreen();
              }}
            }} else {{
              if (document.exitFullscreen) {{
                document.exitFullscreen();
              }}
            }}
          }});
          
          // Hantera helskÃ¤rmslÃ¤ge
          function handleFullscreenChange() {{
            var girafeDiv = document.getElementById('{girafe_id}');
            
            if (document.fullscreenElement === container || 
                document.webkitFullscreenElement === container ||
                document.mozFullScreenElement === container) {{
              // I helskÃ¤rm
              container.style.height = '100vh';
              container.style.width = '100vw';
              container.style.background = 'white';
              container.style.overflow = 'auto';
              container.style.padding = '20px';
              
              var girafeContainer = girafeDiv.querySelector('.girafe_container_std');
              if (girafeContainer) {{
                girafeContainer.style.maxWidth = '100%';
                girafeContainer.style.height = 'auto';
              }}
            }} else {{
              // Ute ur helskÃ¤rm
              container.style.height = '';
              container.style.width = '';
              container.style.background = '';
              container.style.overflow = '';
              container.style.padding = '';
              
              var girafeContainer = girafeDiv.querySelector('.girafe_container_std');
              if (girafeContainer) {{
                girafeContainer.style.maxWidth = '';
                girafeContainer.style.height = '';
              }}
            }}
          }}
          
          document.addEventListener('fullscreenchange', handleFullscreenChange);
          document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
          document.addEventListener('mozfullscreenchange', handleFullscreenChange);
          document.addEventListener('MSFullscreenChange', handleFullscreenChange);
        }}
        
        if (document.readyState === 'loading') {{
          document.addEventListener('DOMContentLoaded', initDiagram_{dropdown_id});
        }} else {{
          initDiagram_{dropdown_id}();
        }}
      }})();
    "))),
    
    # Diagrammet
    htmltools::tags$div(
      id = girafe_id,
      style = "width: 100%;",
      girafe(
        ggobj = plot_objekt,
        width_svg = width,
        height_svg = height,
        options = girafe_options
      )
    )
  )
}