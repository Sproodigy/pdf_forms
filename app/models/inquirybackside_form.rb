# encoding: utf-8

class InquirybacksideForm < Prawn::Document
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
      base_z = 540
      draw_text 'РАСЧЁТ', at: [155, base_z], :size => 11, style: :bold
      draw_text 'Оператора _________________________________________с Главной кассой за рабочий день',
                at: [0, base_z-20]
      draw_text '"_____" _______________________________20    г.',
                at: [100, base_z-40]
      move_cursor_to 490

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
               my_table, "Расписка начальника (оператора) Главной кассы в приёме сумм в рабочее время (принятая сумма рублей указывается прописью)"] ],
               :column_widths => [23, 90, 124, 130] ) do |t|

        t.column(0).style align: :center, :padding => [14, 0, 0, 1]
        t.column(1).style align: :center, :padding => [14, 0, 0, 0]
        t.column(3).style align: :center, :padding => [0, 0, 0, 0] 

        t.column(4).style borders: [:top, :right, :bottom]
        t.columns(3).style borders: [:top, :left, :bottom]

        end

      table([ ["", "", "", "", "", "", "", ""] ] * 12 + [["", "Итого", "",  "", "", "", "", ""]],
                :cell_style => {:height => 15, padding: [2, 30]},
                :column_widths => [23, 90, 60, 33.4, 23.3, 33.2, 23.3, 75.8] )

      draw_text 'Подлежат сдаче в Главную кассу в окончательный расчёт:',
                at: [0, base_z-310]
      draw_text 'а) наличными деньгами________________________________________________руб.____________коп.',
                at: [0, base_z-325]
      draw_text 'б) акцептованными поручениями и справками Госбанка____________________руб.______коп.',
                at: [0, base_z-340]
      draw_text 'в) чеками из лимитированных и нелимитированных книжек банка и', 
                at: [0, base_z-355]
      draw_text 'чеками сбербанка _________________________________________руб. _______коп.',
                at: [0, base_z-370]
      draw_text 'Всего_______________________руб. _______коп.',at: [130, base_z-385]
      draw_text 'Сдал оператор ____________________________________________',
                at: [130, base_z-400]
      draw_text '(подпись)',at: [270, base_z-408], :size => 7
      draw_text 'Принял начальник (оператор) Главной кассы ____________________________________________',
                at: [0, base_z-415]
      draw_text '(подпись)',at: [270, base_z-423], :size => 7
      draw_text '"_______" ___________________20    г.', at: [0, base_z-430]
      draw_text 'ЛИНИЯ    ОТРЕЗА', at: [150, base_z-440]

      stroke_horizontal_line 0, 380, at: [base_z-445]
 
      draw_text 'РАСПИСКА',at: [165, base_z-455]
      
      stroke_horizontal_line 0, 380, at: [base_z-460]

      draw_text 'В окончательный расчёт за рабочий день (смену) принято от оператора _______________',
                at: [0, base_z-475]
      draw_text '_______________________________по кассовой справке за "_____" ______________________20    г.',
                at: [0, base_z-490]
      draw_text '____________________________________________________________________________________________',
                at: [0, base_z-505]
      draw_text '(сумма прописью)', at: [150, base_z-513], :size => 7
      draw_text 'Принял начальник (оператор) Главной кассы ___________________________________________',
                at: [0, base_z-525]
      draw_text '"______" ___________________ 20     г.                                           _____________________________',
                at: [0, base_z-540]
      draw_text '(подпись)',at: [300, base_z-548], :size => 7
    end
  end
  
end    