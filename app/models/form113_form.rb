require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Form113Form < Prawn::Document
	include ActionView::Helpers::NumberHelper

	POST_STAMP_SIZE = 80

	def fc(num)
		number_with_precision(num, precision: 0, delimiter: ' ')
	end

	def draw_post_stamp(x, y, opts = {})
		translate(x, y) do
			float do
				bounding_box([0, 0], width: POST_STAMP_SIZE, height: POST_STAMP_SIZE) do
					stroke_bounds

					date = if opts[:mailing]
						       if opts[:mailing].send_date
							       opts[:mailing].send_date
						       else
							       opts[:mailing].mailing_object.created_at
						       end
						     else
							     opts[:date]
						     end
					zip = opts[:mailing] ? opts[:mailing].mailing_object.company.zip : opts[:zip]

					move_down 5
					if date
						text date.strftime('%d.%m.%Y'), size: 9, align: :center
						if (not date.respond_to?(:in_time_zone)) || (date.in_time_zone('UTC').seconds_since_midnight == 0)
							move_down 10
						else
							text date.strftime('%H:%M:%S'), size: 9, align: :center
						end
					end

					if zip
						post_index = PostIndex.find zip
						# Get parent ops, if DTI index
						post_index = post_index && post_index.real_ops

						if post_index
							text post_index.index.to_s, size: 10, align: :center, style: :bold
							text post_index.ops_type_abbr[0..13], size: 9, align: :center
							text_box post_index.ops_name, at: [0, 32], width: POST_STAMP_SIZE, height: 30, size: 8, style: :bold, align: :center, valign: :bottom if post_index.ops_name.present?
						end
					end
				end

				if opts[:title]
					bounding_box [0, -POST_STAMP_SIZE], width: POST_STAMP_SIZE, height: 20 do
						stroke_bounds
						move_down 2
						text 'Календ. штемпель ОПС места приёма', size: 7, align: :center
					end
				end
			end
		end
	end

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
			formatted_text_box [{ text: barcode_string[0] }, { text: barcode_string[1], styles: [:bold] }, { text: barcode_string[2] }],
												 at: [x+1, y-28], size: 11
		end
	end

	def print_f113_from_mailing(x, y, mailing)
		print_form113(x, y,
									barcode: mailing.num,
									order_num: mailing.order.id,
									receiver: mailing.company.juridical_title,
									receiver_address: mailing.company.address,
									receiver_index: mailing.company.index,
									receiver_inn: mailing.company.inn,
									payment: mailing.payment,
									sender: mailing.order.name,
									sender_address:mailing.order.address ,
									sender_index: mailing.order.zip)
	end

	def print_form113(x, y, form_num: 113, barcode:, order_num:, receiver:, receiver_address:, receiver_inn:, receiver_index:, payment:,
										sender:, sender_address:, sender_index:)
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

		stroke_vertical_line 0, 750, at: [385]

		# Секция с календарным штемпелем

		image 'app/assets/images/logo_russian_post.png', width: 50,
					at: [-24, 500]

		draw_barcode barcode, x: -17, y: 540
		draw_text "№_________________", at: [25, 489]
		draw_text "(по накладной ф.16)", at: [35, 480], size: 7
		draw_text "№_________________", at: [25, 466]
		draw_text "(по реестру ф.10)", at: [40, 457], size: 7

		text_box "П\nР\nИ\nЕ\nМ", at: [125, 510], size: 10, style: :bold

		formatted_text_box [{ text: "Заказ № " }, { text: order_num.to_s, styles: [:bold]}],
											 at: [155, 545] unless order_num.nil?
		draw_text "ф. #{form_num}", at: [355,545], size: 7

		draw_post_stamp 300, 531, title: true

		text_box "обведенное жирной чертой\nзаполняется отправителем", style: :bold, size: 6,
											 at: [-17, 447]

		# Секция получателя платежа

		line_width 2
		stroke_polygon [-7, 431], [380, 431], [380, 310], [280, 310], [280, 261], [-7, 261], [-7, 432]

		draw_text 'исправления не допускаются', at: [-11, 300], style: :condensed_bold, size: 7, rotate: 90

		draw_text "ПОЧТОВЫЙ ПЕРЕВОД наложенного платежа на #{fc(payment)} руб. #{(payment-payment.floor).floor.to_s[0..1].rjust(2, '0')} коп.", at: [-2, 420], style: :condensed_bold, size: 10

		total_sum_string = (RuPropisju.propisju_int(payment.floor) + ' руб. ' +
				(payment-payment.floor).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize

		bounding_box([-3, 414], width: 379, height: 15) do
			draw_text total_sum_string, style: :condensed_bold, at: [2,5]
			stroke_bounds
		end

		draw_text '(рубли прописью, копейки цифрами)', at: [117, 392], size: 7
		formatted_text_box [{text: "Кому: ", styles: [:bold]}, {text: receiver},
												{text: "\n\nАдрес: ", styles: [:bold]}, {text:receiver_index.to_s +  ', Федеральный клиент ООО "Экстра"'}],
											 at: [-2, 387], width: 375
		formatted_text_box [{text: "ИНН: ", styles: [:bold]}, {text: "#{receiver_inn.to_s}"},
												{text: "\n#{receiver_index}, " .to_s + 'Федеральный клиент ООО "Экстра", код 6194'}],
											 at: [-2, 317], width: 300
		draw_text '_' * 21, at:[284, 295]
		draw_text '_' * 21, at:[284, 279]
		draw_text "(шифр и подпись)", at: [300, 271], size: 7

		line_width 1
		stroke_color 50, 50, 50, 0
		stroke_horizontal_line -17, 130, at: 554-300
		stroke_horizontal_line 210, 380, at: 254
		stroke_vertical_line 247, 154, at: 190
		stroke_vertical_line 74, -26, at: 190
		stroke_color 50, 50, 50, 100
		draw_text "л и н и я   о т р е з а", at: [132, 251],
							style: :italic, size: 7
		draw_text "л и н и я   о т р е з а", at: [190, 77],
							style: :italic, size: 7, rotate: 90

		# Секция отправителя платежа

		draw_barcode barcode, x: 80, y: 233, size: :small

		draw_text "Высылается наложенный платеж", at: [-10, 240], style: :bold

		line_width 2
		stroke_polygon [-7, 235], [73, 235], [73, 199], [182, 199], [182, 58], [126, 58], [126, 38], [-7, 38], [-7, 236]

		formatted_text_box [{text: 'За: ', styles: [:bold]}, {text: 'посылку, письмо, бандероль'}], at: [-2, 230], width: 70
		draw_text 'Подан', at: [-2, 183], style: :bold
		formatted_text_box [{ text: Time.now.strftime("%d.%m.%Y"), size: 9}],
											 at: [60, 169]
		formatted_text_box [{text: 'Дата: ', styles: [:bold]}, {text: '_' * 26},
												{text: "\n\nАдресован: ", styles: [:bold]}, {text: sender_address},
												{text: "\n\nНа имя: ", styles: [:bold]}, {text: sender}],
											 at: [-2, 168], width: 178

		font_size 6
		line_width 1
		stroke_rectangle [130, 54], 50, 50

		draw_text '(оттиск календ. шт.', at: [124, -2]
		draw_text 'ОПС места', at: [138, -9]
		draw_text 'вручения РПО)', at: [132, -16]
		font_size 9

		draw_text "Отправление выдал:", at: [-2, 28], style: :bold
		draw_text '_' * 24, at: [-2, 8]
		draw_text "(должность, подпись)", at: [11, 0], size: 7

		# Секция извещения

		draw_text "ИЗВЕЩЕНИЕ", at: [275, 210], size: 10, style: :bold

		image 'app/assets/images/logo_russian_post.png', width: 50,
					at: [191, 208]

		draw_text '№' + '_' * 30, at: [237, 193]
		draw_text '(по реестру ф. 11)', at: [278, 185], size: 7
		formatted_text_box [{ text: 'о почтовом переводе наложенного платежа №________', styles: [:bold], size: 8 }],
			at: [232, 174], width: 150, height: 20
		draw_text '(по ф. 5)', at: [350, 150], size: 7

		line_width 2
		bounding_box([196, 145], width: 185, height: 100) do
			draw_text "#{fc(payment)} руб. #{(payment-payment.floor).floor.to_s[0..1].rjust(2, '0')} коп.",
								at: [37, 88], style: :bold
			formatted_text_box [{text: 'Кому: ', styles: [:bold]}, {text: receiver.to_s},
													{text: "\n\nАдрес: ", styles: [:bold]},{text: receiver_index.to_s},
													{text: ', Федеральный клиент ООО "Экстра"'}],
												 at: [5, 75], width: 180
			stroke_bounds
		end

		draw_text 'Оплата производится по адресу:', style: :bold, at: [205, 30]
		draw_text '_' * 38, at: [205, 15]
		draw_text '_' * 14 + 'с' + '_' * 10 + 'до' + '_' * 10, at: [205, -2]

		render

	end


	def print_form113_back
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

		text_box "Вторичное извещение выписано _________________
                Плата за доставку _______________руб.______коп.
                Подлежит оплате ___________________________",
						 at: [-17, 554], height: 100, width: 145, leading: 7

		text_box "О\nП\nЛ\nА\nТ\nА", at: [120, 535], leading: 1

		draw_text "(подпись)", at: [25, 451], size: 7
		draw_text "РАСПИСКА АДРЕСАТА", at: [115, 436], size: 11


		bounding_box([-17, 431], width: 397, height: 65) do

			line_width 2
			move_down 10
			indent(10) do
				text "Сумма"
				move_down 20
				text 'Получил "_______" ______________________20_______г.  ______________________________ '

				indent(293) do
					text "(подпись)", size: 7
				end

			end

			stroke_bounds
		end

		self.line_width = 1
		stroke_color 50, 50, 50, 10
		6.times do |a|
			stroke_horizontal_line 30, 370, at: 426-(3 * a)
		end

		stroke_color 50, 50, 50, 100
		draw_text "Оплатил", at: [-17, 354]
		stroke_horizontal_line -17, 290, at: 349
		draw_text "(перечислено)", at: [-5, 341]
		draw_text "(должность, подпись)",size: 7, at: [130, 341]
		draw_text "Отметки о досылке, возвращении и причинах неоплаты",
							at: [-5, 314]

		3.times do |b|
			stroke do
				rectangle [300, 349], 60, 60
				horizontal_line -17, 280, at: 299-(15 * b)
			end
		end

		draw_text "(оттиск календарного", at: [289, 282], size: 7
		draw_text "штемпеля ОПС места вр", at: [285, 274], size: 7
		draw_text "или дня перечисления)", at: [287, 266], size: 7

		stroke_color 50, 50, 50, 10
		stroke_horizontal_line -17, 130, at: 254
		stroke_horizontal_line 210, 380, at: 254
		stroke_vertical_line 247, 154, at: 190
		stroke_vertical_line 74, -26, at: 190
		stroke_color 50, 50, 50, 100
		draw_text "л и н и я   о т р е з а", at: [132, 251],
							style: :italic, size: 7
		draw_text "л и н и я   о т р е з а", at: [190, 77],
							style: :italic, size: 7, rotate: 90

		draw_text "Для получения денег заполните извещение и предъя- ",
							at: [-12, 241], size: 6
		draw_text "вите паспорт или документ, удостоверяющий личность",
							at: [-17, 234], size: 6

		line_width 2
		stroke_polygon [-17,229], [177, 229], [177, 25], [51, 24], [51, 48], [-17, 48], [-17, 230]
		stroke_rectangle [203, 239], 177, 260

		line_width  1
		stroke_rectangle [-8, 44], 50, 50

		draw_text "Заполняется адресатом", at: [-10, 219],
							style: :italic

		text_box 'Предъявлен __________________________
                Серия ______ №____________, выданный
                "_____" _______20______г., кем _________
                ________________________________________',
						 at: [-10, 204], height: 145,
						 width: 185, leading: 7

		draw_text "(наименование учреждения выдавшего документ)",
							at: [-14, 136], size: 7

		text_box 'Для переводов, адресованных "до востребования",
               на а\я, по месту работы (учёбы), при несовпадении
               прописки или регистрации с указанным адресом,
               укажите адрес и дату прописки или регистрации',
						 at: [-5, 132], size: 6, indent_paragrahs: 50

		stroke_horizontal_line -13, 170, at: 83
		stroke_horizontal_line -13, 170, at: 63

		draw_text "Адресат________________", at: [55, 37]
		draw_text "(подпись)", at: [110, 29], size: 7

		image "app/assets/images/logo_russian_post.png", at: [207, 235], width: 50

		draw_text "ТАЛОН", at: [292, 219], size: 11
		draw_text "к почтовому переводу", at: [257, 204], style: :bold
		draw_text "наложенного платежа", at: [257, 194], style: :bold
		draw_text "На __________________руб.______коп.",
							at: [207, 154], style: :bold
		draw_text "От кого", at: [207, 114], style: :bold
		draw_text "Адрес отправителя", at: [207, 64], style: :bold

		draw_text "Оплатил ___________________", at: [50, -6]
		draw_text "(дата, подпись)", at: [115, -14], size: 6
		draw_text "(оттиск календ. шт.", at: [-15, -11], size: 6
		draw_text "ОПС места", at: [-2, -18], size: 6
		draw_text "вручения РПО)", at: [-8, -25], size: 6

		render

	end

  end
