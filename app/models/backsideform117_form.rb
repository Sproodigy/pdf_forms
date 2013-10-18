# encoding: utf-8

class Backsideform117Form < Prawn::Document
  def to_pdf
    font_families.update(
      "DejaVuSans" => {
        normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
        bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
        italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
        bold_italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf",
        extra_light: "#{Rails.root}/app/assets/fonts/DejaVuSans-ExtraLight.ttf",
        condensed: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed.ttf",
        condensed_bold: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed-Bold.ttf"
      })
    font "DejaVuSans", size: 9

# Pазмер листа - 770x523 точек

# Правая часть
    
    stroke_vertical_line 0, 523, :at => 385

    base_z = 557
    text_box "Вторичное извещение выписано _________________ 
              Плата за доставку _______________руб.______коп.
              Подлежит оплате ___________________________", 
              :at => [-17, base_z], :height => 100, :width => 145, :leading => 7 

    draw_text "(подпись)", :at => [30, base_z-103], :size => 7
    draw_text "РАСПИСКА АДРЕСАТА", :at => [100, base_z-115], :size => 11

    render

  end
  
end    
