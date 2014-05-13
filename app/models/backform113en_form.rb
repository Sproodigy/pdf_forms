class Backform113enForm < Prawn::Document
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
			rectangle [172, 615], 371, 329
		end

		self.line_width =1
		stroke do
			rectangle [0, 750], 550, 570
			vertical_line 180, 750, at: 156
		end

		# Секция с логотипом

		image 'app/assets/images/logo_russian_post.png', at: [5, 745], width: 60

		font 'DejaVuSans', size: 7, style: :bold

		draw_text 'Талон', at: [88, 697], size: 11
		formatted_text_box [{text: "к почтовому переводу\nналоженного платежа"}],
											 at: [61, 692]
		draw_text 'На ______________руб. _______коп.', at: [30, 660]
		formatted_text_box [{text: "От кого: _______________________________\n
																_________________________________________\n
																_________________________________________\n
																Адрес отправителя: _________________\n
																_________________________________________\n
																_________________________________________\n
																_________________________________________\n
																_________________________________________\n
																_________________________________________\n
																РПО: ___________________________________\n
																_________________________________________\n
																_________________________________________\n
																_________________________________________\n"}],
											 at: [5, 640]

		font 'DejaVuSans', size: 7

		# Верхняя секция

		text_box "Вторичное извещение\n\nвыписано _____________\n\nПлата за доставку\n\n
						 _________руб. ______коп.\n\nПодлежит оплате\n\n________________________",
						 at: [160, 740]
		draw_text '(подпись)', at: [183, 634]
		text_box "О\nП\nЛ\nА\nТ\nА", at: [250, 726], size: 11, style: :bold

		# Секция расписки адресата

		draw_text 'РАСПИСКА АДРЕСАТА', at: [288, 619], size: 11, style: :bold
		text_box "к почтовому переводу\nналоженного платежа", at: [440, 632], style: :bold
		draw_text 'Обведённое жирной чертой заполняется адресатом',
							at: [167, 340], style: :bold, rotate: 90

		# Нижняя секция

		draw_text 'Оплатил', at: [162, 254]
		draw_text '_' * 82, at: [162, 252]
		draw_text '(перечислено)                              (должность, подпись)',
							at: [162, 242]
		draw_text 'Отметки о досылке, возвращени и причинах неоплаты',
							at: [162, 225], style: :bold

		3.times do |t|
			stroke_horizontal_line 162, 450, at: 210 - (t * 12)
		end

		stroke_rectangle [472, 275], 60, 60

		draw_text '(оттиск КПШ ОПС', at: [470, 205]
		draw_text 'места получ.', at: [479, 195]
		draw_text 'или для перечисления)', at: [460, 185]

		render

	end

end