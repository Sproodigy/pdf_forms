require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Form113enForm < Prawn::Document

	def draw_barcode(code, opts = {})
		x = opts[:x]
		y = opts[:y]
		size = opts[:size]

		code ||= '00000000000000'
		barcode = Barby::Code25Interleaved.new(code)
		barcode.include_checksum = false

		barcode_string = [code.to_s[0..5] + '   ' + code.to_s[6..7] + '   ', code.to_s[8..12], '   ' + code.to_s[13]]

		if opts[:string_only]
			formatted_text_box [{ text: barcode_string[0] }, { text: barcode_string[1], styles: [:bold] }, { text: barcode_string[2] }], at: [x+1, y-28], size: 8
			return
		end

		if size == :small
			barcode.annotate_pdf(self, x: x, y: y-22, xdim: 0.75, height: 22)

			formatted_text_box [{ text: barcode_string[0] }, { text: barcode_string[1], styles: [:bold] }, { text: barcode_string[2] }], at: [x+2, y-24], size: 8
		else
			barcode.annotate_pdf(self, x: x, y: y-25, xdim: 1, height: 30)

			draw_text 'ПОЧТА РОССИИ', at: [x, y+8], size: 8 if opts[:print_rus_post] || !opts.key?(:print_rus_post)
			formatted_text_box [{ text: barcode_string[0] }, { text: barcode_string[1], styles: [:bold] }, { text: barcode_string[2] }], at: [x+1, y-28], size: 11
		end
	end

	def print_f113en(receiver:, receiver_address:, index:, inn:, sender:, sender_address:, barcode:)
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

		draw_text '(рубли прописью, копейки цифрами)', at: [305, 590], style: :italic, size: 5
		formatted_text_box [{text: 'Кому:    ', styles: [:bold]}, {text: "#{receiver}"}], at:[180, 584]
		draw_text '(для юридического лица - полное или краткое наименование, для гражданина - фамилия, имя, отчество полностью)',
							at: [202, 560], size: 5, style: :italic
		formatted_text_box [{text: 'Куда:    ', styles: [:bold]}, {text: "#{receiver_address}"}], at:[180, 556]

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

		formatted_text_box [{text: index.to_s, character_spacing: 5.1}],
											 at: [473, 513], style: :bold
		formatted_text_box [{text: "#{inn}", character_spacing: 5.1}],
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

		draw_barcode barcode, x: 275, y: 435, print_rus_post: false

		formatted_text_box [{text: 'Наложенный платёж'}],
											 at: [200, 440], width: 65, height: 45, size: 9
		draw_text 'за РПО', at: [200, 400], style: :bold, size: 11
		draw_text '_' * 30, at: [434, 415]
		draw_text '_' * 30, at: [434, 400]
		draw_text '(шифр и подпись)', at: [454, 390], style: :italic

		# Секция отправителя перевод

		draw_text 'Обведённое линией заполняется отправителем перевода',
							at: [235, 375], style: :bold
		draw_text 'От кого:' + ' ' * 51 + 'ИНН, при его наличии:', at: [180, 359], style: :bold
		draw_text "#{sender}", at: [180, 349]
		draw_text '_' * 104, at: [174, 348]
		draw_text '_' * 104, at: [174, 338]
		draw_text 'Адрес отправителя:' + ' ' * 73 + 'Индекс:', at: [180, 327], style: :bold
		formatted_text_box [{text: index.to_s, character_spacing: 5.1}],
											 at: [478, 332], style: :bold
		text_box "#{sender_address}",
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
		draw_text 'Гражданство:' + ' ' * 50 + 'Подпись отправителя:', style: :bold, at: [182, 191]


		move_down 87
		table [[''] * 10], cell_style: {width: 10, height: 10}, position: 435
		move_down 22
		table [[''] * 6], cell_style: {width: 10, height: 10}, position: 475

		# Надписи по краям

		draw_text 'ф. 113эн', at: [515, 740]
		draw_text 'Линия отреза', at: [157, 380], rotate: 90
		draw_text 'Обведённое линией заполняется отправителем РПО',
							at: [168, 446], rotate: 90, size: 6, style: :bold
		draw_text 'исправления не допускаются', at: [548, 480], rotate: 90

		render

	end

	def print_f113en_back
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
			rectangle [172, 615], 371, 320
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
		draw_text '(подпись)', at: [186, 634], style: :italic
		text_box "О\nП\nЛ\nА\nТ\nА", at: [253, 726], size: 11, style: :bold

		# Секция расписки адресата

		draw_text 'РАСПИСКА АДРЕСАТА', at: [288, 619], size: 11, style: :bold
		text_box "к почтовому переводу\nналоженного платежа", at: [440, 632], style: :bold
		draw_text 'Обведённое жирной чертой заполняется адресатом',
		          at: [167, 340], style: :bold, rotate: 90

		bounding_box([175, 610], width: 365) do
			indent(2) do
				move_down 3
				text 'Сумма:', style: :bold

				fill_color 'eeeeee'
				fill_rectangle [30, 13], 332, 15
				fill_color '000000'
				move_down 3

				indent(135) do
					text '(рубли прописью, копейки цифрами)', style: :italic, size: 5
				end
				move_down 6

				text 'ФИО:' + '_' * 51, style: :bold

				text_box "ИНН, при\nего наличии:", at: [202, 12], style: :bold, size: 5
				move_up 12

				table [[' '] * 12], cell_style: {width: 10, height: 10}, position: 242
				move_down 7

				text '_' * 103
				text_box '<b>Получил:</b> "________" _________________________ 20_______ г.                     ' + '_' * 30,
				         at: [0, -10], inline_format: true
				move_down 18

				indent(110) do
					text '(дата)' + ' ' * 98 + '(подпись адресата)', style: :italic, size: 5
				end

			end

		end


		bounding_box([175, 535], width: 365) do
			move_down 7
			indent(2) do
				text "<b>Предъявлен:</b>______________________ Серия___________ №________________ выдан____________ 20____ г.",
				     inline_format: true
				indent(55) do
					text '(наименование документа)', style: :italic, size: 5
				end
				move_down 6
				text '_' * 103
				text '(наименование учреждения)', align: :center, style: :italic, size: 5
				self.line_width = 2
				stroke_horizontal_rule
				self.line_width = 1
				move_down 3
				text "<u>Для нерезидентов России</u>",style: :bold, inline_format: true
				move_down 6
				text "<b>Предъявлен:</b>______________________ Серия___________ №________________ выдан____________ 20____ г.",
				     inline_format: true
				indent(55) do
					text '(наименование документа)', style: :italic, size: 5
				end
				move_down 7
				text "<b>Дата срока пребывания с:</b> _____._____20_____г.   по_____._____20_____ г.", inline_format: true
			end
			stroke_bounds
		end

		bounding_box([175, 438], width: 365) do
			indent(2) do
				text 'Гражданство: __________________________________________', style: :bold
				text 'Укажите адрес жительства (регистрации) или места пребывания адресата', style: :bold
				move_down 7
				text '_' * 103
				move_down 7
				text '_' * 103
			end

		end

		bounding_box([175, 390], width: 365) do
			indent(2) do
				move_down 2
				text 'Заполняется при выплате перевода в адрес юридического лица', style: :bold
				move_down 6
				text 'Получатель: ' + '_' * 88, style: :bold
				table [[' '] * 10], cell_style: {width: 10, height: 10}, position: 22
				move_up 10
				table [[' '] * 15], cell_style: {width: 10, height: 10}, position: 210
				move_up 7
				text 'ИНН:                                                                   ОГРН:', style: :bold
				move_down 6
				text '_' * 103
				text '(адрес местонахождения по месту государственной регистрации)',
				     align: :center, style: :italic, size: 5
				move_down 6
				text '_' * 103
				move_down 6
				text '_' * 103
				text '(фактический адрес, указать при несовпадении с местом государственной регистрации)',
				     align: :center, style: :italic, size: 5
			end
			stroke_bounds
		end

		# transparent(10) {self.line_width = 2; stroke_bounds}

		# Нижняя секция

		draw_text 'Оплатил:', at: [162, 261], style: :bold
		draw_text '_' * 82, at: [162, 259]
		draw_text '(перечислено)                              (должность, подпись)',
		          style: :italic, at: [162, 250]
		draw_text 'Отметки о досылке, возвращени и причинах неоплаты',
		          at: [162, 233], style: :bold

		3.times do |t|
			stroke_horizontal_line 162, 450, at: 218 - (t * 16)
		end

		stroke_rectangle [472, 275], 60, 60

		draw_text '(оттиск КПШ ОПС', at: [470, 205]
		draw_text 'места получ.', at: [479, 195]
		draw_text 'или для перечисления)', at: [460, 185]

		render

	end

end