class Form112epForm < Prawn::Document

	def initialize
		super bottom_margin: 20
	end

	def stroke_hand_writing_line(from, to, y, x, legend)
		stroke_horizontal_line from, to, at: y
		draw_text legend, at: [x, y-5], size: 5
	end

	def draw_chekbox(x, y, width, height, legend, sms_ctg_1 = false, sms_ctg_2 = false)
		stroke_rectangle [x, y], width, height

		line_width 2
		stroke do
			move_to x+1, y-5
			line_to x+5, y-8
			line_to x+9, y
		end if sms_ctg_1 or sms_ctg_2
		line_width 1

		draw_text legend, at: [x+12, y-8.8]
	end

	def create_table(columns, x)
		data = [[' '] * columns]
		table(data, cell_style: {padding: [-1, 2, 0, 2], width: 10, height: 10, borders: [:bottom, :left, :right]}, position: x)
	end

	def print_form112ep(sender:, sender_address:, sender_tel:, sender_index:, bank:, inn:, account:, corr_account:, bik:, receiver_index:, receiver:, receiver_address:, receiver_tel:, payment:, mail_payment:, date:, mail_ctg:, sms_ctg_1:, sms_ctg_2:)

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

		payment_propisyu = (RuPropisju.propisju_int(payment.floor) + ' руб. ' +
				((payment-payment.floor)*100).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize

		mail_payment_propisyu = (RuPropisju.propisju_int(mail_payment.floor) + ' руб. ' +
				((mail_payment-mail_payment.floor)*100).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize

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
		if mail_ctg == 'payment'
			draw_text "на #{payment} руб  00 коп", at: [9, cursor-11]
		else
			draw_text "на #{mail_payment} руб  00 коп", at: [9, cursor-11]
		end

		fill_color 'dddddd'
		fill_and_stroke_rectangle [9, cursor-19], 102, 28
		fill_color '000000'

		bounding_box([130, cursor+6.5], width: 398, height: 18) do
			fill_color 'dddddd'
			fill_rectangle [0, cursor], 398, 18
			fill_color '000000'
			if mail_ctg == 'payment'
				text payment_propisyu, align: :center, valign: :center, style: :condensed_bold
			else
				text mail_payment_propisyu, align: :center, valign: :center, style: :condensed_bold
			end
		end
		draw_text '(рубли прописью, копейки цифрами)', at: [275, cursor-6], size: 6

		fill_color 'ffffff'
		fill_and_stroke_rectangle [15, cursor-13], 18, 18
		fill_color '000000'
		text_box "наложенный\nплатёж", at: [38, cursor-12]

		line_width 2
		stroke do
			move_to 16, cursor-21
			line_to 24, cursor-29
			line_to 32, cursor-13
		end if mail_ctg == 'payment'
		line_width 1

		bounding_box([114, cursor-8], width: 119, height: 28) do
			stroke_horizontal_line 0, 119, at: 14
			draw_chekbox(2, 26, 10, 10,'с доставкой на дом', sms_ctg_1 == 'delivery at door', sms_ctg_2 == '')
			draw_chekbox(2, 12, 10, 10,'с уведомлением', sms_ctg_2 == 'at notice', sms_ctg_1 == '')
			stroke_bounds
		end
		move_down 4

		if mail_ctg == 'payment'
			formatted_text_box [{text: 'Кому: ', styles: [:bold]}, {text: receiver}],
		                   at: [9, cursor]
			formatted_text_box [{text: 'Куда: ', styles: [:bold]}, {text: receiver_address + ', ' + receiver_tel.to_s}],
			                   at: [9, cursor-19], leading: 6
		else
			formatted_text_box [{text: 'Кому: ', styles: [:bold]}, {text: sender}],
			                   at: [9, cursor]
			formatted_text_box [{text: 'Куда: ', styles: [:bold]}, {text: sender_address + ', ' + sender_tel.to_s}],
			                   at: [9, cursor-19], leading: 6
		end
		stroke_hand_writing_line(43, 528, cursor-10, 50, '(для юр. лица - полное или краткое наименование, для физ. лица - Фамилия, Имя, а также Отчество (если иное не вытекает из закона или национального обычая) полностью)')

		stroke_hand_writing_line(43, 528.5, cursor-29, 250, '(полный адрес получателя)')
		move_down 29
		create_table(6, 468)
		if mail_ctg == 'payment'
			formatted_text_box [{text: receiver_index.to_s, character_spacing: 4.45}],
			                   at: [470, cursor+8], style: :bold, size: 8
		else
			formatted_text_box [{text: sender_index.to_s, character_spacing: 4.45}],
			                   at: [470, cursor+8], style: :bold, size: 8

		end

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
			                    {text: "\nНаименование банка: ", styles: [:bold]}, {text: bank},
			                    {text: "\nРас/счёт:" + ' ' * 98 + 'БИК:', styles: [:bold]}],
			                   at: [2, cursor-13], leading: 3
			move_down 12
			create_table(12, 35)
			formatted_text_box [{text: inn.to_s, character_spacing: 4.45}],
			                   at: [37, cursor+8], style: :bold, size: 8
			move_up 10
			create_table(20, 316)
			formatted_text_box [{text: corr_account.to_s, character_spacing: 4.45}],
			                   at: [318, cursor+8], style: :bold, size: 8
			move_down 20
			create_table(20, 59)
			formatted_text_box [{text: account.to_s, character_spacing: 4.45}],
			                   at: [61, cursor+8], style: :bold, size: 8
			move_up 10
			create_table(9, 426)
			formatted_text_box [{text: bik.to_s, character_spacing: 4.45}],
			                   at: [428, cursor+8], style: :bold, size: 8

			stroke_bounds
		end

		if mail_ctg == 'payment'
			formatted_text_box [{text: 'От кого: ', styles: [:bold]}, {text: sender}], at: [9, cursor-3]
			formatted_text_box [{text: 'Адрес отправителя: ', styles: [:bold]}, {text: sender_address + ', ' + sender_tel.to_s}],
			                   at: [9, cursor-23], leading: 6
		else
			formatted_text_box [{text: 'От кого: ', styles: [:bold]}, {text: receiver}], at: [9, cursor-3]
			formatted_text_box [{text: 'Адрес отправителя: ', styles: [:bold]}, {text: receiver_address + ', ' + receiver_tel.to_s}],
			                   at: [9, cursor-23], leading: 6
		end
		stroke_hand_writing_line(59, 528, cursor-13, 60, '(для юр. лица - полное или краткое наименование, для физ. лица - Фамилия, Имя, а также Отчество (если иное не вытекает из закона или национального обычая) полностью)')

		stroke_hand_writing_line(128, 528.5, cursor-33, 205, '(юр. лицо - фактический почтовый адрес, физ. лицо - адрес места нахождения пребывания)')
		move_down 33
		create_table(6, 468)
		if mail_ctg == 'payment'
			formatted_text_box [{text: sender_index.to_s, character_spacing: 4.45}],
			                   at: [470, cursor+8], style: :bold, size: 8
		else
			formatted_text_box [{text: receiver_index.to_s, character_spacing: 4.45}],
			                   at: [470, cursor+8], style: :bold, size: 8
		end

		stroke_hand_writing_line(9, 528.5, cursor-8, 205, '')
		draw_text '(индекс)', at: [487, cursor-5], size: 5

		# Сектор отправителя перевода

		move_cursor_to 327

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

		rectangle [9, cursor-13], 520, 212

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

		draw_text 'Гражданство: _________________________ дата рождения ___________________ ИНН: ',
		          at: [12, cursor-65], style: :condensed_bold
		draw_text '(при его наличии)', at: [365, cursor-72], size: 5
		move_down 57
		create_table(12, 405)
		stroke do
			move_to 172, cursor-7
			line_to 526, cursor-7
			line_to 526, cursor-31
			line_to 12, cursor-31
			line_to 12, cursor-7
			line_to 18, cursor-7
		end

		draw_text '(Дополнительно для нерезидентов России заполняется)', at: [20, cursor-8], size: 5
		font_size 7
		bounding_box([-12, cursor-12], width: 80) do
			text "Миграционная\nкарта: ", align: :right, style: :condensed_bold
		end
		draw_text 'Серия ____________ № ____________________', at: [70, cursor+3], style: :condensed_bold

		bounding_box([210, cursor+17], width: 140) do
			text "Дата\nвыдачи: ______________________", style: :condensed_bold
		end

		bounding_box([318, cursor+17], width: 230) do
			text "Срок\nпребывания с ______________________ по ______________________", style: :condensed_bold
		end
		font_size 9
		move_down 10

		formatted_text_box [{text: 'ФИО: ', styles: [:bold]}, {text: '_' * 107}], at: [12, cursor]
		draw_text '(Фамилия, Имя, а также отчество (если иное не вытекает из закона или национального обычая) полностью представителя юридичесого лица)', at: [90, cursor-13], size: 5
		formatted_text_box [{text: 'Адрес регистрации: ', styles: [:bold]}, {text: '_' * 90}], at: [12, cursor-19]
		draw_text '(адрес места жительства/регистрации представителя юридического лица)', at: [220, cursor-33], size: 5

		stroke do
			horizontal_line 7, 530, at: 54
			rectangle [351, 50], 94, 46
		end

		draw_chekbox(451, 85, 10, 10, 'Да')
		draw_chekbox(498, 85, 10, 10, 'Нет')
		draw_text 'Подпись:', at: [394, 57], style: :condensed_bold


		text_box 'Являетесь ли Вы должностным лицом публичных международных организаций или лицом, замещающим (занимающим) гос. должности РФ, должности членов Совета директоров Центрального банка РФ, должности федеральной гос. службы, назначение на которые и освобождение от которых осуществляется Президентом РФ или Правительством РФ, должности в Центральном банке РФ, гос. компаниях и иных организациях, созданных РФ на основании Федеральных законов, включенных в перечни должностей, определяемые Президентом РФ? (на основании федерального закона №231-ФЗ от 18 декабря 2006 г.)',
		         at: [9, 85], width: 380, size: 5

		text_box "В целях осуществления данного почтового перевода подтверждаю свое согласие:\n- на обработку как автоматизированным, так и неавтоматизированным способом указанных на бланке персональных данных; (Закон №152-ФЗ от 14 июля 2006 г.)\n- на передачу информации о номере почтового перевода, о событии (о поступлении почтового перевода в ОПС выплаты, о перечислении почтового перевода на счет получателя, о дате и месте совершения события).\nТакже подтверждаю своё соглвсие на передачу номера почтового перевода и событий третьему лицу в целях передачи SMS-сообщений по сетям связи.", at: [9, 51], width: 230, size: 5

		text_box "Подпись\nотправителя:", at: [277, 23], style: :condensed_bold


	end

end