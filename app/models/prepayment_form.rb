# encoding: utf-8

class PrepaymentForm < Prawn::Document
  include ActionView::Helpers::NumberHelper

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
    font "DejaVuSans", size: 8

    stroke_horizontal_line 0, 540, :at => 755

# Левая часть

    11.times do |a|
    3.times do |b|    
           
    self.line_width = 1

        stroke do
            vertical_line 735, 495, :at =>270
            vertical_line 475, 235, :at =>270
            vertical_line 210, -30, :at =>270
        end    

        base_f = 745
        draw_text 'ПОСТУПЛЕНИЯ АВАНСОВ ПО РАСЧЁТАМ ЗА УСЛУГИ СВЯЗИ', at: [130, base_f - (265 * b)], style: :bold

        base_x = 730
        draw_text "______________________20      г. На _________________руб.______коп.", at: [0, base_x - (80.2 * b)]
        
        base_z = 720
        draw_text 'сумма прописью', at: [110, base_z - (80 * b)], size: 6

        base_y = 717
        stroke_color 50, 50, 50, 10
        stroke do
            horizontal_line 0, 265, :at => base_y - (2 * a)
            horizontal_line 0, 265, :at => base_y - 80 - (2 * a)
            horizontal_line 0, 265, :at => base_y - 160 - (2 * a)
        end    

        base_c = 680
        stroke_color 50, 50, 50, 100
        draw_text 'м. п.          Дата_________________________№___________поручение', at: [0, base_c - (80 * b)]

        base_d = 665
        draw_text 'Гл. бухгалтер                            Бухгалтер', at: [0, base_d - (80 * b)], style: :bold

        self.line_width = 2
        base_e = 659
        stroke_horizontal_line 0, 265, :at => base_e - (80 * b)


        self.line_width = 1

        base_x = 465
        draw_text "______________________20      г. На _________________руб.______коп.", at: [0, base_x - (80.2 * b)]
    
        base_z = 455
        draw_text 'сумма прописью', at: [110, base_z - (80 * b)], size: 6

        base_y = 452
        stroke_color 50, 50, 50, 10
        stroke do
            horizontal_line 0, 265, :at => base_y - (2 * a)
            horizontal_line 0, 265, :at => base_y - 80 - (2 * a)
            horizontal_line 0, 265, :at => base_y - 160 - (2 * a)
        end

        base_c = 415
        stroke_color 50, 50, 50, 100
        draw_text 'м. п.          Дата_________________________№___________поручение', at: [0, base_c - (80 * b)]

        base_d = 400
        draw_text 'Гл. бухгалтер                            Бухгалтер', at: [0, base_d - (80 * b)], style: :bold

        self.line_width = 2
        base_e = 394
        stroke_horizontal_line 0, 265, :at => base_e - (80 * b)

        self.line_width = 1

        base_x = 200
        draw_text "______________________20      г. На _________________руб.______коп.", at: [0, base_x - (80.2 * b)]
    
        base_z = 190
        draw_text 'сумма прописью', at: [110, base_z - (80 * b)], size: 6

        base_y = 187
        stroke_color 50, 50, 50, 10
        stroke do
            horizontal_line 0, 265, :at => base_y - (2 * a)
            horizontal_line 0, 265, :at => base_y - 80 - (2 * a)
            horizontal_line 0, 265, :at => base_y - 160 - (2 * a)
        end

        base_c = 150
        stroke_color 50, 50, 50, 100
        draw_text 'м. п.          Дата_________________________№___________поручение', at: [0, base_c - (80 * b)]

        base_d = 135
        draw_text 'Гл. бухгалтер                            Бухгалтер', at: [0, base_d - (80 * b)], style: :bold

        self.line_width = 2
        base_e = 129
        stroke_horizontal_line 0, 265, :at => base_e - (80 * b)

# Правая часть

        self.line_width = 1

        base_x = 730
        draw_text "______________________20      г. На _________________руб.______коп.", at: [275, base_x - (80.2 * b)]
        
        base_z = 720
        draw_text 'сумма прописью', at: [385, base_z - (80 * b)], size: 6

        base_y = 717
        stroke_color 50, 50, 50, 10
        stroke do
            horizontal_line 275, 540, :at => base_y - (2 * a)
            horizontal_line 275, 540, :at => base_y - 80 - (2 * a)
            horizontal_line 275, 540, :at => base_y - 160 - (2 * a)
        end    

        base_c = 680
        stroke_color 50, 50, 50, 100
        draw_text 'м. п.          Дата_________________________№___________поручение', at: [275, base_c - (80 * b)]

        base_d = 665
        draw_text 'Гл. бухгалтер                            Бухгалтер', at: [275, base_d - (80 * b)], style: :bold

        self.line_width = 2
        base_e = 659
        stroke_horizontal_line 275, 540, :at => base_e - (80 * b)


        self.line_width = 1

        base_x = 465
        draw_text "______________________20      г. На _________________руб.______коп.", at: [275, base_x - (80.2 * b)]
    
        base_z = 455
        draw_text 'сумма прописью', at: [385, base_z - (80 * b)], size: 6

        base_y = 452
        stroke_color 50, 50, 50, 10
        stroke do
            horizontal_line 275, 540, :at => base_y - (2 * a)
            horizontal_line 275, 540, :at => base_y - 80 - (2 * a)
            horizontal_line 275, 540, :at => base_y - 160 - (2 * a)
        end

        base_c = 415
        stroke_color 50, 50, 50, 100
        draw_text 'м. п.          Дата_________________________№___________поручение', at: [275, base_c - (80 * b)]

        base_d = 400
        draw_text 'Гл. бухгалтер                            Бухгалтер', at: [275, base_d - (80 * b)], style: :bold

        self.line_width = 2
        base_e = 394
        stroke_horizontal_line 275, 540, :at => base_e - (80 * b)

        self.line_width = 1

        base_x = 200
        draw_text "______________________20      г. На _________________руб.______коп.", at: [275, base_x - (80.2 * b)]
    
        base_z = 190
        draw_text 'сумма прописью', at: [385, base_z - (80 * b)], size: 6

        base_y = 187
        stroke_color 50, 50, 50, 10
        stroke do
            horizontal_line 275, 540, :at => base_y - (2 * a)
            horizontal_line 275, 540, :at => base_y - 80 - (2 * a)
            horizontal_line 275, 540, :at => base_y - 160 - (2 * a)
        end

        base_c = 150
        stroke_color 50, 50, 50, 100
        draw_text 'м. п.          Дата_________________________№___________поручение', at: [275, base_c - (80 * b)]

        base_d = 135
        draw_text 'Гл. бухгалтер                            Бухгалтер', at: [275, base_d - (80 * b)], style: :bold

        self.line_width = 2
        base_e = 129
        stroke_horizontal_line 275, 540, :at => base_e - (80 * b)

    end

    end    
    

    render

  end  

end  