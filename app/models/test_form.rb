# encoding: utf-8

class TestForm < Prawn::Document
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
    font "DejaVuSans", size: 10

    stroke do  
      horizontal_line 0, 540, :at => 50
      horizontal_line 10, 40, :at => 70
      horizontal_line 160, 220, :at => 70
      horizontal_line 280, 300, :at => 70
    end  
      
      stroke_circle [100, 100], 50
      stroke_circle [250, 70], 20
    
    

    render
  end
  
end