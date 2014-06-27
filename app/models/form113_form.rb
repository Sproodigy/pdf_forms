require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Form113Form < Prawn::Document

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

	def print_f113_from_mailing(x, y, mailing)
		print_form113(x, y,
		barcode: mailing.num,
		order_num: mailing.order.id,
		receiver: mailing.order.name,
		receiver_address: mailing.order.address,
		receiver_index: mailing.order.zip,
		receiver_inn: mailing.company.inn,
		value: mailing.value,
		payment: mailing.payment,
		weight: mailing.weight,
		weight_cost: 615440.00,
		insurance_cost: 510300.00,
		sender: mailing.company.juridical_title,
		sender_address: mailing.company.address,
		sender_index: mailing.company.index)
	end

	def print_form113(x, y, barcode:, order_num:, receiver:, receiver_address:, receiver_inn:, receiver_index:, value:, payment:,
	weight:, weight_cost:, insurance_cost:, sender:, sender_address:, sender_index:)
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

		image "#{Rails.root}/app/assets/pdf/postf113.jpg", at: [0, 595], width: 420


		draw_barcode barcode, x: 15, y: 563

		draw_barcode barcode, x: 80, y: 275, size: :small

		formatted_text_box [{ :text => "Заказ № " }, { :text => order_num.to_s, :styles => [:bold], :size => 10}], :at => [175, 565], :width => 450, :height => 40
		draw_text 'ф.113', at: [375,575], size: 8

		#draw_post_stamp 221, 450#, title: true

		formatted_text_box [{ :text => 'обведенное жирной чертой заполняется отправителем', :styles => [:bold], size: 6 }], :at => [15, 467], :width => 100, :height => 20

		#draw_text "ПОЧТОВЫЙ ПЕРЕВОД наложенного платежа на #{fcc(payment/100)} руб. #{((payment-payment.floor)*100).floor.to_s[0..1].rjust(2, '0')} коп.", at: [23, 437], style: :condensed_bold, size: 10


		bounding_box([21, 433], width: 375, height: 15) do
			draw_text payment/100, style: :condensed_bold, :at => [2,5]
			stroke_bounds
		end

		draw_text '(рубли прописью, копейки цифрами)', at: [135,412], size: 6

		draw_text 'исправления не допускаются', at: [12,316], style: :bold, size: 8, rotate: 90

		formatted_text_box [{text: "Кому: ", :styles => [:bold]},{ :text => receiver.to_s}], :at => [21, 405], :width => 375, :height => 10

		formatted_text_box [{text: "Адрес: ", :styles => [:bold]},{ :text => receiver_address.to_s}], :at => [21, 385], :width => 375, :height => 30

		draw_text "ИНН: #{receiver_inn.to_s}", at: [21,357], size: 8

		formatted_text_box [{ :text => receiver_index.to_s }], :at => [21, 353], size: 8, :width => 255, :height => 40

		draw_text "(шифр и подпись)", at: [325, 310], size: 6

		#formatted_text_box [{ :text => Time.now.strftime("%d.%m.%Y"), :size => 9}], :at => [457, 217], :width => 75, :height => 10

		draw_text "Высылается наложенный платеж", at: [12, 278], size: 9, style: :condensed_bold

		draw_text "Дата _______________________", at: [17, 195]

		formatted_text_box [{text: 'адресован ', :styles => [:bold]}, { :text => sender_address }], :at => [17, 185], :width => 170, :height => 50

		formatted_text_box [{text: 'на имя ', :styles => [:bold]}, { :text => sender }], :at => [17, 135], :width => 170, :height => 30

		draw_text "Отправление выдал", at: [17, 57]

		draw_text "(должность, подпись)", at: [23, 35], size: 6

		draw_text "ИЗВЕЩЕНИЕ", at: [285, 225], size: 10, style: :bold

		formatted_text_box [{ :text => 'о почтовом переводе наложенного платежа №', :styles => [:bold], size: 8 }], :at => [250, 191], :width => 150, :height => 20

		# formatted_text_box [
		# 											 {text: 'На ', :styles => [:bold]},{ :text => fcc(mailing.cod_amount_digit), :styles => [:bold] },
		# 											 {text: ' руб. ', :styles => [:bold]},
		# 											 {text: ((mailing.cod_amount_digit-mailing.cod_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0'), :styles => [:bold]},
		# 											 {text: ' коп.', :styles => [:bold]}
		# 									 ], :at => [225, 155], :width => 300, :height => 10

		formatted_text_box [{text: 'Кому: ', :styles => [:bold]},{ :text => receiver.to_s}], :at => [215, 135], :width => 300, :height => 20

		formatted_text_box [{text: 'Адрес: ', :styles => [:bold]},{ :text => receiver_address.to_s}], :at => [215, 110], :width => 200, :height => 160

		draw_text "Оплата производится по адресу", at: [212, 50], size: 8

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

    base_z = 554
      text_box "Вторичное извещение выписано _________________ 
                Плата за доставку _______________руб.______коп.
                Подлежит оплате ___________________________", 
                :at => [-17, base_z], :height => 100, :width => 145, :leading => 7

      draw_text "О", :at => [120, base_z-25] 
      draw_text "П", :at => [120, base_z-37]
      draw_text "Л", :at => [120, base_z-49]
      draw_text "А", :at => [120, base_z-61]
      draw_text "Т", :at => [120, base_z-73]
      draw_text "А", :at => [120, base_z-85]

      draw_text "(подпись)", :at => [25, base_z-103], :size => 7
      draw_text "РАСПИСКА АДРЕСАТА", :at => [115, base_z-118], :size => 11

    
    bounding_box([-17, base_z-123], :width => 397, :height => 65) do

      self.line_width = 2
      move_down 10
      indent(10) do      
        text "Сумма"
        move_down 20
        text 'Получил "_______" ______________________20_______г.  ______________________________ '
        
        indent(293) do
          text "(подпись)", :size => 7
        end
          
      end

        stroke_bounds
    end

    self.line_width = 1
    stroke_color 50, 50, 50, 10
    6.times do |a|       
        stroke_horizontal_line 30, 370, :at => base_z-128-(3 * a)
    end

    stroke_color 50, 50, 50, 100
      draw_text "Оплатил", :at => [-17, base_z-200]
      stroke_horizontal_line -17, 290, :at => base_z-205
      draw_text "(перечислено)", :at => [-5, base_z-213]
      draw_text "(должность, подпись)",:size => 7, :at => [130, base_z-213]
      draw_text "Отметки о досылке, возвращении и причинах неоплаты",
      :at => [-5, base_z-240]

    3.times do |b|
    stroke do  
      rectangle [300, base_z-205], 60, 60
      horizontal_line -17, 280, :at => base_z-255-(15 * b)
    end
    end

      draw_text "(оттиск календарного", :at => [289, base_z-272], :size => 7
      draw_text "штемпеля ОПС места вр", :at => [285, base_z-280], :size => 7
      draw_text "или дня перечисления)", :at => [287, base_z-288], :size => 7

      stroke_color 50, 50, 50, 10  
      stroke_horizontal_line -17, 130, :at => base_z-300
      stroke_horizontal_line 210, 380, :at => base_z-300
      stroke_vertical_line base_z-307, base_z-400, :at => 190
      stroke_vertical_line base_z-480, base_z-580, :at => 190
      stroke_color 50, 50, 50, 100
      draw_text "л и н и я   о т р е з а", :at => [132, base_z-303],
        :style => :italic, :size => 7
      draw_text "л и н и я   о т р е з а", :at => [190, base_z-477],
        :style => :italic, :size => 7, :rotate => 90

      

      draw_text "Для получения денег заполните извещение и предъя- ",
                :at => [-12, base_z-313], :size => 6
      draw_text "вите паспорт или документ, удостоверяющий личность",
                :at => [-17, base_z-320], :size => 6 

    stroke do
      self.line_width = 2
      move_to -17, base_z-325

      line_to 177, base_z-325
      line_to 177, base_z-529
      line_to 51, base_z-530
      line_to 51, base_z-506
      line_to -17, base_z-506
      line_to -17, base_z-324
      rectangle [203, base_z-315], 177, 260

    end 
  
      self.line_width = 1
      stroke_rectangle [-8, base_z-510], 50, 50

      draw_text "Заполняется адресатом", :at => [-10, base_z-335],
                                         :style => :italic

      text_box 'Предъявлен __________________________ 
                Серия ______ №____________, выданный
                "_____" _______20______г., кем _________
                ________________________________________', 
                :at => [-10, base_z-350], :height => 145,
                :width => 185, :leading => 7

      draw_text "(наименование учреждения выдавшего документ)",
                :at => [-14, base_z-418], :size => 7

      text_box 'Для переводов, адресованных "до востребования",
               на а\я, по месту работы (учёбы), при несовпадении
               прописки или регистрации с указанным адресом,
               укажите адрес и дату прописки или регистрации',
               :at => [-5, base_z-422], :size => 6, :indent_paragraphs => 50

      stroke_horizontal_line -13, 170, :at => base_z-471
      stroke_horizontal_line -13, 170, :at => base_z-491

      draw_text "Адресат________________", :at => [55, base_z-517]
      draw_text "(подпись)", :at => [110, base_z-525], :size => 7

      image "app/assets/images/logo_russian_post.png", at: [207, base_z-319], width: 50

      draw_text "ТАЛОН", :at => [292, base_z-335], :size => 11
      draw_text "к почтовому переводу", :at => [257, base_z-350], :style => :bold
      draw_text "наложенного платежа", :at => [257, base_z-360], :style => :bold
      draw_text "На __________________руб.______коп.",
                :at => [207, base_z-400], :style => :bold
      draw_text "От кого", :at => [207, base_z-440], :style => :bold
      draw_text "Адрес отправителя", :at => [207, base_z-490], :style => :bold

      draw_text "Оплатил ___________________", :at => [50, base_z-560]
      draw_text "(дата, подпись)", :at => [115, base_z-568], :size => 6
      draw_text "(оттиск календ. шт.", :at => [-15, base_z-565], :size => 6
      draw_text "ОПС места", :at => [-2, base_z-572], :size => 6
      draw_text "вручения РПО)", :at => [-8, base_z-579], :size => 6

			render

    end

  end
