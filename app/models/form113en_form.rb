class Form113enForm < Prawn::Document
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
		font "DejaVuSans", size: 7

		stroke_axis

		# Деление формы на сектора

		self.line_width = 2
		stroke do
			rectangle [175, 630], 355, 184
			rectangle [175, 360], 355, 174
			horizontal_line 175, 530, at: 538
		end

		self.line_width =1
		stroke do
			rectangle [2, 750], 550, 570
			rectangle [180, 525], 345, 74
			rectangle [180, 272], 345, 71
			vertical_line 180, 750, at: 156
			horizontal_line 267, 552, at: 637
			vertical_line 637, 750, at: 267
		end

		# Сектор с логотипом

		image "app/assets/images/logo_russian_post.png", at: [160, 745], width: 70

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
		draw_text '99999' + '     руб.        ' + '00' + '       коп.', at: [405, 620], style: :bold
		draw_text '_____________       ' + '   ___________', at: [395, 619], style: :bold
		draw_text 'Девять тысяч девятьсот девяносто девять руб.00 коп.', at: [185, 609], style: :bold

		10.times do |a|
			stroke_color 50, 50, 50, 0
			base_z = 615
			dash(lenght: 1, space: 1, phase: 1)
			stroke_horizontal_line 180, 525, at: base_z - (2 * a)
		end
		stroke_color 50, 50, 50, 100

		draw_text '(рубли прописью, копейки цифрами)', at: [285, 588]
		formatted_text_box [{text: 'Кому:    ', styles: [:bold]}, {text: 'ООО "Экстра"'}], at:[180, 585]
		draw_text '(для юридического лица - полное или краткое наименование, для гражданина - фамилия, имя, отчество полностью)',
							at: [198, 560], size: 5
		formatted_text_box [{text: 'Куда:    ', styles: [:bold]}, {text: 'г. Самара, а/я 4001'}], at:[180, 556]

		undash
		stroke do
			horizontal_line 175, 530, at: 576
			horizontal_line 175, 530, at: 566
			horizontal_line 175, 530, at: 548
			horizontal_line 180, 525, at: 502
		end

		draw_text '(адрес, почтовый индекс)', at: [305, 530]

		font "DejaVuSans", style: :bold, size: 6

		draw_text 'Заполняется при приёме перевода в адрес юридического лица', at: [235, 518]
		draw_text 'Выплатить наличными деньгами', at: [199, 508]
		draw_text 'Индекс', at: [430, 508]
		draw_text 'ИНН:' + ' ' * 56 + 'Кор/счёт:', at: [185, 495]

		move_down 205
		table [[' ']], cell_style: {width: 10, height: 10}, position: 185
		move_up 10
		table [[' '] * 6], cell_style: {width: 10, height: 10}, position: 460
		move_down 13
		table [[' '] * 12], cell_style: {width: 10, height: 10}, position: 185
		move_up 10
		table [[' '] * 20], cell_style: {width: 10, height: 10}, position: 320
		move_down 18
		table [[' '] * 20], cell_style: {width: 10, height: 10}, position: 185
		move_up 10
		table [[' '] * 9], cell_style: {width: 10, height: 10}, position: 430

		font "DejaVuSans", size: 7

		# Надписи по краям

		draw_text 'ф. 113эн', at: [515, 740]
		draw_text 'Линия отреза', at: [154, 510], rotate: 90
		draw_text 'Обведённое линией заполняется отправителем РПО',
							at: [168, 446], rotate: 90, size: 6, style: :bold
		draw_text 'исправления не допускаются', at: [550, 480], rotate: 90

		render

	end

end