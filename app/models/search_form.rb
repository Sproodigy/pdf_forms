class SearchForm < Prawn::Document

def initialize
		super left_margin: 45, top_margin: 25, right_margin: 45
	end

	def draw_checkbox(x, y, label, type_checked = false, ctg_checked = false)
		stroke_rectangle [x, y], 18, 18
		line_width 2
		stroke do
			move_to x+2, y-8
			line_to x+8, y-16
			line_to x+16, y-2
		end if type_checked or ctg_checked
		line_width 1
		text_box label, at: [x+21, y], valign: :center, height: 20
	end

	def print_search(sender:, receiver:, sender_address:, receiver_address:, mail_type:, mail_ctg:, value:, payment:, date:, barcode:, weight:, packaging:, content:)

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

		# "Шапка" заявления

		formatted_text_box [{text: "\nКому:  "}, {text: 'Начальнику Самарского Почтамта Омельченко В. М.', styles: [:bold]},
		                    {text: "\nОт: "}, {text: sender, styles: [:bold]},
		                    {text: "\nПроживающего: "}, {text: sender_address, styles: [:bold]}],
		                   at: [225, 730], width: 330
		move_cursor_to 625

		# Данные заявления

		text 'ЗАЯВЛЕНИЕ', style: :bold, size: 12, align: :center
		move_down 10

		text 'внутреннее почтовое отправление, почтовый перевод, телеграмма, пенсия', style: :bold, align: :center
		text '(нужное подчеркнуть)', align: :center

		fill_color 'dddddd'
		fill_rectangle [0, cursor], 101, 15
		fill_color '000000'
		move_down 10
		draw_text 'Причина заявления', at: [4, cursor]
		move_down 12
		draw_checkbox 0, cursor, "Отправление (перевод)\nне поступило", true
		draw_checkbox 175, cursor, "Нет части\nвложения"
		draw_checkbox 295, cursor, "Повреждение\nвложения"
		draw_checkbox 420, cursor, "Замедление\nв прохождении"
		move_down 25
		draw_checkbox 0, cursor, "Сумма возмещения\nне получена"
		draw_checkbox 175, cursor, "Уведомление о получении не получено или\nне оформлено соответствующим образом"
		move_down 25
		draw_checkbox 0, cursor, "Иное (указать)"
		stroke_horizontal_line 96, 520, at: 498
		move_down 30

		fill_color 'dddddd'
		fill_rectangle [0, cursor], 117, 15
		fill_color '000000'
		draw_text 'Почтовое отправление', at: [4, cursor-11]
		move_down 20
		draw_checkbox 0, cursor, "Простое"
		draw_checkbox 82, cursor, "Регистрируемое", mail_type == 'Посылка'
		move_up 5

		if mail_type == 'Посылка' and mail_ctg == 'Ценная'
			bounding_box([190, cursor], width: 340, height: 28) do
				formatted_text_box [{text: draw_checkbox(5, cursor-5, "С объявленной\nценностью: ", true)},
				                    {text: value.to_s, styles: [:bold]}, {text: ' руб  '}, {text: "38 ", styles: [:bold]},
				                    {text: 'коп'}],
				                   at: [82, cursor-16]
				formatted_text_box [{text: draw_checkbox(182, cursor-5, "Наложенный\nплатёж: ", true)},
				                    {text: payment.to_s, styles: [:bold]}, {text: ' руб  '},
				                    {text: "38 ", styles: [:bold]}, {text: 'коп'}], at: [243, cursor-16]
				stroke_bounds
			end
		end
		move_cursor_to 427

		draw_checkbox 0, cursor, "Почтовая\nкарточка"
		draw_checkbox 82, cursor, "Письмо"
		draw_checkbox 195, cursor, "Бандероль"
		draw_checkbox 310, cursor, "Посылка", mail_type == 'Посылка'
		move_down 30
		draw_checkbox 0 , cursor, "Секограмма"
		draw_checkbox 82, cursor, "Прямой почтовый\nконтейнер"
		draw_checkbox 195, cursor, "Почтовый\nперевод", mail_type == 'Перевод'
		draw_checkbox 310, cursor, "Отправление 1 класса"
		move_down 30

		fill_color 'dddddd'
		fill_rectangle [0, cursor], 86, 15
		fill_color '000000'
		draw_text 'Особые отметки', at: [4, cursor-11]
		move_down 20
		draw_checkbox 0, cursor, "Авиа"
		draw_checkbox 82, cursor, "Уведомление\nо вручении"
		move_down 30

		formatted_text [{text: 'Дата подачи: '}, {text: date.strftime('%d.%m.%Y'), styles: [:bold]},
		                {text: "   ОПС подачи: "}, {text: '443123', styles: [:bold]},
		                {text: '   Регистрационный № '}, {text: barcode.to_s,styles: [:bold]}]
		move_down 8

		if mail_type == 'Посылка'
			formatted_text [{text: '   Вес: '}, {text: weight.to_s, styles: [:bold]}, {text: ' гр'},
			                {text: "\n\nФамилия и полный адрес отправителя: "},
			                {text: sender + ', ' + sender_address, styles: [:bold]},
			                {text: "\n\nФамилия и полный адрес адресата: "},
			                {text: receiver + ', ' + receiver_address, styles: [:bold]}],
			               width: 520
		else
			formatted_text [{text: "Фамилия и полный адрес отправителя: "},
			                {text: receiver + ', ' + receiver_address, styles: [:bold]},
			                {text: "\n\nФамилия и полный адрес адресата: "},
			                {text: sender + ', ' + sender_address, styles: [:bold]}],
			               width: 520
		end
		move_down 10

		formatted_text [{text: "Вид упаковки: "}, {text: packaging, styles: [:bold]},
		                    {text: "\nВложение: "}, {text: content, styles: [:bold]}],
		                  width: 520, leading: 1 if mail_type == 'Посылка'
		move_cursor_to 180

		formatted_text [{text: 'Подпись заявителя: ' + '_' * 40 + ' Дата: '},
		                {text: date.strftime('%d.%m.%Y'), styles: [:bold]}],
		               align: :right

		bounding_box([20, cursor], width: 50, height: 50) do
			text 'О.К.Ш.', align: :center, valign: :center, size: 11
			stroke_bounds
		end
		draw_text 'Квитанция (копия) прилагается', at: [200, cursor+20]

		move_down 10
		stroke_color 'dddddd'
		stroke_horizontal_rule
		stroke_color '000000'
		move_down 10

		# Отрывной талон

		text 'ОТРЫВНОЙ ТАЛОН', align: :center, size: 11, style: :bold
		move_down 10
		text 'Заявление № ' + '_' * 15 + ' принято "______" ___________________________ 20______ г.'
		move_down 5
		text 'в ' + '_' * 84
		draw_text '(наименование объекта почтовой связи)', at: [140, cursor-4], size: 6
		move_down 25
		text 'Подпись работника почтовой связи: ' + '_' * 76
		draw_text '(должность, ФИО, роспись)', at: [310, cursor-4], size: 6

		bounding_box([430, 90], width: 50, height: 50) do
			text 'О.К.Ш.', align: :center, valign: :center, size: 11
			stroke_bounds
		end

	end

end