require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Form22Form < Prawn::Document

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
		font 'DejaVuSans', size: 10

		draw_barcode '23892087343890', x: 170, y: cursor, print_rus_post: false

		stroke_rectangle [359, cursor-10], 80, 80

		#draw_post_stamp  x: 200, y: cursor

		draw_text 'ф. 22', at: [440, cursor], size: 7
		draw_text 'ИЗВЕЩЕНИЕ №                1', at:[80, cursor-50]
		draw_text '_____________________', at: [160, cursor-51]
		move_down 60
		text 'Кому     Сорокиной Оксане Александровне'
		draw_text '_' * 61, at: [29, cursor+3]
		move_down 5
		text 'Адрес    г. Новокуйбышевск, ул. Сергея Лазо, д. 328, кв. 389'
		draw_text '_' * 60, at: [34, cursor+3]

		text_box 'На Ваше имя
						поступило                      группа РПО (2 шт.)', at: [0, cursor-1]
		draw_text '_' * 43, at: [120, cursor-22]

		move_down 30
		text 'Откуда  г. Самара, ул. Лейтенанта Шмидта, д. 106, корп. 109'
		draw_text '_' * 59, at: [40, cursor+3]
		move_down 5
		text 'Масса  39 кг'
		draw_text '_' * 59, at: [40, cursor+3]



		text_box '(дата и место
							составления)', at: [378, cursor+56], size: 6

		text_box 'Объявленная ценность       _______________
							Наложенный платёж      __________________
							Плата за доставку          __________________
							Плата за возвр./дост.           ______________
							Тамож. пошлина        _____________________
							Тамож. сбор           ________________________', at: [0, 565], leading: 2

		bounding_box([259, cursor], width: 200, height: 60) do
			indent(10) do
				move_down 2
				text 'Выдача производится по адресу:'
			end
		stroke_bounds
		end

		text_box 'Возможна доставка на дом.                        (услуга платная)
							Вызов курьера по телефону:', at: [233, cursor-2], size: 5

		draw_text 'Извещение доставил '+ '_' * 41, at: [233, cursor-23	], size: 7
		draw_text '(дата, подпись)', at: [360, cursor-30], size: 6

		text_box "<font_size='7'><b>Внимание!</b>   Срок хранения:</font>
							- отправлений разряда Судебное - 7 дней
							- почтовых отправлений и почтовых переводов - 30 дней
							За хранение регистрируемого почтового отправления с адресата
							взимается плата в соответствии с установленными тарифами
							согласно Правилам оказания услуг почтовой связи.",
						 at: [0, cursor-31], inline_format: true, size: 6

		text_box "Для получения почтового отправления, перевода необходимо
							предъявить настоящее извещение и документ удостоверяющий
							личность.
							На извещении предварительно укажите сведения об этом
							документе.",
						 at: [252, cursor-39], inline_format: true, size: 6

		stroke_horizontal_line 0, 500, at: 494.075-23-(11*2.83)

		render

	end

end