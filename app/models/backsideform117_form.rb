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

      draw_text "(подпись)", :at => [25, base_z-103], :size => 7
      draw_text "РАСПИСКА АДРЕСАТА", :at => [105, base_z-118], :size => 11

    
    bounding_box([-17, base_z-123], :width => 380, :height => 65 ) do

      self.line_width = 2
      move_down 10
      indent(10) do      
        text "Сумма"
        move_down 20
        text 'Получил "______________" ___________________20______г.  ________________ '
        
        indent(273) do
          text "(подпись)", :size => 7
        end
          
      end

        stroke_bounds
    end

    self.line_width = 1
    stroke_color 50, 50, 50 ,10
    6.times do |a|       
        stroke_horizontal_line 30, 360, :at => base_z-128-(3 * a)
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

      dash(2, :space => 4)  
      stroke_horizontal_line -17, 130, :at => base_z-300
      draw_text "л и н и я   о т р е з а", :at => [132, base_z-303],
        :style => :italic, :size => 7
      stroke_horizontal_line 210, 370, :at => base_z-303
      stroke_vertical_line base_z-307, base_z-380, :at => 190
      stroke_vertical_line base_z-460, base_z-550, :at => 190
      dash(0, :spase => 0)

      draw_text "Для получения денег заполните извещение и предъя- ",
                :at => [-12, base_z-313], :size => 6
      draw_text "вите паспорт или документ, удостоверяющий личность",
                :at => [-17, base_z-320], :size => 6 

    stroke do
      self.line_width = 2
      move_to -17, base_z-325

      line_to 177, base_z-325
      line_to 177, base_z-530
      line_to 42, base_z-530
      line_to 42, base_z-506
      line_to -17, base_z-506
      line_to -17, base_z-324
      rectangle [203, base_z-315], 165, 260

    end 
  
      self.line_width = 1
      stroke_rectangle [-5, base_z-510], 40, 40

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
               :at => [-5, base_z-422], :size => 6

      stroke_horizontal_line -13, 170, :at => base_z-470
      stroke_horizontal_line -13, 170, :at => base_z-490

      draw_text "Адресат___________________", :at => [45, base_z-517]
      draw_text "(подпись)", :at => [107, base_z-525], :size => 7

      draw_text "", :at => [20, base_z-580]





    render

  end
  
end    
