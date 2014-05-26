require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Form22Form < Prawn::Document
	include ActionView::Helpers::NumberHelper
	include Documents::PostFormsFormatHelpers

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

		barcode_string = [code.to_s[0..5] + '   ' + code.to_s[6..7] + '   ', code.to_s[8..14], '   ' + code.to_s[15]]

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

	def print_form22(x:, y:, doc_num:, receiver:, receiver_address:, mailing_type:,
			weight:, value:, payment:, delivery_cost:)
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
		font 'DejaVuSans', size: 9

		translate(x, y) do

			image 'app/assets/images/logo.jpg', at: [0,723], width: 80

			draw_barcode '2389208734389890', x: 170, y: cursor, print_rus_post: false

			draw_post_stamp(369, cursor-10)

			draw_text 'ф. 22', at: [440, cursor], size: 7
			formatted_text_box [{text: 'Извещение № '}, {text: doc_num.to_s, styles: [:bold]}],
			                   at:[85, cursor-38]
			move_down 60
			formatted_text_box [{text: "\nКому:  "}, {text: "#{receiver}", styles: [:bold]},
			                    {text: "\nАдрес: "}, {text: "#{receiver_address}", styles: [:bold]},
			                    {text: "\nНа ваше имя поступило: "}, {text: "#{mailing_type}", styles: [:bold]},
			                    {text: "\nОткуда: "}, {text: 'Самарская обл., Октябрьский р-он, г. Самара, ул. Лейтенанта Шмидта, д. 106, корп. 109', styles: [:bold]}],
			                   at: [0, cursor+20], width: 380, leading: 2

			formatted_text_box [ {text: 'Масса: '}, {text: weight.to_s + ' кг', styles: [:bold]} ],
			                   at: [0, cursor-85]

			text_box '(дата и место
							составления)', at: [388, cursor-32], size: 6

			bounding_box([0, cursor-110], width: 178) do
				text 'Объявленная ценность:           '
				move_up 10.3
				text "#{fc(value)} руб.", style: :bold, align: :right
				move_down 2
				text "Наложенный платёж:        "
				move_up 10.3
				text "#{fc(payment)} руб.", style: :bold, align: :right
				move_down 2
				text 'Плата за доставку:'
				move_up 10.3
				text '-', style: :bold, align: :right
				move_down 2
				text 'Плата за возвр./дост.:        '
				move_up 10.3
				text "#{fc(delivery_cost)} руб.", style: :bold, align: :right
			end

			bounding_box([254, 585], width: 200, height: 60) do
				indent(20) do
					move_down 2
					text 'Выдача производится по адресу:'
				end
				stroke_bounds
			end

			text_box 'Возможна доставка на дом (услуга платная).
							Вызов курьера по телефону:', at: [254, cursor-2], size: 6

			draw_text 'Извещение доставил '+ '_' * 45, at: [254, cursor-30	], size: 6
			draw_text '(дата, подпись)', at: [365, cursor-37], size: 6

			text_box "<font_size='7'><b>Внимание!</b>   Срок хранения:</font>
							- отправлений разряда Судебное - 7 дней
							- почтовых отправлений и почтовых переводов - 30 дней
							За хранение регистрируемого почтового отправления с адресата
							взимается плата в соответствии с установленными тарифами
							согласно Правилам оказания услуг почтовой связи.",
			         at: [0, cursor-44], inline_format: true, size: 6

			text_box "Для получения почтового отправления, перевода необходимо
							предъявить настоящее извещение и документ удостоверяющий
							личность.
							На извещении предварительно укажите сведения об этом
							документе.",
			         at: [254, cursor-52], inline_format: true, size: 6

		end

	end

	def print_form22_back
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
		font 'DejaVuSans', size: 10

		translate(x,y) do

			text_box "Заполняется получателем", style: :bold
			move_down 24
			text 'Предъявлен _____________ Серия______ №___________ выдан "_____" _____________ 20_____ г.'
			move_down 12
			text 'Кем ' + '_' * 87
			draw_text '(наименование учреждения, выдавшего документ)', at:[140, cursor-4], size: 7
			move_down 12
			text 'Зарегистрирован ' + '_' * 73
			draw_text '(указать при получении почтовых отправлений и денежных переводов,', at:[110, cursor-4], size: 7
			move_down 12
			text '_' * 92
			draw_text 'адресованных "до востребования", на а/я, по месту учёбы,', at:[107, cursor-4], size: 7
			move_down 12
			text '_' * 92
			draw_text 'при несовпадении места регистрации с указанным адресом)', at:[105, cursor-4], size: 7
			text_box 'Почтовое отправление, указанное на лицевой
							стороне извещения, с верным весом, исправными оболочкой, печатями, пломбами, перевязью,
							почтовый перевод получил.',
			         at: [0, cursor-10],	style: :bold, size: 7, width: 210, leading: 5
			draw_text '"_______" ___________________ 20 ______г.', at: [261, cursor-18]
			draw_text '_' * 25 + '         _________', at: [261, cursor-38]
			draw_text '(фамилия)' + ' ' * 34 + '(подпись)', at: [306, cursor-48], size: 7
			draw_text 'по доверенности №______________', at: [261, cursor-70]
			move_down 65
			text "Даю своё согласие на обработку моих персональных\nданных.", style: :bold, size: 7
			move_down 10
			text 'Выдал (доставил) ' + '_' * 25 + ' от  "________"  __________________  20________ г.'
			draw_text '(подпись)', at: [144, cursor-4], size: 7

			line_width  2
			stroke_horizontal_line 0, 459, at: [cursor-10]

			move_down 13
			text 'Служебные отметки:', style: :bold
			draw_text 'Оператор', at: [300, cursor-20], style: :bold
			stroke_vertical_line 0, 770, at: 460
		end

	end

end