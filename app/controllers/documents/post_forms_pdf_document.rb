# encoding: utf-8

require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'


module Documents
  class PostFormsPdfDocument < Prawn::Document
    include ActionView::Helpers::NumberHelper
    include PostFormsFormatHelpers


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

    def draw_barcode(code, opts = {})
      x = opts[:x]
      y = opts[:y]
      size = opts[:size]

      barcode = Barby::Code25Interleaved.new(code)

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

        draw_text "ПОЧТА РОССИИ", at: [x, y+8], size: 8
        formatted_text_box [{ text: barcode_string[0] }, { text: barcode_string[1], styles: [:bold] }, { text: barcode_string[2] }], at: [x+1, y-28], size: 11
      end
    end


    POST_STAMP_SIZE = 80

    def draw_post_stamp(x, y, opts = {})
      translate(x, y) do
        bounding_box([0, 0], width: POST_STAMP_SIZE, height: POST_STAMP_SIZE) do
          stroke_bounds

          date = if opts[:parcel]
                   if opts[:parcel].send_date
                     opts[:parcel].send_date
                   else
                     opts[:parcel].parcel_object.created_at
                   end
                 else
                   opts[:date]
                 end
          zip = opts[:parcel] ? opts[:parcel].parcel_object.company.zip : opts[:zip]

          move_down 5
          if date
            text date.strftime("%d.%m.%Y"), size: 9, align: :center
            if date.in_time_zone("UTC").seconds_since_midnight == 0
              move_down 10
            else
              text date.strftime("%H:%M:%S"), size: 9, align: :center
            end
          end

          if zip
            text zip.to_s, size: 10, align: :center, style: :bold

            post_index = PostIndex.find zip
            if post_index
              text post_index.ops_type_abbr[0..13], size: 9, align: :center
              text_box post_index.ops_name, at: [0, 32], width: POST_STAMP_SIZE, height: 30, size: 8, style: :bold, align: :center, valign: :bottom
            end
          end
        end

        if opts[:title]
          bounding_box [0, -POST_STAMP_SIZE], width: POST_STAMP_SIZE, height: 20 do
            stroke_bounds
            move_down 2
            text "Календ. штемпель ОПС места приёма", size: 7, align: :center
          end
        end
      end
    end


    def print_f2(x, y, parcel, opts = {})
      translate(x, y) do
        draw_text "ф. 2", at: [175, 260]

        draw_barcode(opts[:barcode], x: 30, y: 250)

        text_box opts[:address], at: [30, 200], width: 137

        draw_post_stamp 57, 140, parcel: parcel


        stroke_color 'CCCCCC'
        stroke_rectangle [0, 275], 200, 275
        stroke_color '000000'

        formatted_text_box [{text: "Заказ № "}, {text: opts[:order_id], styles: [:bold]}],
                            at: [30, 45], rotate: 90

        formatted_text_box [{text: "Вес: "}, { text: opts[:weight] + ' кг.', styles: [:bold]}],
                            at: [57, 28]
      end
    end    




    # Принимает simple: true, если посылка обыкновенная
    def print_f7(x, y, parcel, opts = {})
      translate(x, y) do

        self.line_width = 0.5
        stroke_color 'CCCCCC'
        stroke_rectangle [0, 297], 420, 297
        stroke_color '000000'

        draw_text "ф. 7", at: [390, 280], size: 7

        draw_post_stamp 325, 275, parcel: parcel


        draw_barcode(parcel.barcode, x: 15, y: 270)

        draw_text "ПОСЫЛКА", at: [170, 265], style: :bold

        if opts[:simple]
          draw_text "Стандартная", at: [170, 250]
          draw_text "Обыкновенная", at: [170, 240]
        else
          draw_text "С объявленной ценностью", at: [170, 250]
          draw_text "и наложенным платежом", at: [170, 240]
        end

        # AVIA
        if PostIndex.is_avia?(parcel.zip)
          draw_text "АВИА ОТ " + PostIndex.avia_from(parcel.zip), at: [170, 225], style: :bold
        end


        # From
        draw_text "От кого:", at: [15, 220], style: :bold
        str_from = parcel.from_title.to_s + "\n" + parcel.from_addr.to_s + "\n"
        str_from += "тел. " + parcel.from_tel if parcel.from_tel.present?
        text_box str_from, at: [15, 215], width: 300, height: 50


        # Money
        unless opts[:simple]
          self.line_width = 1
          bounding_box([140, 179], width: 265, height: 15) do
            fill_color 'DDDDDD'
            fill_rectangle [0, 15], 265, 15
            fill_color '000000'
            formatted_text_box [ {text: fcc(parcel.decl_amount_digit), styles: [:bold] }, { text: " (" + parcel.decl_amount + ")", styles: [:condensed], size: 8.5 }], at: [3, 11], width: 261, height: 15
            draw_text "(сумма объявленной ценности)", at: [75, -6], size: 7
          end

          bounding_box([140, 154], width: 265, height: 15) do
            fill_color 'DDDDDD'
            fill_rectangle [0, 15], 265, 15
            fill_color '000000'

            formatted_text_box [ {text: fcc(parcel.cod_amount_digit), styles: [:bold] }, { text: " (" + parcel.cod_amount + ")", styles: [:condensed], size: 8.5 }], at: [3, 11], width: 261, height: 15
            draw_text "(сумма наложенного платежа)", at: [75, -6], size: 7
          end
        end


        draw_text "Кому:", at: [140, 123], style: :bold
        bounding_box [140, 118], width: 270, height: 115 do
          text parcel.to_name
          move_down 2
          text parcel.parcel_object.order.address
          move_down 2
          text format_town_address(parcel.parcel_object.order)
          text parcel.parcel_object.order.zip.to_s, size: 12

          move_down 5
          formatted_text_box [{ text: "Реквизиты для перевода наложенного платежа:\n", styles: [:bold], size: 8}, { text: parcel.properties.to_s}], at: [0, cursor], width: 270, height: 60 if !opts[:simple]
        end



        #self.line_width = 0.5
        #stroke { horizontal_line 15, 120, at: 60 }
        #draw_text "(подпись оператора)", at: [28, 53], size: 7

        font "PostIndex"
        draw_text parcel.parcel_object.order.zip.to_s, at: [15, 40], size: 36
        font "DejaVuSans", size: 9


        formatted_text_box [ { text: "Заказ № " }, { text: parcel.order.to_s, styles: [:bold] }],
                  at: [15, 25]




        # Weight and pay
        formatted_text_box [{ text: "Вес: " }, { text: parcel.weight.to_s + " кг.", styles: [:bold] }], at: [15, 140], width: 100
        opts[:simple] ? pay = "Плата: " : pay = "Плата за вес: "
        draw_text pay + number_to_currency(parcel.cost_for_weight), at: [15, 120], width: 100, size: 7
        draw_text "За объяв. цен.: " + number_to_currency(parcel.cost_for_decl), at: [15, 110], width: 100, size: 7 if !opts[:simple]
        draw_text "Всего: " + number_to_currency(parcel.total_delivery_cost), at: [15, 100], width: 100, size: 7 if !opts[:simple]


      end
    end


    def print_f117(x, y, parcel, opts = {})
      translate(x,y) do
        image "#{Rails.root}/app/assets/pdf/postf117.jpg", at: [0,595], width: 420

        # Stroke form bounds
        stroke_color 'dddddd'
        stroke_vertical_line 0, 600, at: 0
        stroke_vertical_line 0, 600, at: 420
        stroke_color '000000'


        draw_barcode(parcel.barcode, x: 18, y: 575)

        opts[:simple] ? form_number = "ф.116" : form_number = "ф.117"
        draw_text form_number, at: [375, 575], size: 8

        formatted_text_box [{text: 'Заказ № '}, { text: parcel.order.to_s, styles: [:bold] }], at: [175, 580]

        draw_text "(по накладной ф.16)", at: [73, 468], size: 6


        draw_post_stamp 226, 549, parcel: parcel, title: true


        draw_barcode(parcel.barcode, x: 285, y: 185, size: :small)

        bounding_box([19, 441], width: 281, height: 16) do
          draw_text parcel.decl_amount, at: [3, 5], style: :condensed_bold if !opts[:simple]
          draw_text "(сумма объявленной ценности)", at: [75, -7], size: 7
          stroke_bounds
        end

        bounding_box([19, 414], width: 281, height: 16) do
          draw_text parcel.cod_amount, at: [3, 5], style: :condensed_bold if !opts[:simple]
          draw_text "(сумма наложенного платежа)", at: [75, -7], size: 7
          stroke_bounds
        end

        formatted_text_box [{text: 'Кому: ', styles: [:bold]}, { text: parcel.to_name }], at: [19, 382], width: 210, height: 20

        formatted_text_box [{text: 'Адрес: ', styles: [:bold]}, { text: parcel.address }], at: [19, 360 ], width: 210, height: 40

        formatted_text_box [{text: 'От кого: ', styles: [:bold]}, { text: parcel.from_title}], at: [19, 310], width: 235, height: 10

        formatted_text_box [{text: 'Адрес: ', styles: [:bold]}, { text: parcel.from_addr.to_s}], at: [19, 295], width: 315, height: 20

        draw_text "Запрещенных к пересылке вложений нет.", at: [19, 250], style: :bold

        draw_text "С требованиями к упаковке ознакомлен _____________________________", at: [19, 240], style: :bold

        draw_text "(подпись отправителя)", at: [255, 233], size: 6


        draw_text 'и с п р а в л е н и я  н е  д о п у с к а ю т с я', at: [11,225], style: :condensed_bold, size: 9, rotate: 90

        formatted_text_box [{text: 'Вес '}, { text: parcel.weight.to_s, styles: [:bold] }, {text: ' кг.'}], at: [312, 438], height: 10

        opts[:simple] ? pay = 'Плата: ' : pay = 'за вес '

        draw_text 'Плата', style: :condensed_bold, at: [312, 415] if !opts[:simple]

        formatted_text_box [{text: pay},{ text: parcel.cost_for_weight.to_s }, {text: ' руб.'}], at: [312, 406], height: 10

        formatted_text_box [{text: 'за о.ц. '},{ text: parcel.cost_for_decl.to_s }, {text: ' руб.'}], at: [312, 388], height: 10 if !opts[:simple]

        formatted_text_box [{text: 'Всего ', styles: [:bold]},{ text: parcel.total_delivery_cost.to_s, styles: [:bold] }, {text: ' руб.'}], at: [312, 370], height: 10 if !opts[:simple]

        draw_text "(подпись оператора)", at: [325, 339], size: 6

        draw_text "Извещение о посылке № _________", at: [58,165]

        draw_text "(по накладной ф.16)", at: [158, 157], size: 6

        formatted_text_box [{text: 'Вес     '}, { text: parcel.weight.to_s, styles: [:bold] }, {text: '     кг.'}], at: [58, 151], width: 150, height: 10

        draw_text "Оттиск календарного штемпеля", at: [232, 141], size: 7
        draw_text "ОПС места приема", at: [255, 134], size: 7

        parcel.decl_amount_digit = 0.0 if opts[:simple]
        parcel.cod_amount_digit = 0.0 if opts[:simple]
        draw_text 'Сумма объявленной', at: [19,115]
        formatted_text_box [{text: 'ценности  '}, { text: fcc(parcel.decl_amount_digit), styles: [:bold] }, {text: ' руб. '}, { text: ((parcel.decl_amount_digit-parcel.decl_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0'), styles: [:bold] }, {text: ' коп.'}], at: [19, 111], width: 280, height: 10

        draw_text 'Сумма наложенного', at: [222,115]
        formatted_text_box [{text: 'платежа  '},{ text: fcc(parcel.cod_amount_digit.floor), styles: [:bold] }, {text: ' руб. '}, { text: ((parcel.cod_amount_digit-parcel.cod_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0'), styles: [:bold] }, {text: '  коп. '}], at: [222, 111], width: 250, height: 10

        formatted_text_box [{text: 'Кому: ', styles: [:bold]}, { text: parcel.to_name }], at: [19, 85], width: 325, height: 40

        formatted_text_box [{text: 'Адрес: ', styles: [:bold]}, { text: parcel.address }], at: [19, 72], width: 325, height: 40

        draw_text 'Обведенное жирной чертой заполняется отправителем', at: [70, 21], style: :condensed_bold

        draw_text 'Извещение доставил ____________________________________________________________', at: [15,12]

        draw_text "(дата и подпись)", at: [159, 5], size: 6
      end
      
    end



    def print_f113(x, y, parcel)
      translate(x,y) do

        image "#{Rails.root}/app/assets/pdf/postf113.jpg", at: [0, 595], width: 420


        draw_barcode(parcel.barcode, x: 15, y: 563)

        draw_barcode(parcel.barcode, x: 80, y: 275, size: :small)

        formatted_text_box [{ :text => "Заказ № " }, { :text => parcel.order.to_s, :styles => [:bold], :size => 10}], :at => [175, 565], :width => 450, :height => 40
        draw_text 'ф.113', at: [375,575], size: 8

        draw_post_stamp 321, 550, title: true

        formatted_text_box [{ :text => 'обведенное жирной чертой заполняется отправителем', :styles => [:bold], size: 6 }], :at => [15, 467], :width => 100, :height => 20

        draw_text "ПОЧТОВЫЙ ПЕРЕВОД наложенного платежа на #{fcc(parcel.cod_amount_digit)} руб. #{((parcel.cod_amount_digit-parcel.cod_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0')} коп.", at: [23, 437], style: :condensed_bold, size: 10


        bounding_box([21, 433], width: 375, height: 15) do
          draw_text parcel.cod_amount, style: :condensed_bold, :at => [2,5]
          stroke_bounds
        end

        draw_text '(рубли прописью, копейки цифрами)', at: [135,412], size: 6

        draw_text 'исправления не допускаются', at: [12,316], style: :bold, size: 8, rotate: 90

        formatted_text_box [{text: "Кому: ", :styles => [:bold]},{ :text => parcel.from_title.to_s}], :at => [21, 405], :width => 375, :height => 10

        formatted_text_box [{text: "Адрес: ", :styles => [:bold]},{ :text => parcel.cod_address.to_s}], :at => [21, 385], :width => 375, :height => 30

        draw_text "ИНН: #{parcel.inn.to_s}", at: [21,357], size: 8

        formatted_text_box [{ :text => parcel.properties.to_s }], :at => [21, 353], size: 8, :width => 255, :height => 40

        draw_text "(шифр и подпись)", at: [325, 310], size: 6

        #formatted_text_box [{ :text => Time.now.strftime("%d.%m.%Y"), :size => 9}], :at => [457, 217], :width => 75, :height => 10

        draw_text "Высылается наложенный платеж", at: [12, 278], size: 9, style: :condensed_bold

        draw_text "Дата _______________________", at: [17, 195]

        formatted_text_box [{text: 'адресован ', :styles => [:bold]}, { :text => parcel.address }], :at => [17, 185], :width => 170, :height => 50

        formatted_text_box [{text: 'на имя ', :styles => [:bold]}, { :text => parcel.to_name }], :at => [17, 135], :width => 170, :height => 30

        draw_text "Отправление выдал", at: [17, 57]

        draw_text "(должность, подпись)", at: [23, 35], size: 6

        draw_text "ИЗВЕЩЕНИЕ", at: [285, 225], size: 10, style: :bold

        formatted_text_box [{ :text => 'о почтовом переводе наложенного платежа №', :styles => [:bold], size: 8 }], :at => [250, 191], :width => 150, :height => 20

        formatted_text_box [
                               {text: 'На ', :styles => [:bold]},{ :text => fcc(parcel.cod_amount_digit), :styles => [:bold] },
                               {text: ' руб. ', :styles => [:bold]},
                               {text: ((parcel.cod_amount_digit-parcel.cod_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0'), :styles => [:bold]},
                               {text: ' коп.', :styles => [:bold]}
                           ], :at => [225, 155], :width => 300, :height => 10

        formatted_text_box [{text: 'Кому: ', :styles => [:bold]},{ :text => parcel.from_title.to_s}], :at => [215, 135], :width => 300, :height => 20

        formatted_text_box [{text: 'Адрес: ', :styles => [:bold]},{ :text => parcel.cod_address.to_s}], :at => [215, 110], :width => 200, :height => 160

        draw_text "Оплата производится по адресу", at: [212, 50], size: 8
      end
    end

    def print_f113_back(x, y)
      translate(x,y) do
        image "#{Rails.root}/app/assets/pdf/postf113back.jpg", at: [0, 595], width: 420
      end
    end

    def print_f116_back(x, y)
      translate(x,y) do
        image "#{Rails.root}/app/assets/pdf/postf117back.jpg", at: [0, 595], width: 420
      end
    end

    def print_f117_back(x, y)
      translate(x,y) do
        image "#{Rails.root}/app/assets/pdf/postf117back.jpg", at: [0, 595], width: 420
      end
    end

  end
end