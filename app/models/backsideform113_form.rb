# encoding: utf-8

class Backsideform113Form < Prawn::Document
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

    draw_backsideform113(-10, 0)
    draw_backsideform113(420,0)
    render
  end

  def draw_backsideform113(x, y)
    translate(x,y) do
      
# Pазмер листа - 770x523 точек

    base_z = 557
      text_box "Вторичное извещение выписано _________________ 
                Плата за доставку _______________руб.______коп.
                Подлежит оплате ___________________________", 
                :at => [-17, base_z], :height => 100, :width => 145, :leading => 7

      draw_text "О", :at => [120, base_z-25] 
      draw_text "П", :at => [120, base_z-37]
      draw_text "Л", :at => [120, base_z-49]
      draw_text "А", :at => [120, base_z-61]
      draw_text "Т", :at => [120, base_z-73]
      draw_text "А", :at => [120, base_z-85]

      draw_text "(подпись)", :at => [25, base_z-103], :size => 7
      draw_text "РАСПИСКА АДРЕСАТА", :at => [115, base_z-118], :size => 11

    
    bounding_box([-17, base_z-123], :width => 397, :height => 65) do

      self.line_width = 2
      move_down 10
      indent(10) do      
        text "Сумма"
        move_down 20
        text 'Получил "_______" ______________________20_______г.  ______________________________ '
        
        indent(293) do
          text "(подпись)", :size => 7
        end
          
      end

        stroke_bounds
    end

    self.line_width = 1
    stroke_color 50, 50, 50, 10
    6.times do |a|       
        stroke_horizontal_line 30, 370, :at => base_z-128-(3 * a)
    end

    stroke_color 50, 50, 50, 100
      draw_text "Оплатил", :at => [-17, base_z-200]
      stroke_horizontal_line -17, 290, :at => base_z-205
      draw_text "(перечислено)", :at => [-5, base_z-213]
      draw_text "(должность, подпись)",:size => 7, :at => [130, base_z-213]
      draw_text "Отметки о досылке, возвращении и причинах неоплаты",
      :at => [-5, base_z-240]

    3.times do |b|
    stroke do  
      rectangle [300, base_z-205], 60, 60
      horizontal_line -17, 280, :at => base_z-255-(15 * b)
    end
    end

      draw_text "(оттиск календарного", :at => [289, base_z-272], :size => 7
      draw_text "штемпеля ОПС места вр", :at => [285, base_z-280], :size => 7
      draw_text "или дня перечисления)", :at => [287, base_z-288], :size => 7

      stroke_color 50, 50, 50, 10  
      stroke_horizontal_line -17, 130, :at => base_z-300
      stroke_horizontal_line 210, 380, :at => base_z-300
      stroke_vertical_line base_z-307, base_z-400, :at => 190
      stroke_vertical_line base_z-480, base_z-580, :at => 190
      stroke_color 50, 50, 50, 100
      draw_text "л и н и я   о т р е з а", :at => [132, base_z-303],
        :style => :italic, :size => 7
      draw_text "л и н и я   о т р е з а", :at => [190, base_z-477],
        :style => :italic, :size => 7, :rotate => 90

      

      draw_text "Для получения денег заполните извещение и предъя- ",
                :at => [-12, base_z-313], :size => 6
      draw_text "вите паспорт или документ, удостоверяющий личность",
                :at => [-17, base_z-320], :size => 6 

    stroke do
      self.line_width = 2
      move_to -17, base_z-325

      line_to 177, base_z-325
      line_to 177, base_z-529
      line_to 51, base_z-530
      line_to 51, base_z-506
      line_to -17, base_z-506
      line_to -17, base_z-324
      rectangle [203, base_z-315], 177, 260

    end 
  
      self.line_width = 1
      stroke_rectangle [-8, base_z-510], 50, 50

      draw_text "Заполняется адресатом", :at => [-10, base_z-335],
                                         :style => :italic

      text_box 'Предъявлен __________________________ 
                Серия ______ №____________, выданный
                "_____" _______20______г., кем _________
                ________________________________________', 
                :at => [-10, base_z-350], :height => 145,
                :width => 185, :leading => 7

      draw_text "(наименование учреждения выдавшего документ)",
                :at => [-14, base_z-418], :size => 7

      text_box 'Для переводов, адресованных "до востребования",
               на а\я, по месту работы (учёбы), при несовпадении
               прописки или регистрации с указанным адресом,
               укажите адрес и дату прописки или регистрации',
               :at => [-5, base_z-422], :size => 6, :indent_paragraphs => 50

      stroke_horizontal_line -13, 170, :at => base_z-471
      stroke_horizontal_line -13, 170, :at => base_z-491

      draw_text "Адресат________________", :at => [55, base_z-517]
      draw_text "(подпись)", :at => [110, base_z-525], :size => 7

      draw_text "ТАЛОН", :at => [292, base_z-335], :size => 11
      draw_text "к почтовому переводу", :at => [257, base_z-350], :style => :bold
      draw_text "наложенного платежа", :at => [257, base_z-360], :style => :bold
      draw_text "На __________________руб.______коп.",
                :at => [207, base_z-400], :style => :bold
      draw_text "От кого", :at => [207, base_z-440], :style => :bold
      draw_text "Адрес отправителя", :at => [207, base_z-490], :style => :bold

      draw_text "Оплатил ___________________", :at => [50, base_z-560]
      draw_text "(дата, подпись)", :at => [115, base_z-568], :size => 6
      draw_text "(оттиск календ. шт.", :at => [-15, base_z-565], :size => 6
      draw_text "ОПС места", :at => [-2, base_z-572], :size => 6
      draw_text "вручения РПО)", :at => [-8, base_z-579], :size => 6


    end

  end
  
end    
