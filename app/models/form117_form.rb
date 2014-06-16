require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Form117Form < Prawn::Document

	def prepare_fonts
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

		font_families.update("PostIndex" => { normal: "#{Rails.root}/app/assets/fonts/PostIndex.ttf" })
		font "DejaVuSans", :size => 9
	end


	POST_STAMP_SIZE = 80

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
			formatted_text_box [{ text: barcode_string[0] }, { text: barcode_string[1], styles: [:bold] }, { text: barcode_string[2] }], at: [x+1, y-28], size: 11
		end
	end

	def print_f117_from_mailing(x, y, mailing)
		print_f117(x, y,
				barcode: mailing.num,
				order_num: mailing.order.id,
				receiver: mailing.order.name,
				receiver_address: mailing.order.address,
				receiver_index: mailing.order.zip,
				value: mailing.value,
				payment: mailing.payment,
				weight: mailing.weight,
				weight_cost: 61540,
				insurance_cost: 11000,
				sender: mailing.order.name,
				sender_address: mailing.company.address,
				sender_index: mailing.company.index
		)
	end

	def print_f117(x, y, barcode:,
			order_num: nil,
			ops_index: nil,
			form_num: 117,
			receiver:,
			receiver_address:,
			receiver_index:,
			value:,
			payment:,
			weight:,
			weight_cost:,
			insurance_cost:,
			sender:,
			sender_address:,
			sender_index:)

		prepare_fonts
		#translate(x,y) do
			font "DejaVuSans", size: 9
		stroke_vertical_line 0, 600, at: [-17]
			#image "#{Rails.root}/app/assets/pdf/postf117.jpg", at: [0, 595], width: 420
			image 'app/assets/images/logo_russian_post.png', width: 50,
						at: [-24, 490]


			stroke_vertical_line 0, 750, at: [385]

			draw_barcode(barcode, x: -17, y: 540)

			draw_text "ф. #{form_num}", at: [355, 545], size: 7

			formatted_text_box [{text: 'Заказ № '}, { text: order_num.to_s, styles: [:bold] }],
												 at: [155, 545] unless order_num.nil?

			draw_text "№_________________", at: [25, 451]
			draw_text "(по накладной ф.16)", at: [35, 442], size: 7

			draw_post_stamp 205, 520#, zip: ops_index, title: true unless ops_index.nil?
			stroke_rectangle [205, 440], 80, 20
			text_box "Календ. штемпель\nОПС места приёма",
							 at: [210, 437], size: 7

			stroke do
				line_width 2

				move_to -8, 420
				line_to 285, 420
				line_to 285, 320
				line_to 380, 320
				line_to 380, 203
				line_to -8, 203
				line_to -8, 421
			end

			# bounding_box([19, 441], width: 281, height: 16) do
			# 	draw_text value/100, at: [3, 5], style: :condensed_bold unless value.nil?
			# 	draw_text "(сумма объявленной ценности)", at: [75, -7], size: 7
			# 	stroke_bounds
			# end
			#
			# bounding_box([19, 414], width: 281, height: 16) do
			# 	draw_text payment/100, at: [3, 5], style: :condensed_bold unless  payment.nil?
			# 	draw_text "(сумма наложенного платежа)", at: [75, -7], size: 7
			# 	stroke_bounds
			# end

			formatted_text_box [{text: 'Кому: ', styles: [:bold]}, { text: receiver }],
												 at: [0, 382], width: 210, height: 20

			formatted_text_box [{text: 'Адрес: ', styles: [:bold]}, { text: receiver_address }, { text: receiver_index.to_s }],
												 at: [0, 360 ], width: 210, height: 40

			formatted_text_box [{text: 'От кого: ', styles: [:bold]}, { text: sender}],
												 at: [0, 310], width: 235, height: 10

			formatted_text_box [{text: 'Адрес: ', styles: [:bold]}, { text: sender_address}, { text: sender_index.to_s}],
												 at: [0, 295], width: 315, height: 20

			text_box "Запрещенных к пересылке вложений нет.
								С требованиями к упаковке ознакомлен" + '_' * 30, at: [0, 250], style: :bold
			draw_text "(подпись отправителя)", at: [235, 224], size: 7


			draw_text 'и с п р а в л е н и я  н е  д о п у с к а ю т с я',
								at: [-11, 207], style: :condensed_bold, rotate: 90

		insurance_cost.nil? ? pay = 'Плата: ' : pay = 'за вес: '

		formatted_text_box [{text: 'Вес: '}, { text: (weight/1000).to_s + ' кг.', styles: [:bold] },
											 {text: "\nПлата", styles: [:bold]},
											 {text: "\n#{pay}"}, { text: (weight_cost/100).to_s + ' руб.', styles: [:bold] },
											 {text: "\nза ОЦ: "}, { text: (insurance_cost/100).to_s + ' руб.', styles: [:bold]},
											 {text: "\nВсего: "}, { text: ((weight_cost + insurance_cost)/100).to_s + ' руб.', styles: [:bold] },
											 {text: "\n___________________"}],
											 at: [290, 413], leading: 4 unless insurance_cost.nil?
		draw_text "(подпись оператора)", at: [294, 324], size: 7

			# formatted_text_box [{text: 'Вес: '}, { text: (weight/1000).to_s + ' кг.', styles: [:bold] }],
			# 									 at: [300, 413], height: 10
			# insurance_cost.nil? ? pay = 'Плата: ' : pay = 'за вес '
			# draw_text 'Плата', style: :condensed_bold, at: [300, 390] unless insurance_cost.nil?
			# formatted_text_box [{text: pay},{ text: (weight_cost/100).to_s }, {text: ' руб.'}],
			# 									 at: [300, 391], height: 10
			# formatted_text_box [{text: 'за о.ц.: '},{ text: (insurance_cost/100).to_s }, {text: ' руб.'}],
			# 								 at: [300, 373], height: 10 unless insurance_cost.nil?
			# formatted_text_box [{text: 'Всего: ', styles: [:bold]},{ text: ((weight_cost + insurance_cost)/100).to_s, styles: [:bold] }, {text: ' руб.'}],
			# 									 at: [300, 355], height: 10 unless insurance_cost.nil?

		# Секция извещения о посылке

		image 'app/assets/images/logo_russian_post.png', width: 50,
		      at: [-13, 192]

		draw_barcode barcode, x: 275, y: 190, size: :small

		stroke_color 'd3d3d3'
		stroke do
			horizontal_line -8, 150, at: [197]
			horizontal_line 219, 380, at: [197]
		end
		stroke_color '000000'
		draw_text 'л и н и я   о т р е з а', at: [153, 195], style: :italic, size: 6

			draw_text "Извещение о посылке № _______________", at: [38,165]
			draw_text "(по накладной ф.16)", at: [160, 157], size: 6
			formatted_text_box [{text: 'Вес:  '}, { text: (weight/1000).to_s + 'кг.',styles: [:bold] }],
			                    at: [38, 150], width: 150, height: 10
			draw_text "Оттиск календарного штемпеля", at: [232, 147], size: 7
			draw_text "ОПС места приема", at: [255, 140], size: 7

			# mailing.decl_amount_digit = 0.0 if opts[:simple]
			# mailing.cod_amount_digit = 0.0 if opts[:simple]
			# draw_text 'Сумма объявленной', at: [19,115]
			# formatted_text_box [{text: 'ценности  '}, { text: fcc(mailing.decl_amount_digit), styles: [:bold] }, {text: ' руб. '}, { text: ((mailing.decl_amount_digit-mailing.decl_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0'), styles: [:bold] }, {text: ' коп.'}], at: [19, 111], width: 280, height: 10
			#
			# draw_text 'Сумма наложенного', at: [222,115]
			# formatted_text_box [{text: 'платежа  '},{ text: fcc(mailing.cod_amount_digit.floor), styles: [:bold] }, {text: ' руб. '}, { text: ((mailing.cod_amount_digit-mailing.cod_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0'), styles: [:bold] }, {text: '  коп. '}], at: [222, 111], width: 250, height: 10
			stroke_rectangle [-8, 137], 383, 100
			formatted_text_box [{text: 'Кому: ', styles: [:bold]}, { text: receiver }],
			                   at: [19, 85], width: 325, height: 40

			formatted_text_box [{text: 'Адрес: ', styles: [:bold]}, { text: receiver_address }, { text: receiver_index.to_s }],
			                   at: [19, 72], width: 325, height: 40


			draw_text 'Обведенное жирной чертой заполняется отправителем',
								at: [56, 26], style: :condensed_bold
			draw_text 'Извещение доставил' + '_' * 63, at: [-8, 12]
			draw_text "(дата и подпись)", at: [202, 4], size: 7

			render
		#end

	end

  def print_form117_back

	prepare_fonts

    font "DejaVuSans", size: 9

    base_z = 550

      draw_text "Извещение передано в доставку________________________________________________",
                :at => [-17, base_z], :style => :bold
      draw_text "Вторичное извещение выписано ________________________________________________",
                :at => [-17, base_z-20], :style => :bold
      draw_text "(дата и подпись)", :at => [225, base_z-8], :size => 7
      draw_text "(дата и подпись)", :at => [225, base_z-28], :size => 7
      draw_text "Плата", :at => [-17, base_z-34], :style => :bold
      draw_text "За хранение______________________________________________руб.___________________коп.",
                :at => [-17, base_z-48]
      draw_text "За доставку_______________________________________________руб.___________________коп.",
                :at => [-17, base_z-63]
      draw_text "Отметки о досылке и возвращении",
                :at => [90, base_z-78], :style => :bold

      stroke do
        horizontal_line -17, 300, :at => base_z-92
        horizontal_line -17, 300, :at => base_z-109
        horizontal_line -17, 300, :at => base_z-160
        rectangle [310, base_z-75], 60, 60
        rectangle [317, base_z-285], 60, 60
      end

      draw_text "Плата", :at => [-17, base_z-123], :style => :bold
      draw_text "За возвращение, досылку___________________________руб.________коп.",
                :at => [-17, base_z-133]

      draw_text "(оттиск календ.", :at => [310, base_z-142], :size => 7
      draw_text "штемпеля ОПС", :at => [311, base_z-150], :size => 7
      draw_text "места вручения)", :at => [309, base_z-158], :size => 7
      draw_text "(дата и подпись)", :at => [125, base_z-167], :size => 7

      draw_text "Обведённое жирной чертой",
                :at => [-13, base_z-330], :style => :bold, :rotate => 90
      draw_text "заполняется получателем",
                :at => [-3, base_z-330], :style => :bold, :rotate => 90

      draw_text "(оттиск календ.", :at => [317, base_z-353], :size => 7
      draw_text "штемпеля ОПС", :at => [319, base_z-361], :size => 7
      draw_text "места вручения)", :at => [317, base_z-369], :size => 7

    stroke do
      line_width 2
      move_to 0, base_z-175

      line_to 380, base_z-175
      line_to 380, base_z-275
      line_to 310, base_z-275
      line_to 310, base_z-350
      line_to 0, base_z-350
      line_to 0, base_z-175
    end

      self.line_width = 1

      draw_text "Отметка о предоставленном документе и подпись адресата",
                :at => [30, base_z-185], :style => :bold

      text_box 'Предъявлен ________________________________Cерия_________№__________________
                Выдан "______" ______________________20______г. кем ____________________________
                _________________________________________________________________________________',
                :at => [5, base_z-195], :height => 85,
                :width => 370, :leading => 8
      draw_text "(наименование документа)", :at => [85, base_z-210], :size => 7
      draw_text "(наименование учреждения,", :at => [260, base_z-229], :size => 7
      draw_text "выдавшего документ)", :at => [140, base_z-247], :size => 7
      draw_text 'При получении посылок, адресованных "До востребования", по месту работы, учёбы,а/я',
                :at => [5, base_z-260], :size => 7, :style => :bold
      draw_text "при проживании по другому адресу укажите сведения о месте регистрации",
                :at => [5, base_z-270], :size => 7, :style => :bold
      draw_text "Зарегистрирован________________________________________________",
                :at => [5, base_z-295]
      draw_text "Посылку с верной массой, исправными упаковкой, печатями и перевязью",
                :at => [5, base_z-315], :size => 7, :style => :bold
      draw_text 'Получил "______"___________________20_____г.____________________',
                :at => [5, base_z-335]
      draw_text "(подпись адресата)",
                :at => [219, base_z-343], :size => 7

      draw_text "Выдал___________________________________________________________________",
                :at => [-17, base_z-375]
      draw_text "л и н и я   о т р е з а", :at => [140, base_z-400],
                :style => :italic, :size => 7

      stroke_color 50, 50, 50, 10
      stroke_horizontal_line -17, 138, :at => base_z-397
      stroke_horizontal_line 217, 375, :at => base_z-397
      stroke_color 50, 50, 50, 100

      draw_text "Выдача производится по адресу:___________________________________________________",
                :at => [-17, base_z-420]
      draw_text "______________________________________________от____________________до_______________",
                :at => [-17, base_z-450]
      draw_text "Для письменного сообщения",
                :at => [100, base_z-485], :style => :bold

    3.times do |a|
      stroke_horizontal_line -17, 380, :at => base_z-515-(25 * a)
    end

		render

    end

  end
