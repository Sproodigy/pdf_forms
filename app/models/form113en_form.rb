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
			rectangle [175, 360], 365, 174
			horizontal_line 175, 540, at: 538
		end

		self.line_width =1
		stroke do
			rectangle [0, 750], 550, 570
			rectangle [180, 525], 355, 74
			rectangle [180, 272], 355, 71
			vertical_line 180, 750, at: 156
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
		draw_text '(по накладной ф.16)', at: [175, 654]
		draw_text '(по реестру ф.10)', at: [181, 634]

		# Сектор суммы наложенного платежа

		draw_text 'ПОЧТОВЫЙ ПЕРЕВОД наложенного платежа', at: [180, 620], style: :bold
		draw_text '99999' + '     руб.        ' + '00' + '       коп.', at: [415, 620], style: :bold
		draw_text '_____________       ' + '   ___________', at: [405, 619], style: :bold
		draw_text 'Девяносто девять тысяч девятьсот девяносто девять руб.00 коп.', at: [185, 609], style: :bold

		10.times do |a|
			stroke_color 50, 50, 50, 0
			base_z = 615
			dash(lenght: 1, space: 1, phase: 1)
			stroke_horizontal_line 180, 535, at: base_z - (2 * a)
		end
		stroke_color 50, 50, 50, 100

		draw_text '(рубли прописью, копейки цифрами)', at: [290, 588]
		formatted_text_box [{text: 'Кому:    ', styles: [:bold]}, {text: 'ООО "Экстра"'}], at:[180, 585]
		draw_text '(для юридического лица - полное или краткое наименование, для гражданина - фамилия, имя, отчество полностью)',
							at: [202, 560], size: 5
		formatted_text_box [{text: 'Куда:    ', styles: [:bold]}, {text: 'г. Самара, а/я 4001'}], at:[180, 556]

		undash
		stroke do
			horizontal_line 175, 540, at: 576
			horizontal_line 175, 540, at: 566
			horizontal_line 175, 540, at: 548
			horizontal_line 180, 535, at: 502
		end

		draw_text '(адрес, почтовый индекс)', at: [315, 530]

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
		draw_text '_' * 30, at: [430, 405]
		draw_text '_' * 30, at: [430, 390]
		draw_text '(шифр и подпись)', at: [450, 380]

		# Секция отправителя перевода

		draw_text 'Обведённое линией заполняется отправителем перевода',
							at: [235, 365], style: :bold
		draw_text 'От кого:' + ' ' * 51 + 'ИНН, при его наличии:', at: [180, 349], style: :bold
		draw_text 'Иванов Иван Иванович', at: [180, 339]
		draw_text '_' * 105, at: [174, 338]
		draw_text '_' * 105, at: [174, 328]
		draw_text 'Адрес отправителя:' + ' ' * 73 + 'Индекс:', at: [180, 317], style: :bold
		formatted_text_box [{text: '443110', character_spacing: 5.1}],
											 at: [478, 321], style: :bold
		draw_text 'ул. Вавилова, д. 3, кв. 15 МОСКВА', at: [180, 307]
		draw_text '_' * 105, at: [174, 306]
		draw_text '_' * 105, at: [174, 296]
		draw_text 'адрес места жительства (регистрации), адрес пребывания (ненужное зачеркнуть)', at: [204, 286]
		draw_text 'Предъявлен ' + '_' * 22 + ' Серия ______ № ____________ выдан ______ . __________ 20     г.',
							at: [183, 264]
		draw_text '(наименование документа)', at: [226, 254], size: 6
		draw_text '_' * 101, at: [180, 243]
		draw_text '(наименование учреждения)', at: [296, 235]
		draw_text '_' * 101, at: [180, 233]
		draw_text "<u>Для нерезидентов России</u>", at: [183, 225], inline_format: true
		draw_text 'Предъявлен ' + '_' * 22 + ' Серия ______ № ____________ выдан ______ . __________ 20     г.',
							at: [183, 215]
		draw_text 'Дата срока пребывания с _____ . _____ 20 _____г.,     по _____ . _____ 20 ____ г.',
							at: [182, 205]
		draw_text 'Гражданство:' + ' ' * 50 + 'Подпись отправителя:', at: [182, 191], style: :bold


		move_down 98
		table [[''] * 10], cell_style: {width: 10, height: 10}, position: 435
		move_down 22
		table [[''] * 6], cell_style: {width: 10, height: 10}, position: 475




		# Надписи по краям

		draw_text 'ф. 113эн', at: [515, 740]
		draw_text 'Линия отреза', at: [154, 510], rotate: 90
		draw_text 'Обведённое линией заполняется отправителем РПО',
							at: [168, 446], rotate: 90, size: 6, style: :bold
		draw_text 'исправления не допускаются', at: [550, 480], rotate: 90

		render

	end

end