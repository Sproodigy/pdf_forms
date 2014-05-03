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
		end

		self.line_width =1
		stroke do
			rectangle [2, 750], 550, 570
			rectangle [180, 525], 345, 74
			rectangle [180, 272], 345, 71
			vertical_line 180, 750, at: 156
			horizontal_line 267, 550, at: 637
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




		render

	end

end