class Form113enForm < Prawn::Document
	def to_pdf
		font_families.update(
				'DejaVuSans' => {
						normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
						bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
						italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
						bold_italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf",
						extra_light: "#{Rails.root}/app/assets/fonts/DejaVuSans-ExtraLight.ttf",
						condensed: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed.ttf",
						condensed_bold: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed-Bold.ttf"
				})
		font 'DejaVuSans', size: 7

		# Деление формы на сектора

		self.line_width = 2
		stroke do
			rectangle [175, 630], 365, 184
			rectangle [175, 370], 365, 184
			horizontal_line 175, 540, at: 538
			horizontal_line 180, 535, at: 245
		end

		self.line_width =1
		stroke do
			rectangle [0, 750], 550, 570
			rectangle [180, 525], 355, 74
			rectangle [180, 290], 355, 88
			vertical_line 180, 750, at: 159
			horizontal_line 267, 550, at: 637
			vertical_line 637, 750, at: 267
		end

		# Сектор с логотипом

		image 'app/assets/images/logo_russian_post.png', at: [160, 745], width: 70

		stroke do
			horizontal_line 170, 260, at: 662
			horizontal_line 170, 260, at: 642
		end

		text_box "П\nР\nИ\nЕ\nМ", at: [225, 743], width: 15, size: 11

		draw_text '№', at: [175, 664]
		draw_text '№', at: [175, 644]
		draw_text '(по накладной ф.16)', at: [175, 654], style: :italic
		draw_text '(по реестру ф.10)', at: [181, 634], style: :italic

		# Сектор суммы наложенного платежа

		fill_color 'eeeeee'
		fill_rectangle [180, 615], 355, 20
		fill_color '000000'

		draw_text 'ПОЧТОВЫЙ ПЕРЕВОД наложенного платежа', at: [180, 620], style: :bold
		draw_text '99999' + '     руб.        ' + '00' + '       коп.', at: [415, 620], style: :bold
		draw_text '_____________       ' + '   ___________', at: [405, 619], style: :bold
		draw_text 'Девяносто девять тысяч девятьсот девяносто девять руб.00 коп.',
							at: [185, 608], style: :bold

		draw_text '(рубли прописью, копейки цифрами)', at: [290, 588], style: :italic
		formatted_text_box [{text: 'Кому:    ', styles: [:bold]}, {text: 'ООО "Экстра"'}], at:[180, 585]
		draw_text '(для юридического лица - полное или краткое наименование, для гражданина - фамилия, имя, отчество полностью)',
							at: [202, 560], size: 5, style: :italic
		formatted_text_box [{text: 'Куда:    ', styles: [:bold]}, {text: 'г. Самара, а/я 4001'}], at:[180, 556]

		stroke do
			horizontal_line 175, 540, at: 576
			horizontal_line 175, 540, at: 566
			horizontal_line 175, 540, at: 548
			horizontal_line 180, 535, at: 502
		end

		draw_text '(адрес, почтовый индекс)', at: [315, 530], style: :italic

		font 'DejaVuSans', style: :bold, size: 6

		draw_text 'Заполняется при приёме перевода в адрес юридического лица', at: [240, 518]
		draw_text 'Выплатить наличными деньгами' + ' ' * 61 + 'Индекс:', at: [197, 508]
		draw_text 'ИНН:' + ' ' * 61 + 'Кор/счёт:', at: [185, 495]
		draw_text 'Наименование банка: ' + '_' * 90, at: [185, 474]
		draw_text 'Рас/счёт:' + ' ' * 107 + 'БИК:', at: [185, 466]

		font 'DejaVuSans', size: 7

		formatted_text_box [{text: '443110', character_spacing: 5.1}],
											 at: [473, 513], style: :bold
		formatted_text_box [{text: '631614265880', character_spacing: 5.1}],
											 at: [187, 490], style: :bold

		move_down 205
		table [[' ']], cell_style: {width: 10, height: 10}, position: 185
		move_up 10
		table [[' '] * 6], cell_style: {width: 10, height: 10}, position: 470
		move_down 13
		table [[' '] * 12], cell_style: {width: 10, height: 10}, position: 184
		move_up 10
		table [[' '] * 20], cell_style: {width: 10, height: 10}, position: 330
		move_down 19
		table [[' '] * 20], cell_style: {width: 10, height: 10}, position: 185
		move_up 10
		table [[' '] * 9], cell_style: {width: 10, height: 10}, position: 440

		# Секция с ШПИ

		formatted_text_box [{text: 'Наложенный платёж'}],
											 at: [200, 440], width: 65, height: 45, size: 9
		draw_text 'за РПО', at: [190, 405], style: :bold, size: 11
		draw_text '_' * 30, at: [434, 415]
		draw_text '_' * 30, at: [434, 400]
		draw_text '(шифр и подпись)', at: [454, 390], style: :italic

		# Секция отправителя перевод

		draw_text 'Обведённое линией заполняется отправителем перевода',
							at: [235, 375], style: :bold
		draw_text 'От кого:' + ' ' * 51 + 'ИНН, при его наличии:', at: [180, 359], style: :bold
		draw_text 'Иванов Иван Иванович', at: [180, 349]
		draw_text '_' * 104, at: [174, 348]
		draw_text '_' * 104, at: [174, 338]
		draw_text 'Адрес отправителя:' + ' ' * 73 + 'Индекс:', at: [180, 327], style: :bold
		formatted_text_box [{text: '443110', character_spacing: 5.1}],
											 at: [478, 332], style: :bold
		text_box 'ул. Лейтенанта Шмидта, д. 3, корп.39, кв. 15 МОСКВА, МОСКОВСКАЯ ОБЛАСТЬ, РОССИЯ',
							at: [180, 320], height: 20, leading: 2
		draw_text '_' * 104, at: [174, 314]
		draw_text '_' * 104, at: [174, 304]
		draw_text 'адрес места жительства (регистрации), адрес пребывания (ненужное зачеркнуть)',
							at: [225, 296], style: :italic, size: 6
		text_box '<b>Предъявлен:</b> ' + '_' * 21 + ' Серия _______ № _____________ выдан ______.______ 20______г.',
							at: [183, 282], inline_format: true
		draw_text '(наименование документа)', at: [231, 270], size: 6, style: :italic
		draw_text '_' * 101, at: [180, 258]
		draw_text '(наименование учреждения)', at: [296, 250], style: :italic
		text_box "<u>Для нерезидентов России</u>", at: [183, 242], style: :bold, inline_format: true
		text_box '<b>Предъявлен:</b> ' + '_' * 21 + ' Серия _______ № _____________ выдан ______.______ 20______г.',
							at: [183, 228], inline_format: true
		text_box '<b>Дата срока пребывания с:</b> ______.______ 20______ г.,     по ______.______ 20______ г.',
							at: [182, 213], inline_format: true
		draw_text 'Гражданство:' + ' ' * 50 + 'Подпись отправителя:', style: :bold, at: [182, 191], style: :bold


		move_down 87
		table [[''] * 10], cell_style: {width: 10, height: 10}, position: 435
		move_down 22
		table [[''] * 6], cell_style: {width: 10, height: 10}, position: 475

		# Надписи по краям

		draw_text 'ф. 113эн', at: [515, 740]
		draw_text 'Линия отреза', at: [157, 510], rotate: 90
		draw_text 'Обведённое линией заполняется отправителем РПО',
							at: [168, 446], rotate: 90, size: 6, style: :bold
		draw_text 'исправления не допускаются', at: [548, 480], rotate: 90

		render

	end

end