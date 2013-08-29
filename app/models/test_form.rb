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

      self.line_width = 3
      stroke_color 100, 20, 100, 0
      horizontal_line 310, 540, :at => 97  
      horizontal_line 0, 540, :at => 49
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
      curve [225, 70], [275, 70], :bounds => [[220, 105], [280, 105]]

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
      horizontal_line 410, 460, :at => 170
      horizontal_line 446, 450, :at => 125
      horizontal_line 446, 450, :at => 135
      horizontal_line 416, 433, :at => 148
      horizontal_line 416, 433, :at => 130
      horizontal_line 385, 400, :at => 210
      horizontal_line 505, 520, :at => 210
      horizontal_line 380, 400, :at => 216
      horizontal_line 500, 520, :at => 216
      
    end  

    stroke do

      stroke_color 30, 50, 100, 0
      vertical_line 100, 250, :at => 330
      vertical_line 100, 250, :at => 540
      vertical_line 101, 170, :at => 410
      vertical_line 101, 170, :at => 460
      vertical_line 101, 170, :at => 440
      vertical_line 125, 135, :at => 450
      vertical_line 130, 148, :at => 416
      vertical_line 130, 148, :at => 433
      vertical_line 185, 210, :at => 385
      vertical_line 185, 210, :at => 505
      vertical_line 185, 216, :at => 380
      vertical_line 185, 216, :at => 500

    end

    stroke do

      stroke_color 50, 90, 50, 50
      rectangle [350, 240], 52, 55
      rectangle [470, 240], 52, 55

    end  

      stroke_color 70, 20, 80, 0
      line [330, 250], [360, 300]
      line [510, 300], [540, 250]
      stroke

      draw_text "...", :at => [419, 140], style: :bold
      draw_text "...", :at => [419, 137], style: :bold
      draw_text "...", :at => [419, 134], style: :bold


    # Ёлки

    self.line_width = 5
    
    [:miter, :miter, :miter].each_with_index do |style, i|
      self.join_style = style

      y = 600 - i*50
      stroke do
        move_to(100, y)
        line_to(150, y + 49)
        line_to(200, y)

      end 
     
    end 

      stroke_polygon [50, 750], [20, 700], [80, 700]
      stroke_polygon [50, 700], [10, 650], [90, 650]
      stroke_polygon [50, 650], [0, 600], [100, 600]
      stroke_polygon [60, 540], [50, 520], [70, 520]
      stroke_polygon [60, 518], [40, 500], [80, 500]
      stroke_polygon [60, 498], [30, 480], [90, 480]

    stroke do

      horizontal_line 99, 201, :at => 500
      horizontal_line 99, 201, :at => 550
      horizontal_line 99, 201, :at => 600

    end

    stroke do

      stroke_color 30, 50, 100, 0
      rectangle [143, 497], 15, 35
      rectangle [40, 597], 15, 35
      rectangle [57, 477], 5, 10

    end

    #Домик сверху

    stroke do

      stroke_color 60, 60, 10, 40
      rectangle [300, 650], 240, 150
      horizontal_line 330, 510, at: 700
      line [300, 650], [331, 700]
      line [540, 650], [508, 700]

    end     

    render

  end
  
end