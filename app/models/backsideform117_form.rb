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
    
    stroke_vertical_line 0, 523, :at => 385

    base_z = 550 

      draw_text "Извещение передано в доставку________________________________________________",
                :at => [-17, base_z], :style => :bold
      draw_text "Вторичное извещение выписано ________________________________________________",
                :at => [-17, base_z-20], :style => :bold
      draw_text "(дата и подпись)", :at => [225, base_z-8], :size => 7
      draw_text "(дата и подпись)", :at => [225, base_z-28], :size => 7
      draw_text "Плата", :at => [-17, base_z-34], :style => :bold
      draw_text "За хранение______________________________________________руб.___________________коп.",
                :at => [-17, base_z-48]
      draw_text "За доставку_______________________________________________руб.___________________коп.",
                :at => [-17, base_z-63]
      draw_text "Отметки о досылке и возвращении",
                :at => [90, base_z-78], :style => :bold

      stroke do
        horizontal_line -17, 300, :at => base_z-92
        horizontal_line -17, 300, :at => base_z-109
        horizontal_line -17, 300, :at => base_z-160
        rectangle [310, base_z-75], 60, 60
        rectangle [317, base_z-285], 60, 60
      end

      draw_text "Плата", :at => [-17, base_z-123], :style => :bold
      draw_text "За возвращение, досылку___________________________руб.________коп.",
                :at => [-17, base_z-133]

      draw_text "(оттиск календ.", :at => [310, base_z-142], :size => 7
      draw_text "штемпеля ОПС", :at => [311, base_z-150], :size => 7
      draw_text "места вручения)", :at => [309, base_z-158], :size => 7
      draw_text "(дата и подпись)", :at => [125, base_z-167], :size => 7

<<<<<<< HEAD
      draw_text "Обведённое жирной чертой",
                :at => [-17, base_z-330], :style => :bold, :rotate => 90
      draw_text "заполняется получателем",
                :at => [-7, base_z-330], :style => :bold, :rotate => 90          
=======
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
>>>>>>> c3a48f4000beba85a5c79170b7f91e1ba0556fcf

    stroke do
      self.line_width = 2
      move_to 0, base_z-175

      line_to 380, base_z-175
      line_to 380, base_z-275
      line_to 310, base_z-275
      line_to 310, base_z-350
      line_to 0, base_z-350
      line_to 0, base_z-175    
    end 
<<<<<<< HEAD
=======
  
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


>>>>>>> c3a48f4000beba85a5c79170b7f91e1ba0556fcf

      self.line_width = 1

      draw_text "Отметка о предоставленном документе и подпись адресата",
                :at => [30, base_z-185], :style => :bold

      text_box 'Предъявлен ________________________________Cерия_________№__________________
                Выдан "______" ______________________20______г. кем ____________________________
                _________________________________________________________________________________', 
                :at => [5, base_z-195], :height => 85,
                :width => 370, :leading => 8
      draw_text "(наименование документа)", :at => [85, base_z-210], :size => 7
      draw_text "(наименование учреждения,", :at => [260, base_z-229], :size => 7
      draw_text "выдавшего документ)", :at => [140, base_z-247], :size => 7
      draw_text 'При получении посылок, адресованных "До востребования", по месту работы, учёбы,а/я',
                :at => [5, base_z-260], :size => 7, :style => :bold
      draw_text "при проживании по другому адресу укажите сведения о месте регистрации",
                :at => [5, base_z-270], :size => 7, :style => :bold 
      draw_text "Зарегистрирован________________________________________________",
                :at => [5, base_z-295]                   
      draw_text "Посылку с верной массой, исправными упаковкой, печатями и перевязью",
                :at => [5, base_z-315], :size => 7, :style => :bold
      draw_text 'Получил "______"___________________20_____г.____________________',
                :at => [5, base_z-335]
      draw_text "(подпись адресата)",
                :at => [219, base_z-343], :size => 7 

      draw_text "Выдал_______________________________________________________________________________",
                :at => [-17, base_z-375]
      draw_text "л и н и я   о т р е з а", :at => [140, base_z-400],
                :style => :italic, :size => 7          

      stroke_color 50, 50, 50, 10  
      stroke_horizontal_line -17, 138, :at => base_z-397
      stroke_horizontal_line 217, 375, :at => base_z-397
      stroke_color 50, 50, 50, 100
      
      draw_text "Выдача производится по адресу:___________________________________________________",
                :at => [-17, base_z-420]
      draw_text "______________________________________________от____________________до_______________",
                :at => [-17, base_z-450]
      draw_text "Для письменного сообщения",
                :at => [100, base_z-485], :style => :bold  

    3.times do |a|
      stroke_horizontal_line -17, 370, :at => base_z-515-(25 * a)
    end   

      draw_text "(оттиск календ.", :at => [317, base_z-351], :size => 7
      draw_text "штемпеля ОПС", :at => [318, base_z-359], :size => 7
      draw_text "места вручения)", :at => [317, base_z-366], :size => 7                 

    render

  end
  
end    
