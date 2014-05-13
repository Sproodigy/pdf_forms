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
			vertical_line 180, 750, at: 159
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

		text_box "Вторичное извещение\n\nвыписано _____________\n\n<b>Плата за доставку</b>\n\n
						 _________руб. ______коп.\n\nПодлежит оплате\n\n________________________",
						 at: [163, 740], inline_format: true
		draw_text '(подпись)', at: [186, 634]
		text_box "О\nП\nЛ\nА\nТ\nА", at: [253, 726], size: 11, style: :bold

		# Секция расписки адресата

		draw_text 'РАСПИСКА АДРЕСАТА', at: [288, 619], size: 11, style: :bold
		text_box "к почтовому переводу\nналоженного платежа", at: [440, 632], style: :bold
		draw_text 'Обведённое жирной чертой заполняется адресатом',
							at: [167, 340], style: :bold, rotate: 90

		bounding_box([175, 500], width: 365, height: 80) do
			move_down 4
			indent(2) do
				text "<b>Предъявлен:</b>_____________________ Серия___________ №________________ выдан____________ 20__.__ г.",
						 inline_format: true
				indent(55) do
					text '(наименование документа)', style: :italic, size: 5
				end
				move_down 4
				text '_' * 103
				text '(наименование учреждения)', align: :center, style: :italic, size: 5
				self.line_width = 2
				stroke_horizontal_rule
				self.line_width = 1
				move_down 2
				text "<u>Для нерезидентов России</u>",style: :bold, inline_format: true
				move_down 4
				text "<b>Предъявлен:</b>_____________________ Серия___________ №________________ выдан____________ 20__.__ г.",
						 inline_format: true
				indent(55) do
					text '(наименование документа)', style: :italic, size: 5
				end
				move_down 5
				text "<b>Дата срока пребывания с:</b>_____._____20_____г.   по_____._____20_____ г.", inline_format: true
			end
			stroke_bounds
		end

		bounding_box([175, 414], width: 365, height: 50) do
			indent(2) do
				text 'Гражданство: __________________________', style: :bold
				text 'Укажите адрес жительства (регистрации) или места пребывания адресата', style: :bold
				move_down 5
				text '_' * 103
				move_down 5
				text '_' * 103
			end

		end

		bounding_box([175, 370], width: 365, height: 80) do
			indent(2) do
				move_down 2
				text 'Заполняется при выплате перевода в адрес юридического лица', style: :bold
				move_down 3
				text 'Получатель: ' + '_' * 88, style: :bold
				table [[' '] * 10], cell_style: {width: 10, height: 10}, position: 22
				move_up 10
				table [[' '] * 15], cell_style: {width: 10, height: 10}, position: 210
				move_up 7
				text 'ИНН:                                                                   ОГРН:', style: :bold
				move_down 4
				text '_' * 103
				text '(адрес местонахождения по месту государственной регистрации)',
					     align: :center, style: :italic, size: 5
				move_down 3
				text '_' * 103
				move_down 3
				text '_' * 103
					text '(фактический адрес, указать при несовпадении с местом государственной регистрации)',
					     align: :center, style: :italic, size: 5
			end
			stroke_bounds
		end

		# transparent(10) {self.line_width = 2; stroke_bounds}

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