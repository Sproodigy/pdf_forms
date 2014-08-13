class Form112epForm < Prawn::Document

	def initialize
		super bottom_margin: 20
	end

	def create_table(columns, x)
		table [[' '] * columns], cell_style: {width: 10, height: 10, borders: [:bottom, :left, :right]}, position: x
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
			rectangle [9, 290], 520, 198

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
		draw_text 'Исправления не допускаются', at: [535, 215], size: 6, rotate: 270
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






		# bounding_box([4, cursor-300], width: 533) do
		# 		formatted_text_box [{text: "ИНН:" + ' ' * 68 + 'Кор/счёт:', styles: [:bold]},
		# 		                    {text: "\nНаименование банка: Поволжский филиал 'Альфа-Банк' в Самаре", styles: [:bold]},
		# 		                    {text: "\nРас/счёт:" + ' ' * 101 + 'БИК:', styles: [:bold]}],
		# 		                   at: [2, cursor-4], leading: 3
		# 		move_up cursor-3
		# 		create_table(12, 35)
		# 		move_up cursor+10
		# 		create_table(20, 328)
		# 		move_up cursor-20
		# 		create_table(20, 59)
		# 		move_up cursor+10
		# 		create_table(9, 438)
		#
		#
		#
		# 		stroke_bounds
		# 	end

		draw_text 'Адрес регистрации отправителя:', at: [9, 318]
		stroke_horizontal_line 9, 528, at: 315
		move_cursor_to 315
		create_table(6, 468)
		text_box '(юр.лицо - адрес местонахождения по месту государственной регистрации, физ.лицо - адрес места жительства/регистрации, заполняется при несовпадении с адресом отправителя, а также до востребования или на а/я)',
		         at: [0, 313], size: 5, width: 460, align: :right
		draw_text '(индекс)', at: [487, 300], size: 5
		stroke_horizontal_line 9, 528, at: 295

		draw_text 'не заполняется при приёме перевода от физического лица с расчётом наличными денежными стредствами',
		          at: [12, 283], size: 6
		stroke_horizontal_line 9, 361, at: 280
		stroke_vertical_line 280, 290, at: 361

		formatted_text_box [{text: "ИНН:" + ' ' * 68 + 'Кор/счёт:', styles: [:bold]}],
		                   at: [12, 276]

		

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