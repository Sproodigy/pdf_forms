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
			rectangle [162, 630], 381, 284
		end

		self.line_width =1
		stroke do
			rectangle [0, 750], 550, 570
			vertical_line 180, 750, at: 156
			horizontal_line 267, 550, at: 637
			vertical_line 637, 750, at: 267
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

		# Нижняя секция

		3.times do |t|
			stroke_horizontal_line 162, 400, at: 210 - (t * 12)
		end

		font 'DejaVuSans', size: 6
		draw_text '(оттиск КПШ ОПС', at: [470, 210]
		draw_text 'места получ.', at: [422, 200]
		draw_text 'или для перечисления)', at: [418, 190]

		render

	end

end