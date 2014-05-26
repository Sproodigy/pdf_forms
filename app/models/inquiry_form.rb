class InquiryForm < Prawn::Document

  def initialize
	  super(page_layout: :landscape, page_size: 'A4')
  end

  def print_inquiry
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

    draw_inquiry(-5, 0)
    draw_inquiry(420,0)
    render
  end


  def draw_inquiry(x, y)
    translate(x,y) do

      base_z = 530
      base_x = -20
      
      draw_text "Форма № МС-42", at: [base_x+330, base_z], size: 7
      draw_text "______________________________", at:[base_x, base_z-10], size: 10
      draw_text "(наименование предприятия связи)", at: [base_x+10, base_z-20], size: 7
      draw_text "Кассовая справка", at: [base_x+140, base_z-35], style: :bold, size: 10
      draw_text "оператора ____________________________________________",
                at: [base_x+50, base_z-50], size: 10
      draw_text "за __________________________ месяц 20     г.",
                at: [base_x+80, base_z-70], size: 10
      move_cursor_to 450

      table([ ["№ п/п", "Наименование операции",
               "Корреспон-дирующие счета (шифр операции)",
               "", "Основание"] ],
               :position => base_x, :cell_style => {:height => 45},
               :column_widths => [23, 90, 65, 130, 95] ) do |t|

        t.column(0).style align: :center, :padding => [12, 0, 0, 1]
        t.column(1).style align: :center, :padding => [12, 0, 0, 0]
        t.column(2).style align: :center, :padding => [2, 0, 0, 0]
        t.column(4).style align: :center, :padding => [17, 0, 0, 0]

        end
  
      table([ ["", "", "", "", "", "", "", ""] ] * 12 + [["", "Итого", "",  "", "", "", "", ""]],
              :position => base_x,
              :cell_style => {:height => 15, :padding => [2, 30]},
              :column_widths => [23, 90, 65, 40, 25, 40, 25, 95] )

      stroke do
        horizontal_line base_x+178, base_x+308, :at => base_z-95
        horizontal_line base_x+178, base_x+308, :at => base_z-110
        vertical_line base_z-95, base_z-125, :at => base_x+243
        vertical_line base_z-110, base_z-125, :at => base_x+218
        vertical_line base_z-110, base_z-125, :at => base_x+283
      end 

        draw_text 'Сумма, руб. коп.', at: [base_x+208, base_z-90]
        draw_text 'приход', at: [base_x+195, base_z-105]
        draw_text 'расход', at: [base_x+260, base_z-105]
        draw_text 'руб.', at: [base_x+190, base_z-120]
        draw_text 'руб.', at: [base_x+253, base_z-120]
        draw_text 'коп.', at: [base_x+222, base_z-120]
        draw_text 'коп.', at: [base_x+287, base_z-120]

        draw_text 'Приложение " ________ "  приходных документов',
                  at: [base_x+10, base_z-335]
        draw_text '" ________ "  расходных документов',
                  at: [base_x+66, base_z-350]

        text_box 'Квитанционные тетради реестра ф.10 и другие документы принял', 
                  at: [base_x+256, base_z-325], height: 50, width: 120
        draw_text 'Оператор _________________________               ___________________', style: :bold,
                  at: [base_x+66, base_z-365]
        draw_text '(подпись)', :size => 7, at: [base_x+143, base_z-373]
        draw_text '(подпись)', :size => 7, at: [base_x+275, base_z-373]
        draw_text 'Соответствие итогов справки данным приложенных документов',
                  at: [base_x, base_z-395]
        draw_text 'проверил     _______________________',
                  at: [base_x+200, base_z-410], style: :bold
        draw_text '(должность)', at: [base_x+280, base_z-418], :size => 7
        draw_text '_______________________', at: [base_x+258, base_z-433], style: :bold
        draw_text '(подпись)', at: [base_x+285, base_z-441], :size => 7

        stroke_horizontal_line base_x, 380, at: [base_z-445]

        draw_text 'Линия отреза', at: [base_x+180, base_z-452]



    end            
  end

  def print_inquiry_back
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

	  draw_inquiry_back(-10, 0)
	  draw_inquiry_back(415,0)
	  render
  end

  def draw_inquiry_back(x, y)
	  translate(x,y) do

		  base_z = 540
		  base_x = -20

		  draw_text 'РАСЧЁТ', at: [base_x+155, base_z], :size => 11, style: :bold
		  draw_text 'Оператора _________________________________________с Главной кассой за рабочий день',
		            at: [base_x, base_z-20]
		  draw_text '"_____" _______________________________20    г.',
		            at: [base_x+100, base_z-40]
		  move_cursor_to 490

		  table([ ["№ п/п", "Наименование операции", "",
		           "Расписка начальника (оператора) Главной кассы в приёме сумм в рабочее время (принятая сумма рублей указывается прописью)"] ],
		        :position => base_x, :cell_style => {:height => 45},
		        :column_widths => [23, 100, 130, 150] ) do |t|

			  t.column(0).style align: :center, :padding => [12, 0, 0, 1]
			  t.column(1).style align: :center, :padding => [12, 0, 0, 0]
			  t.column(3).style align: :center, :padding => [3, 0, 0, 0]

		  end

		  stroke do
			  horizontal_line base_x+123, base_x+253, :at => base_z-65
			  horizontal_line base_x+123, base_x+253, :at => base_z-80
			  vertical_line base_z-65, base_z-95, :at => base_x+188
			  vertical_line base_z-80, base_z-95, :at => base_x+163
			  vertical_line base_z-80, base_z-95, :at => base_x+228
		  end

		  draw_text 'Сумма, руб. коп.', at: [base_x+155, base_z-60]
		  draw_text 'приход', at: [base_x+141, base_z-75]
		  draw_text 'расход', at: [base_x+205, base_z-75]
		  draw_text 'руб.', at: [base_x+135, base_z-90]
		  draw_text 'руб.', at: [base_x+200, base_z-90]
		  draw_text 'коп.', at: [base_x+167, base_z-90]
		  draw_text 'коп.', at: [base_x+232, base_z-90]

		  table([ ["", "", "", "", "", "", ""] ] * 12 + [["", "Итого", "",  "", "", "", ""]],
		        :position => base_x,
		        :cell_style => {:height => 15, padding: [2, 30]},
		        :column_widths => [23, 100, 40, 25, 40, 25, 150] )

		  draw_text 'Подлежат сдаче в Главную кассу в окончательный расчёт:',
		            at: [base_x, base_z-310]
		  draw_text 'а) наличными деньгами_____________________________________________________руб.____________коп.',
		            at: [base_x, base_z-325]
		  draw_text 'б) акцептованными поручениями и справками Госбанка_________________________руб.______коп.',
		            at: [base_x, base_z-340]
		  draw_text 'в) чеками из лимитированных и нелимитированных книжек банка и',
		            at: [base_x, base_z-355]
		  draw_text 'чеками сбербанка ______________________________________________руб. _______коп.',
		            at: [base_x, base_z-370]
		  draw_text 'Всего____________________________руб. _______коп.',at: [base_x+130, base_z-385]
		  draw_text 'Сдал оператор ___________________________________________________',
		            at: [base_x+130, base_z-400]
		  draw_text '(подпись)',at: [base_x+280, base_z-408], :size => 7
		  draw_text 'Принял начальник (оператор) Главной кассы ___________________________________________________',
		            at: [base_x, base_z-415]
		  draw_text '(подпись)',at: [base_x+280, base_z-423], :size => 7
		  draw_text '"________" ______________________ 20     г.', at: [base_x, base_z-430]
		  draw_text 'Линия отреза', at: [base_x+180, base_z-444]

		  stroke_horizontal_line base_x, 380, at: base_z-445

		  draw_text 'РАСПИСКА',at: [base_x+183, base_z-458], style: :bold

		  stroke_horizontal_line base_x, 380, at: base_z-460

		  draw_text 'В окончательный расчёт за рабочий день (смену) принято от оператора ______________________',
		            at: [base_x, base_z-475]
		  draw_text '__________________________________по кассовой справке за "________" ______________________ 20     г.',
		            at: [base_x, base_z-490]
		  draw_text '____________________________________________________________________________________________________',
		            at: [base_x, base_z-505]
		  draw_text '(сумма прописью)', at: [base_x+170, base_z-513], :size => 7
		  draw_text 'Принял начальник (оператор) Главной кассы ___________________________________________________',
		            at: [base_x, base_z-525]
		  draw_text '"________" ______________________ 20     г.                                                _____________________________',
		            at: [base_x, base_z-540]
		  draw_text '(подпись)', at: [base_x+325, base_z-548], :size => 7
		  draw_text '"МСПЦ"',at: [base_x+380, base_z-555], :size => 5

	  end
  end

end