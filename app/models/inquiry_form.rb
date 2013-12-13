# encoding: utf-8

class InquiryForm < Prawn::Document
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

    draw_inquiry(0, 0)
    draw_inquiry(410,0)
    render
  end


  def draw_inquiry(x, y)
    translate(x,y) do

      stroke_vertical_line 0, 540, :at => 385

      base_z = 530
      
      draw_text "Форма № МС-42", at: [315, base_z], size: 7
      draw_text "______________________________", at:[0, base_z-10], size: 10
      draw_text "(наименование предприятия связи)", at: [10, base_z-20], size: 7
      draw_text "Кассовая справка", at: [140, base_z-35], style: :bold, size: 10
      draw_text "оператора ____________________________________________", at: [50, base_z-50], size: 10
      draw_text "за __________________________ месяц 20     г.", at: [80, base_z-70], size: 10
      move_cursor_to 440



      my_table = make_table([ [{:content => "Сумма, руб. коп.", :colspan => 4}], 
                              [{:content => "приход", :colspan => 2},
                              {:content => "расход", :colspan => 2}],
                             [{:content => "руб."},
                               {:content => "к."},
                               {:content => "руб."},
                               {:content => "к."}]
                             ], :cell_style => {:padding => [3, 8, 2, 8]}) do |t|
        
      end

      table([ ["№ п/п", "Наименование операции",
               "Корреспон-дирующие счета (шифр операции)",
               my_table, "Основание"] ],
               :column_widths => [23, 90, 60, 124, 65] ) do |t|

        t.column(0).style align: :center
        t.column(1).style align: :center
        t.column(2).style align: :center
        t.column(4).style align: :left 

        t.column(4).style borders: [:top, :right, :bottom]
        t.columns(3).style borders: [:top, :left, :bottom]

        t.column(2).style padding: [0, 0, 0, 0]

        end

      table([ ["", "", "", "", "", "", "", ""] ] * 13,
                :cell_style => {:height => 15},
                :column_widths => [23, 90, 60, 33.4, 23.3, 33.2, 23.3, 75.8] )

          
    end            
  end

end