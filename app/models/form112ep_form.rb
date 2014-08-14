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
			rectangle [3, 580], 529, 247

			move_to  3, 329
			line_to 532, 329
			line_to 532, 50
			line_to 450, 50
			line_to 450, 0
			line_to 3, 0
			line_to 3, 330
		end

		line_width 1

		# Надписи за пределами секторов

		draw_text 'Обведённое жирной линией заполняется отправителем перевода или РПО', at: [0, 337], size: 6, rotate: 90
		draw_text 'Исправления не допускаются', at: [535, 495], size: 6, rotate: 270
		draw_text 'Обведённое жирной линией заполняется отправителем перевода', at: [0, 57], size: 6, rotate: 90
		draw_text 'Исправления не допускаются', at: [535, 235], size: 6, rotate: 270
		draw_text '_' * 17, at: [453, 8]
		draw_text '(подпись оператора)', at: [458, 0], size: 6

		dash [2,2]
		font_size 10
		transparent(0.3) do
			bounding_box [115, 700], width: 269, height: 98 do
				text 'Зона оттиска ККМ', align: :center, valign: :center
				stroke_bounds
			end
			bounding_box [405, 700], width: 108, height: 98 do
				text 'Зона нанесения двумерного матричного кода', align: :center, valign: :center
				stroke_bounds
			end
		end
		undash

		draw_text 'ПРИЁМ', at: [45, 650]
		draw_text '№______________', at: [7, 640]
		draw_text '(по накладной ф. 16)', at: [21, 632], size: 6
		stroke_rectangle [9, 630], 82, 45
		stroke_rectangle [11, 628], 15, 15
		stroke_horizontal_line 28, 79, at: 613
		stroke_horizontal_line 11, 79, at: 600
		draw_text 'Контроль', at: [0, 591], rotate: 90, size: 6
		draw_text '(дата)', at: [21, 594], size: 6
		draw_text '(подпись)', at: [17, 588], size: 6

		# Зона почтового перевода
		move_down 40
		formatted_text_box [{text: 'Кому: ', styles: [:bold]}, {text: 'Мингазалиев Абдурахман Гиззатуллович оглы'}],
		                   at: [9, cursor]
		stroke_hand_writing_line(43, 528, cursor-10, 50, '(для юр. лица - полное или краткое наименование, для физ. лица - Фамилия, Имя, а также Отчество (если иное не вытекает из закона или национального обычая) полностью)')
		formatted_text_box [{text: 'Куда: ', styles: [:bold]}, {text: 'Республика Казахстан, Брахманский район, село Брахмачарьевское, ул. Сулеймановская 321, кв. 329'}],
		                   at: [9, cursor-20], leading: 6
		stroke_hand_writing_line(43, 528.5, cursor-31, 250, '(полный адрес получателя)')
		move_down 31
		create_table(6, 468)
		draw_text '(индекс)', at: [487, cursor-5], size: 5
		stroke_hand_writing_line(9, 528.5, cursor-8, 250, '')

		bounding_box([9, cursor-12], width: 90, height: 30) do
			text 'Сообщение или реквизиты л/с', align: :center, valign: :center
			stroke_bounds
		end
		move_up 30
		create_table(42, 105)
		move_down 10
		create_table(42, 105)

		bounding_box([9, cursor-4], width: 518) do
			bounding_box([0, 0], width: 176, height: 10) do
					text 'заполняется при приёме перевода на расчётный счёт',align: :center, valign: :center, size: 6
				stroke_bounds
			end
			formatted_text_box [{text: "ИНН:" + ' ' * 60 + 'Кор/счёт:', styles: [:bold]},
			                    {text: "\nНаименование банка: Поволжский филиал 'Альфа-Банк' в Самаре", styles: [:bold]},
			                    {text: "\nРас/счёт:" + ' ' * 95 + 'БИК:', styles: [:bold]}],
			                   at: [2, cursor-4], leading: 3
			move_up cursor-3
			create_table(12, 35)
			move_up cursor+10
			create_table(20, 316)
			move_up cursor-20
			create_table(20, 59)
			move_up cursor+10
			create_table(9, 426)

			stroke_bounds
		end

		formatted_text_box [{text: 'От кого: ', styles: [:bold]}, {text: 'ООО Экстра'}], at: [9, cursor-5]
		stroke_hand_writing_line(59, 528, 407, 60, '(для юр. лица - полное или краткое наименование, для физ. лица - Фамилия, Имя, а также Отчество (если иное не вытекает из закона или национального обычая) полностью)')
		formatted_text_box [{text: 'Адрес отправителя: ', styles: [:bold]}, {text: 'Россия, Самарская область, г. Самара, ул. Ново-Садовая 106, корпус 109, тел: 8-937-383-32-32, fjkla;f ,jfkdjsie, jl;gdjgl;j'}],
		                   at: [9, cursor-23], leading: 6
		stroke_hand_writing_line(128, 528, cursor-34, 205, '(юр. лицо - фактический почтовый адрес, физ. лицо - адрес места нахождения пребывания)')
		#create_table(6, 468)

		draw_text '(индекс)', at: [487, cursor-5], size: 5






		move_cursor_to 318
		draw_text 'Адрес регистрации отправителя:', at: [9, cursor]
		stroke_horizontal_line 9, 528, at: cursor-3
		move_down 3
		create_table(6, 468)
		text_box '(юр. лицо - адрес местонахождения по месту государственной регистрации, физ. лицо - адрес места жительства/регистрации, заполняется при несовпадении с адресом отправителя, а также до востребования или на а/я)',
		         at: [0, cursor+9], size: 5, width: 460, align: :right
		draw_text '(индекс)', at: [487, cursor-5], size: 5
		stroke_horizontal_line 9, 528, at: cursor-3

		rectangle [9, 287], 518, 198

		draw_text 'не заполняется при приёме перевода от физического лица с расчётом наличными денежными стредствами',
		          at: [12, 283], size: 6
		stroke_horizontal_line 9, 361, at: 280
		stroke_vertical_line 280, 290, at: 361

		formatted_text_box [{text: "ИНН:" + ' ' * 64 + 'Кор/счёт:', styles: [:bold]}],
		                   at: [12, 274]
		move_down 30
		create_table(12, 45)
		move_up 10
		create_table(20, 324)
		move_down 10

		formatted_text_box [{text: 'Наименование банка: ', styles: [:bold]}], at: [12, cursor]
		move_down 7

		formatted_text_box [{text: "\nРас/счёт:" + ' ' * 97 + 'БИК:', styles: [:bold]}], at: [12, cursor]
		move_down 11
		create_table(20, 69)
		move_up 10
		create_table(9, 434)
		move_down 11

		formatted_text_box [{text: 'ОГРН: ', styles: [:bold]}], at: [12, cursor]
		move_up 1
		create_table(15, 50)
		draw_text 'Платёжное проучение № ______ дата ______________', at: [257, cursor]
		move_down 7
		draw_text '(при безналичной форме оплаты)', at: [420, cursor], size: 5
		move_down 2
		stroke_horizontal_line 10, 528, at: cursor
		move_down 7
		draw_text 'данные отправителя (физ. лица)/представителя отправителя юр. лица', at: [12, cursor], size: 6
		stroke_horizontal_line 9, 234, at: 188
		stroke_vertical_line 188, 198, at: 234
		move_down 13
		draw_text 'Предъявлен ' + '_' * 30 + 'Серия ________ № ____________ выдан ______________', at: [12, cursor]
		move_down 7
		draw_text '(наименование документа, удостоверяющего личность)' + ' ' * 132 + '(дата выдачи)',
		          at: [80, cursor], size: 5
		move_down 12
		stroke_horizontal_line 10, 528, at: cursor
		move_down 5
		draw_text '(наименование учреждения, выдавшего документ)' + ' ' * 80 + '(код подразделения, если имеется)',
		          at: [85, cursor], size: 5
		move_down 10
		draw_text 'Гражданство: __________________ дата рождения ____________ ИНН: ',
		          at: [12, cursor]
		move_up 10
		create_table(12, 360)
		#stroke_rectangle [14, 197], 510, 67
		move_down 20
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