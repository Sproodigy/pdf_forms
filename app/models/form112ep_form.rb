class Form112epForm < Prawn::Document

	def initialize
		super bottom_margin: 20
	end

	def stroke_hand_writing_line(from, to, y, x, legend)
		stroke_horizontal_line from, to, at: y
		draw_text legend, at: [x, y-5], size: 5
	end

	def create_table(columns, x)
		table [[' '] * columns], cell_style: {padding: [-1, 2, 0, 2], width: 10, height: 10, borders: [:bottom, :left, :right]}, position: x
	end

	def print_form112ep(sender:, receiver:, sender_address:, receiver_address:, tel:, value:, payment:,
	                    date:, mailings_code:, weight:, packaging:, put:)

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

		# Изображения

		image 'app/assets/images/cybermoney.png', at: [0, cursor], width: 82
		image 'app/assets/images/russian_post_blue_logo.png', at: [3, cursor-20], width: 79

		# Название формы

		text 'ф. 112ЭП', align: :right

		# Деление формы не сектора

		line_width 2
		stroke do
			rectangle [3, 600], 532, 255
			polygon [3, 340], [535, 340], [535, 50], [450, 50], [450, 0], [3, 0], [3, 340]
			#stroke_polygon [172, cursor-7], [525, cursor-7], [525, cursor-37], [12, cursor-37], [12, cursor-7], [16, cursor-7]
		end
		line_width 1

		# Надписи по краям секторов

		draw_text 'Обведённое жирной линией заполняется отправителем перевода или РПО', at: [0, 352], size: 6, rotate: 90
		draw_text 'Исправления не допускаются', at: [538, 510], size: 6, rotate: 270
		draw_text 'Обведённое жирной линией заполняется отправителем перевода', at: [0, 57], size: 6, rotate: 90
		draw_text 'Исправления не допускаются', at: [538, 235], size: 6, rotate: 270
		draw_text '_' * 17, at: [453, 8]
		draw_text '(подпись оператора)', at: [458, 0], size: 6

		dash [2,2]
		font_size 10
		transparent(0.3) do
			bounding_box [110, cursor-10], width: 269, height: 100 do
				text 'Зона оттиска ККМ', align: :center, valign: :center
				stroke_bounds
			end
			bounding_box [405, cursor+100], width: 100, height: 100 do
				text 'Зона нанесения двумерного матричного кода', align: :center, valign: :center
				stroke_bounds
			end
		end
		undash

		# Сектор контроля

		move_cursor_to 665

		draw_text 'ПРИЁМ', at: [45, cursor]
		draw_text '№______________', at: [3, cursor-10]
		draw_text '(по накладной ф. 16)', at: [15, cursor-18], size: 6
		stroke do
			rectangle [3, cursor-20], 82, 40
			rectangle [6, cursor-23], 13, 13
			horizontal_line 23, 82, at: cursor-36
			horizontal_line 6, 82, at: cursor-52
		end

		draw_text 'Контроль', at: [0, 609], rotate: 90, size: 6
		draw_text '(дата)', at: [43, cursor-42], size: 6
		draw_text '(подпись)', at: [28, cursor-58], size: 6

		# Сектор отправителя РПО

		move_cursor_to 588

		draw_text 'ПОЧТОВЫЙ ПЕРЕВОД', at: [9, cursor], style: :condensed_bold
		draw_text 'на 38993 руб  00 коп', at: [9, cursor-11]

		fill_color 'dddddd'
		fill_rectangle [130, cursor+7], 398, 18
		fill_and_stroke_rectangle [9, cursor-17], 102, 28
		fill_color '000000'

		fill_color 'ffffff'
		fill_and_stroke_rectangle [15, cursor-22], 18, 18
		fill_color '000000'
		text_box "наложенный\nплатёж", at: [38, cursor-21]

		bounding_box([114, cursor-17], width: 119, height: 28) do
			stroke do
				rectangle [2, 26], 10, 10
				rectangle [2, 12], 10, 10
				horizontal_line 0, 119, at: 14
			end
			draw_text 'с доставкой на дом', at: [14, 17]
			draw_text 'с уведомлением', at: [14, 3]
			stroke_bounds
		end
		move_down 5

		formatted_text_box [{text: 'Кому: ', styles: [:bold]}, {text: 'Мингазалиев Абдурахман Гиззатуллович оглы'}],
		                   at: [9, cursor]
		stroke_hand_writing_line(43, 528, cursor-10, 50, '(для юр. лица - полное или краткое наименование, для физ. лица - Фамилия, Имя, а также Отчество (если иное не вытекает из закона или национального обычая) полностью)')
		formatted_text_box [{text: 'Куда: ', styles: [:bold]}, {text: 'Республика Казахстан, Брахманский район, село Брахмачарьевское, ул. Сулеймановская 321, кв. 329'}],
		                   at: [9, cursor-19], leading: 6
		stroke_hand_writing_line(43, 528.5, cursor-29, 250, '(полный адрес получателя)')
		move_down 29
		create_table(6, 468)
		draw_text '(индекс)', at: [487, cursor-5], size: 5
		stroke_hand_writing_line(9, 528.5, cursor-8, 250, '')

		bounding_box([9, cursor-11], width: 90, height: 30) do
			text 'Сообщение или реквизиты л/с', align: :center, valign: :center
			stroke_bounds
		end
		move_up 30
		create_table(42, 108)
		move_down 10
		create_table(42, 108)

		bounding_box([9, cursor-3], width: 520, height: 55) do
			fill_color 'dddddd'
			fill_and_stroke_rectangle [0, cursor], 176, 9
			fill_color '000000'
			draw_text 'заполняется при приёме перевода на расчётный счёт', at:[2, 48.2], size: 6

			formatted_text_box [{text: "ИНН:" + ' ' * 65 + 'Кор/счёт:', styles: [:bold]},
			                    {text: "\nНаименование банка: Поволжский филиал 'Альфа-Банк' в Самаре", styles: [:bold]},
			                    {text: "\nРас/счёт:" + ' ' * 98 + 'БИК:', styles: [:bold]}],
			                   at: [2, cursor-13], leading: 3
			move_down 12
			create_table(12, 35)
			move_up 10
			create_table(20, 316)
			move_down 20
			create_table(20, 59)
			move_up 10
			create_table(9, 426)

			stroke_bounds
		end

		formatted_text_box [{text: 'От кого: ', styles: [:bold]}, {text: 'ООО Экстра'}], at: [9, cursor-3]
		stroke_hand_writing_line(59, 528, cursor-13, 60, '(для юр. лица - полное или краткое наименование, для физ. лица - Фамилия, Имя, а также Отчество (если иное не вытекает из закона или национального обычая) полностью)')
		formatted_text_box [{text: 'Адрес отправителя: ', styles: [:bold]}, {text: 'Россия, Самарская область, г. Самара, ул. Ново-Садовая 106, корпус 109, тел: 8-937-383-32-32'}],
		                   at: [9, cursor-23], leading: 6
		stroke_hand_writing_line(128, 528.5, cursor-33, 205, '(юр. лицо - фактический почтовый адрес, физ. лицо - адрес места нахождения пребывания)')
		move_down 34
		create_table(6, 468)
		stroke_hand_writing_line(9, 528.5, cursor-8, 205, '')
		draw_text '(индекс)', at: [487, cursor-5], size: 5

		# Сектор отправителя перевода

		move_cursor_to 329

		draw_text 'Адрес регистрации отправителя:', at: [9, cursor], style: :condensed_bold
		stroke_horizontal_line 9, 528, at: cursor-3
		move_down 3
		create_table(6, 468)
		text_box '(юр. лицо - адрес местонахождения по месту государственной регистрации, физ. лицо - адрес места жительства/регистрации, заполняется при несовпадении с адресом отправителя, а также до востребования или на а/я)',
		         at: [3, cursor+9], size: 5, width: 460, align: :right
		draw_text '(индекс)', at: [487, cursor-5], size: 5
		stroke_horizontal_line 9, 528, at: cursor-9

		fill_color 'dddddd'
		fill_and_stroke_rectangle [9, cursor-13], 352, 9
		fill_color '000000'

		rectangle [9, cursor-13], 520, 217

		draw_text 'не заполняется при приёме перевода от физического лица с расчётом наличными денежными стредствами',
		          at: [12, cursor-19.3], size: 6

		formatted_text_box [{text: "ИНН:" + ' ' * 64 + 'Кор/счёт:', styles: [:bold]}],
		                   at: [12, cursor-27]
		move_down 26
		create_table(12, 45)
		move_up 10
		create_table(20, 324)

		formatted_text_box [{text: 'Наименование банка: ', styles: [:bold]}], at: [12, cursor-6]

		formatted_text_box [{text: "\nРас/счёт:" + ' ' * 97 + 'БИК:', styles: [:bold]}], at: [12, cursor-10]
		move_down 21
		create_table(20, 69)
		move_up 10
		create_table(9, 434)

		formatted_text_box [{text: 'ОГРН: ', styles: [:bold]}], at: [12, cursor-8]
		move_down 7
		create_table(15, 50)

		draw_text 'Платёжное проучение № ________ дата _________________', at: [233, cursor]
		draw_text '(при безналичной форме оплаты)', at: [400, cursor-7], size: 5

		stroke_horizontal_line 10, 528, at: cursor-10

		fill_color 'dddddd'
		fill_and_stroke_rectangle [9, cursor-10], 233, 9
		fill_color '000000'
		draw_text 'данные отправителя (физ. лица)/представителя отправителя юр. лица', at: [12, cursor-16.5], size: 6


		draw_text 'Предъявлен ' + '_' * 32 + 'Серия ___________ № _________________ выдан ___________________',
		          at: [12, cursor-30], style: :condensed_bold
		draw_text '(наименование документа, удостоверяющего личность)' + ' ' * 150 + '(дата выдачи)',
		          at: [77, cursor-37], size: 5
		stroke_horizontal_line 10, 528, at: cursor-49
		draw_text '(наименование учреждения, выдавшего документ)' + ' ' * 80 + '(код подразделения, если имеется)',
		          at: [85, cursor-54], size: 5

		draw_text 'Гражданство: ________________________ дата рождения ________________ ИНН: ',
		          at: [12, cursor-65], style: :condensed_bold
		move_down 57
		create_table(12, 387)
		stroke do
			move_to 172, cursor-7
			line_to 526, cursor-7
			line_to 526, cursor-37
			line_to 12, cursor-37
			line_to 12, cursor-7
			line_to 18, cursor-7
		end

		draw_text '(Дополнительно для нерезидентов России заполняется)', at: [20, cursor-8], size: 5
		font_size 7
		bounding_box([-12, cursor-12], width: 80) do
			text "Миграционная\nкарта: ", align: :right, style: :condensed_bold
		end
		draw_text 'Серия __________ № ______________', at: [70, cursor+3], style: :condensed_bold
		font_size 9


		move_down 23
		draw_text 'ФИО: ' + '_' * 96, at: [12, cursor]
		move_down 7
		draw_text '(Фамилия, Имя, а также отчество (если иное не вытекает из закона или национального обычая) полностью представителя юридичесого лица)', at: [90, cursor], size: 5
		move_down 10
		draw_text 'Адрес регистрации: ' + '_' * 80, at: [12, cursor]
		move_down 7
		draw_text '(адрес места жительства/регистрации представителя юридического лица)', at: [220, cursor], size: 5


		stroke do
			horizontal_line 7, 530, at: 54
			rectangle [351, 50], 94, 46
			rectangle [451, 88], 11, 11
			rectangle [497, 88], 11, 11
		end

		draw_text 'Подпись:', at: [394, 57], style: :condensed_bold
		draw_text 'Да          ' + 'Нет', at: [464, 77]

		text_box 'Являетесь ли Вы должностным лицом публичных международных организаций или лицом, замещающим (занимающим) гос. должности РФ, должности членов Совета директоров Центрального банка РФ, должности федеральной гос. службы, назначение на которые и освобождение от которых осуществляется Президентом РФ или Правительством РФ, должности в Центральном банке РФ, гос. компаниях и иных организациях, созданных РФ на основании Федеральных законов, включенных в перечни должностей, определяемые Президентом РФ? (на основании федерального закона №231-ФЗ от 18 декабря 2006 г.)',
		         at: [9, 85], width: 380, size: 5

		text_box "В целях осуществления данного почтового перевода подтверждаю свое согласие:\n- на обработку как автоматизированным, так и неавтоматизированным способом указанных на бланке персональных данных; (Закон №152-ФЗ от 14 июля 2006 г.)\n- на передачу информации о номере почтового перевода, о событии (о поступлении почтового перевода в ОПС выплаты, о перечислении почтового перевода на счет получателя, о дате и месте совершения события).\nТакже подтверждаю своё соглвсие на передачу номера почтового перевода и событий третьему лицу в целях передачи SMS-сообщений по сетям связи.", at: [9, 49], width: 230, size: 5

		text_box "Подпись\nотправителя:", at: [277, 23], style: :condensed_bold


	end

end