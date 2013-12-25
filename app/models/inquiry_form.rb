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

    draw_inquiry(-15, 0)
    draw_inquiry(390,0)
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
      move_cursor_to 450



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

      table([ ["", "", "", "", "", "", "", ""] ] * 12 + [["", "Итого", "",  "", "", "", "", ""]],
                :cell_style => {:height => 15, :padding => [2, 30]},
                :column_widths => [23, 90, 60, 33.4, 23.3, 33.2, 23.3, 75.8] )

       
        draw_text 'Приложение " ________ "  приходных документов',
                  at: [10, base_z-335]
        draw_text '" ________ "  расходных документов',
                  at: [66, base_z-350]
        draw_text 'Оператор _________________________               ___________________', style: :bold,
                  at: [66, base_z-365]
        draw_text '(подпись)', :size => 7, at: [143, base_z-373]
        draw_text '(подпись)', :size => 7, at: [275, base_z-373]
        draw_text 'Соответствие итогов справки данным приложенных документов',
                  at: [0, base_z-395]
        draw_text 'проверил     _______________________',
                  at: [200, base_z-410], style: :bold
        draw_text '(должность)', at: [280, base_z-418], :size => 7
        draw_text '_______________________', at: [258, base_z-433], style: :bold
        draw_text '(подпись)', at: [285, base_z-441], :size => 7

        stroke_horizontal_line 0, 380, at: [base_z-445]

        draw_text 'Линия отреза', at: [160, base_z-455]



    end            
  end

end