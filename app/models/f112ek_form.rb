require 'prawn/measurement_extensions'

module RussianPost
  module Forms
    module F112ek
      def print_f112ek_from_mailing(x, y, mailing)
        print_f112ek(x, y,
                     receiver: mailing.company.juridical_title, barcode: mailing.num,
                     receiver_address: mailing.company.cod_address + (mailing.company.espp_client_num.present? ? ', ИФП ' + mailing.company.espp_client_num.to_s : ''),
                     receiver_phone: mailing.company.phone,
                     payment: mailing.payment,
                     sender: mailing.order.name,
                     sender_address: mailing.order.address+ ", " + format_town_address(mailing.order) + ', ' + mailing.order.zip.to_s,
                     sender_phone: mailing.order.phone,
                     espp_client_num: mailing.company.espp_client_num,
                     order_num: mailing.box_number
        )
      end


      def print_f112ek(x, y, payment:, receiver:, receiver_address:, receiver_phone: nil, sender:, sender_address:, sender_phone: nil, barcode:, espp_client_num: nil, order_num: nil)
        font 'DejaVuSans', size: 8
        bounding_box [x, y+210.mm], width: 210.mm, height: 210.mm do

          draw_text 'ф. 112ЭК', at: [186.mm, 201.mm]

          # Logos
          image 'app/assets/pdf/russian_post_blue_logo.png', at: [7.mm, 198.mm], width: 27.mm
          image 'app/assets/pdf/cybermoney.png', at: [6.mm, 205.mm], width: 29.mm

          # Zones
          dash [2,2]
          font_size 10
          transparent(0.3) do
            bounding_box [40.mm, 198.mm], width: 95.mm, height: 38.mm do
              text 'Зона оттиска ККМ', align: :center, valign: :center
              stroke_bounds
            end
            bounding_box [145.mm, 198.mm], width: 40.mm, height: 38.mm do
              stroke_bounds
            end
            bounding_box [7.mm, 115.mm], width: 53.mm, height: 75.mm do
              text 'Зона информации клиента', align: :center, valign: :center
              stroke_bounds
            end
          end
          undash
          font_size 8

          self.line_width = 2
          stroke_rectangle [65.mm, 155.mm], 135.mm, 68.mm
          stroke_horizontal_line 7.mm, 65.mm, at: 155.mm
          dash [10, 3]
          stroke_polygon [7.mm, 4.mm], [7.mm, 34.mm], [65.mm, 34.mm], [65.mm, 83.mm], [200.mm, 83.mm],
                         [200.mm, 19.mm], [165.mm, 19.mm], [165.mm, 4.mm]
          undash
          self.line_width = 1

          # Accept subform
          draw_text 'ПРИЁМ', at: [21.mm, 180.mm], size: 10
          draw_text '№_____________', at: [7.mm, 177.mm], size: 10
          draw_text '(по накладной ф. 16)', at: [10.5.mm, 174.mm], size: 6
          stroke_rectangle [10.mm, 173.mm], 24.mm, 16.mm
          stroke_rectangle [11.mm, 172.mm], 6.mm, 6.mm
          stroke_horizontal_line 18.mm, 33.mm, at: 166.mm
          stroke_horizontal_line 11.mm, 33.mm, at: 160.mm
          draw_text 'Контроль', at: [9.mm, 158.mm], rotate: 90
          draw_text '(дата)', at: [21.mm, 164.mm], size: 6
          draw_text '(подпись)', at: [17.mm, 158.mm], size: 6


          #Client info zone
          if espp_client_num.present?
            transparent(0.5) { text_box "Идентификатор\nФедерального\nПолучателя", at: [18.mm, 152.mm] }
            num = espp_client_num.to_s.rjust(6, '0')
            barc = Barby::Code25Interleaved.new(num)
            barc.include_checksum = false
            barc.annotate_pdf(self, x: 18.mm, y: 130.mm, xdim: 1, height: 30)
            draw_text num, at: [22.5.mm, 126.mm], size: 10
          end

          draw_barcode barcode, x: 10.mm, y: 98.mm

          formatted_text_box [{ text: 'Заказ № ', size: 10}, { text: order_num.to_s, styles: [:bold], size: 10}], at: [40.mm, 204.mm], width: 50.mm, height: 16.mm if order_num.present?



          # Receiver zone
          bounding_box [67.mm, 153.mm], width: 131.mm, height: 64.mm do
            font_size 9
            draw_text "ПОЧТОВЫЙ ПЕРЕВОД на #{fcc(payment)} руб. #{((payment-payment.floor)*100).floor.to_s[0..1].rjust(2, '0')} коп.", at: [0.mm, 61.mm], size: 10
            self.fill_color = 'dddddd'
            fill_rectangle [84.mm, 65.mm], 48.mm, 5.5.mm
            fill_rectangle [0.mm, 59.mm], 132.mm, 5.mm
            self.fill_color = 'ffffff'
            fill_and_stroke_rectangle [85.mm, 64.2.mm], 4.mm, 4.mm
            self.fill_color = '000000'
            draw_text 'НАЛОЖЕННЫЙ ПЛАТЁЖ', at: [90.5.mm, 61.mm], size: 9
            self.line_width = 2
            stroke do
              move_to [85.5.mm, 63.mm]
              line_to [87.mm, 61.mm]
              line_to [88.5.mm, 64.mm]
            end
            self.line_width = 1

            draw_currency_stripe x: 0.mm, y: 59.mm, width: 132.mm, height: 5.mm, value: payment, size: 9

            move_cursor_to 52.mm
            pad(1.mm) { text 'Кому: ' + receiver }
            pad(1.mm) { text 'Куда: ' + receiver_address }
            pad(1.mm) { text 'Телефон: ' + receiver_phone + (receiver_phone.starts_with?('8 800') ? ' (звонок бесплатный)' : '') } if receiver_phone.present?
            pad(1.mm) { text 'Сообщение или идентификатор перевода: ' + barcode.to_s }
            pad(2.mm) { stroke_horizontal_rule }
            pad(1.mm) { text 'От кого: ' + sender }
            pad(1.mm) { text 'Телефон: ' + sender_phone } if sender_phone.present?
            pad(1.mm) { text 'Адрес отправителя: ' + sender_address }
          end

          draw_text 'Обведённое пунктирной линией заполняется отправителем перевода', at: [70.mm, 84.mm], size: 6
          draw_text 'Исправления не допускаются', at: [202.5.mm, 35.mm], rotate: 90, size: 6
          draw_text 'Исправления не допускаются', at: [202.5.mm, 100.mm], rotate: 90, size: 6
          bounding_box [67.mm, 81.mm], width: 131.mm, height: 47.mm do
            text 'Адрес регистрации отправителя:'
            stroke_hand_writing_line to: 110.mm, legend: '(адрес места жительства/регистрации, заполняется при несовпадении с адресом отправителя, а так же до востребования или на а/я)'
            draw_letter_boxes at: [110.mm, cursor], count: 6, legend: '(индекс)'
            move_down 6.mm
            stroke_hand_writing_line
            move_down 5.mm
            draw_text 'Предъявлен:', at: [0.mm, cursor]
            draw_text 'Серия', at: [45.mm, cursor]
            draw_text '№', at: [70.mm, cursor]
            draw_text 'выдан', at: [95.mm, cursor]

            move_down 1.mm
            stroke_hand_writing_line to: 44.mm, legend: '(наименование документа, удостоверяющего личность) '
            stroke_hand_writing_line from: 56.mm, to: 69.mm
            stroke_hand_writing_line from: 74.mm, to: 94.mm
            stroke_hand_writing_line from: 106.mm, legend: '(дата выдачи)'
            move_down 6.mm
            stroke_hand_writing_line to: 89.mm, legend: '(наименование учреждения, выдавшего документ)'
            draw_text 'ИНН', at: [81.mm, cursor-4.mm]
            draw_letter_boxes at: [89.mm, cursor], count: 12, legend: 'ИНН (при его наличии)'
            move_down 6.mm
            stroke_hand_writing_line to: 80.mm, legend: '(код подразделения, при наличии)'
            move_down 6.mm
            draw_text 'Гражданство:', at: [0.mm, cursor]
            draw_text 'Дата рождения:', at: [75.mm, cursor]
            stroke_hand_writing_line from: 24.mm, to: 73.mm
            stroke_hand_writing_line from: 103.mm
            move_down 2.mm
            field_set_box at: [0.mm, cursor], height: 11.mm, legend: '(Дополнительно для нерезидентов России заполняется)'
            move_down 4.mm
            draw_text 'Миграционная карта:  Серия           №                выдана', at: [1.mm, cursor]
            move_down 1.mm
            stroke_hand_writing_line from: 50.mm, to: 60.mm
            stroke_hand_writing_line from: 65.mm, to: 80.mm
            stroke_hand_writing_line from: 94.mm, to: 120.mm, legend: '(дата выдачи)'
            move_down 4.mm
            draw_text 'Срок пребывания с                            по', at: [1.mm, cursor]
            stroke_hand_writing_line from: 34.mm, to: 60.mm
            stroke_hand_writing_line from: 67.mm, to: 93.mm
          end

          # Disclaimers
          text_box 'Являетесь ли Вы должностным лицом публичных международных организаций или лицом, замещающим (занимающим) гос. должности РФ, должности членов Совета директоров Центрального банка РФ, должности федеральной гос. службы, назначение на которые и освобождение от которых осуществляется Президентом РФ или Правительством РФ, должности в Центральном банке РФ, гос. компаниях и иных организациях, созданных РФ на основании Федеральных законов, включенных в перечни должностей, определяемые Президентом РФ? (на основании федерального закона №231-ФЗ от 18 декабря 2006 г.)',
                   at: [9.mm, 32.3.mm], width: 154.mm, size: 6
          stroke_rectangle [165.mm, 32.mm], 4.mm, 4.mm
          stroke_rectangle [178.mm, 32.mm], 4.mm, 4.mm
          draw_text 'Да', at: [170.mm, 29.mm]
          draw_text 'Нет', at: [183.mm, 29.mm]
          stroke_hand_writing_line from: 165.mm, to: 198.mm, at: 22.mm, legend: '(подпись)'
          stroke_horizontal_line 9.mm, 164.mm, at: 19.mm
          text_box "В целях осуществления данного почтового перевода подтверждаю свое согласие:\n- на обработку как автоматизированным, так и неавтоматизированным способом указанных на бланке персональных данных; (Закон №152-ФЗ от 14 июля 2006 г.)\n- на передачу информации о номере почтового перевода, о событии (о перечислении
 почтового перевода на счет получателя, о дате и месте совершения события).",
                   at: [9.mm, 17.5.mm], width: 100.mm, size: 6

          text_box 'Подпись отправителя', at: [103.5.mm, 17.mm], width: 24.mm, style: :bold
          stroke_rectangle [128.mm, 19.mm], 36.mm, 14.mm

          stroke_hand_writing_line from: 170.mm, to: 200.mm, at: 5.mm, legend: '(подпись оператора)'
        end
      end
    end
  end
end
