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

    stroke_vertical_line 0, 735, :at =>270

    draw_text 'ПОСТУПЛЕНИЯ АВАНСОВ ПО РАСЧЁТАМ ЗА УСЛУГИ СВЯЗИ', at: [100, 745], style: :bold

# Левая часть

    

    #draw_text '______________________20      г. На _________________руб.______коп.', at: [0, 730] 
    draw_text 'сумма прописью', at: [110, 720], size: 6
    move_down 3

    base_y = 718
    stroke_color 50, 50, 50, 10
    9.times do |i|
      stroke_horizontal_line 0, 265, :at => base_y - (2 * i)
    end  

    move_down 22

    stroke_color 50, 50, 50, 100
    text 'м. п.          Дата_________________________№___________поручение'
    move_down 10

    text 'Гл. бухгалтер                            Бухгалтер', style: :bold
    move_down 3

    self.line_width = 2
    base_b = 658
    stroke_horizontal_line 0, 265
    stroke_horizontal_line 0, 265, :at => base_b
    move_down 6
    
    self.line_width = 1

    base_x = 730
    9.times do |a|
      draw_text "______________________20      г. На _________________руб.______коп.", at: [0, base_x - (76 * a)]
    end
    draw_text 'сумма прописью', at: [110, cursor-7], size: 6

    base_y = 638
    stroke_color 50, 50, 50, 10
    9.times do |i|
      stroke_horizontal_line 0, 265, :at => base_y - (2 * i)
    end  

    move_down 32

    stroke_color 50, 50, 50, 100
    text 'м. п.          Дата_________________________№___________поручение'
    move_down 10

    text 'Гл. бухгалтер                        Бухгалтер', style: :bold
    move_down 3

    self.line_width = 2
    stroke_horizontal_line 0, 265
    move_down 6
    
    self.line_width = 1

    

    #text '______________________20      г. На _________________руб.______коп.'
    draw_text 'сумма прописью', at: [110, cursor-7], size: 6

    base_y = 558
    stroke_color 50, 50, 50, 10
    9.times do |i|
      stroke_horizontal_line 0, 265, :at => base_y - (2 * i)
    end  

    move_down 32

    stroke_color 50, 50, 50, 100
    text 'м. п.          Дата_________________________№___________поручение'
    move_down 10

    text 'Гл. бухгалтер                        Бухгалтер', style: :bold
    move_down 3

    self.line_width = 2
    stroke_horizontal_line 0, 265
    move_down 6
    
    self.line_width = 1

# Правая часть

    draw_text '______________________20      г. На _________________руб.______коп.', at: [275, 730]
    draw_text 'сумма прописью', at: [385, 720], size: 6
    move_down 3

    base_y = 718
    stroke_color 50, 50, 50, 10
    9.times do |i|
      stroke_horizontal_line 275, 540, :at => base_y - (2 * i)
    end  

    move_down 22

    stroke_color 50, 50, 50, 100
    text 'м. п.          Дата_________________________№___________поручение'
    move_down 10

    text 'Гл. бухгалтер                            Бухгалтер', style: :bold
    move_down 3

    self.line_width = 2
    stroke_horizontal_line 0, 265
    move_down 6
    
    self.line_width = 1


    draw_text '______________________20      г. На _________________руб.______коп.', at: [275, 640]
    draw_text 'сумма прописью', at: [385, cursor-7], size: 6

    base_y = 638
    stroke_color 50, 50, 50, 10
    9.times do |i|
      stroke_horizontal_line 275, 540, :at => base_y - (2 * i)
    end  

    move_down 32

    stroke_color 50, 50, 50, 100
    text 'м. п.          Дата_________________________№___________поручение'
    move_down 10

    text 'Гл. бухгалтер                        Бухгалтер', style: :bold
    move_down 3

    self.line_width = 2
    stroke_horizontal_line 0, 265
    move_down 6
    
    self.line_width = 1

    

    draw_text '______________________20      г. На _________________руб.______коп.', at: [275, 600]
    draw_text 'сумма прописью', at: [385, cursor-7], size: 6

    base_y = 558
    stroke_color 50, 50, 50, 10
    9.times do |i|
      stroke_horizontal_line 275, 540, :at => base_y - (2 * i)
    end  

    move_down 32

    stroke_color 50, 50, 50, 100
    text 'м. п.          Дата_________________________№___________поручение'
    move_down 10

    text 'Гл. бухгалтер                        Бухгалтер', style: :bold
    move_down 3

    self.line_width = 2
    stroke_horizontal_line 0, 265
    move_down 6
    
    self.line_width = 1

    



    render

  end  

end  