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

      draw_text "Обведённое жирной чертой",
                :at => [-17, base_z-330], :style => :bold, :rotate => 90
      draw_text "заполняется получателем",
                :at => [-7, base_z-330], :style => :bold, :rotate => 90          

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
