class SearchForm < Prawn::Document

	def initialize
		super left_margin: 45, top_margin: 25, right_margin: 45
	end

	def draw_checkbox(x, y, label)
		stroke_rectangle [x, y], 18, 18
		text_box label, at: [x+21, y], valign: :center, height: 20
	end

	def print_search(sender:, receiver:, sender_address:, receiver_address:, tel:, value:, payment:, date:, mailings_code:, weight:, packaging:, put:)

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

		formatted_text_box [{text: "\nКому:  "}, {text: 'Начальнику Омельченко В. М.', styles: [:bold]},
		                    {text: "\nОт: "}, {text: 'Версилова Станислава Игоревича', styles: [:bold]},
		                    {text: "\nПроживающего: "}, {text: 'ул. Ново-Садовая 106, корп. 109, г. Самара,
											Самарская область, Россия',
		                                                 styles: [:bold]},
		                    {text: "\nТел: "}, {text: tel.to_s, styles: [:bold]},
		                    {text: "\nДокумент, удостоверяющий личность:  "}, {text: 'паспорт', styles: [:bold]},
		                    {text: "\nСерия: "}, {text: '39 03' + ' ' * 20, styles: [:bold]}, {text: '№'},
		                    {text: ' 903237', styles: [:bold]},
		                    {text: "\nВыдан: "}, {text: 'Октябрьским РОВД г. Самары', styles: [:bold]}],
		                   at: [225, 750], width: 330
		move_cursor_to 630

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
		draw_checkbox 0, cursor, "Отправление (перевод)\nне поступило"
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
		draw_checkbox 82, cursor, "Регистрируемое"

		bounding_box([190, cursor+6], width: 340, height: 28) do

			formatted_text_box [{text: draw_checkbox(5, cursor-5, "С объявленной\nценностью: ")},
			                    {text: value.to_s, styles: [:bold]},
			                    {text: ' руб  '}, {text: "38 ", styles: [:bold]},
			                    {text: 'коп'}],
			                   at: [85, cursor-16]

			formatted_text_box [{text: draw_checkbox(182, cursor-5, "Наложенный\nплатёж: ")},
			                    {text: payment.to_s, styles: [:bold]},
			                    {text: ' руб  '}, {text: "38 ", styles: [:bold]}, {text: 'коп'}],
			                   at: [245, cursor-16]
			stroke_bounds
		end
		move_down 6

		draw_checkbox 0, cursor, "Почтовая\nкарточка"
		draw_checkbox 82, cursor, "Письмо"
		draw_checkbox 195, cursor, "Бандероль"
		draw_checkbox 310, cursor, "Посылка"
		move_down 30
		draw_checkbox 0 , cursor, "Секограмма"
		draw_checkbox 82, cursor, "Прямой почтовый\nконтейнер"
		draw_checkbox 195, cursor, "Почтовый\nперевод"
		draw_checkbox 310, cursor, "Отправление 1 класса"
		move_down 30

		fill_color 'dddddd'
		fill_rectangle [0, cursor], 86, 15
		fill_color '000000'
		draw_text 'Особые отметки', at: [4, cursor-11]
		move_down 20
		draw_checkbox 0, cursor, "Авиа"
		draw_checkbox 82, cursor, "Уведомление\nо вручении"

		formatted_text_box [{text: 'Дата подачи: '}, {text: date.to_s, styles: [:bold]},
		                    {text: '   Регистрационный № '}, {text: mailings_code.to_s,
		                                                         styles: [:bold]},
		                    {text: '   Вес: '}, {text: weight.to_s, styles: [:bold]}, {text: ' гр'},
		                    {text: "   ОПС подачи: "}, {text: '443123', styles: [:bold]},
		                    {text: "\n\nФамилия и полный адрес отправителя: "}, {text: 'Версилов Станислав Игоревич, г. Самара, Самарская область, Россия, ул. Молодогвардейская 382, корп. 38, кв. 123', styles: [:bold]},
		                    {text: "\n\nФамилия и полный адрес адресата: "}, {text: 'Абдурахманов Герхан Закиреевич, г. Истанбул, Истанбульский р-он, Республика Казахстан, ул. Ходжы Насреддина 231, корп. 48, кв. 133', styles: [:bold]},
		                    {text: "\n\nВид упаковки: "}, {text: packaging,
		                                                   styles: [:bold]},
		                    {text: "\nВложение: "}, {text: put,
		                                             styles: [:bold]}],
		                   at: [0, cursor-35], width: 520, leading: 1
		move_cursor_to 180

		text 'Подпись заявителя: ' + '_' * 40 + ' Дата: ' + '_' * 30, align: :right

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
		text 'Заявление № ' + '_' * 25 + ' принято "______" ____________________ 20______ г.'
		move_down 5
		text 'в ' + '_' * 88
		draw_text '(наименование объекта почтовой связи)', at: [150, cursor-4], size: 6
		move_down 15
		text 'Подпись работника почтовой связи: ' + '_' * 76
		draw_text '(должность, ФИО, роспись)', at: [310, cursor-4], size: 6

		bounding_box([450, 90], width: 50, height: 50) do
			text 'О.К.Ш.', align: :center, valign: :center, size: 11
			stroke_bounds
		end

	end

end