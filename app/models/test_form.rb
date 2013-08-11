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

  # Трактор

    stroke do

      stroke_color 100, 20, 100, 0  
      horizontal_line 0, 540, :at => 50
      horizontal_line 10, 40, :at => 70
      horizontal_line 160, 225, :at => 70
      horizontal_line 275, 300, :at => 70
      horizontal_line 60, 220, :at => 310
      horizontal_line 200, 280, :at => 180
      horizontal_line 220, 285, :at => 350

    end

    stroke do

      stroke_color 10, 10, 10, 100
      curve [40, 70], [160, 70], :bounds => [[20, 190], [180, 190]]
      curve [225, 70], [275 ,70], :bounds => [[220, 105], [280, 105]]

    end

    stroke do

      stroke_color 0, 100, 20, 0
      vertical_line 70, 280, :at => 10
      vertical_line 70, 160, :at => 300
      vertical_line 180, 220, :at => 200
      vertical_line 180, 330, :at => 240
      vertical_line 180, 330, :at => 265

    end

      stroke_color 30, 80, 0, 0
      stroke_circle [100, 100], 50
      stroke_circle [250, 70], 20
      stroke_circle [100, 100], 15
      stroke_circle [250, 70], 7

      stroke_color 100, 50, 0, 0
      line [10, 280], [60, 310]
      line [200, 220], [220, 310]
      line [280, 180], [300, 160]
      line [220, 350], [240, 330]
      line [285, 350], [265, 330]
      stroke

  # Домик

    stroke do

      stroke_color 1, 0, 0, 100
      horizontal_line 330, 540, :at => 100
      horizontal_line 360, 510, :at => 300 
      horizontal_line 350, 400, :at => 250
      horizontal_line 470, 520, :at => 250
      horizontal_line 470, 520, :at => 200
      horizontal_line 350, 400, :at => 200

    end  

    stroke do

      stroke_color 30, 50, 100, 0
      vertical_line 100, 250, :at => 330
      vertical_line 100, 250, :at => 540
      vertical_line 200, 250, :at => 350
      vertical_line 200, 250, :at => 400

    end

      stroke_color 70, 20, 80, 0
      line [330, 250], [360, 300]
      line [510, 300], [540, 250]
      stroke

    render

  end
  
end