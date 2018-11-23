# encoding: utf-8

class FormEMS < Prawn::Document
  def print_form_ems
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
    font "DejaVuSans", size: 6

    # stroke_axis(at: [0, -10], step_length: 20, color: '009900')

    dash([5])
    line_width 3
    stroke_horizontal_line -10, 570, at: 360
    undash

    def rectangle_and_inscription(x, y, s, inscription)
      stroke_rectangle [x, y], s, s
      draw_text inscription, at: [x+s+1, y-s]
    end

    def underline_text(x, y, length, text)
      text_box '_' * length + "\n" + text, at: [x, y], size: 4, align: :center
    end

    def data_box(x, y, width, height, thickness)

      bounding_box([x, y], width: width, height: height) do

        line_width 0.5
        dash([3])
        stroke_vertical_line 330, 155, at: 270
        stroke_vertical_line 124, 0, at: 270
        undash

        move_cursor_to 363
        image "app/assets/images/logo_ems_russian_post.png", at: [10, cursor], scale: 0.4

        move_cursor_to 335
        draw_text '8 800 200-50-55 • www.emspost.ru', at: [35, cursor]
        draw_text  "ОТ КОГО", at: [7, cursor-20], size: 12, style: :bold
        formatted_text_box [ { text: 'ФИО или наименование организации ' + '_' * 47 + "\n" },
                             { text: "_" * 87 + "\n" },
                             { text: 'Мобильный телефон ' + '_' * 32 + "\n" },
                             { text: 'Адрес ' + '_' * 80 + "\n" },
                             { text: "_" * 87 + "\n" },
                             { text: "_" * 87 + "\n" },
                             { text: "_" * 50 + ' Индекс ' + '_' * 28 + "\n" }
                           ], at: [7, cursor-27], leading: 5

        text_box "ОПИСАНИЕ ОТПРАВЛЕНИЯ", at: [0, cursor-110], size: 8, style: :bold, width: 270, align: :center

        text_box 'Описание содержимого ' + '_' * 61 + "\n" + 'Особые отметки ' + '_' * 69,
                  at: [7, cursor-125], leading: 5

        text_box "ВИД ОТПРАВЛЕНИЯ\n" + 'КАТЕГОРИЯ ОТПРАВЛЕНИЯ',
                  at: [0, cursor-145], size: 8, style: :bold, width: 270, align: :center, leading: 8

        rectangle_and_inscription(7, cursor-155, 4, 'EMS')
        rectangle_and_inscription(38, cursor-155, 4, 'EMS Оптимальное')
        rectangle_and_inscription(113, cursor-155, 4, 'Бизнес Курьер')
        rectangle_and_inscription(180, cursor-155, 4, 'Бизнес Курьер Экспресс')

        rectangle_and_inscription(7, cursor-173, 4, 'Обыкновенное')
        rectangle_and_inscription(73, cursor-173, 4, 'С объявленной ценностью')
        rectangle_and_inscription(176, cursor-173, 4, 'С наложенным платежом')

        stroke do
          horizontal_line 0, 545, at: cursor-180
          horizontal_line 0, 545, at: cursor-208
        end

        text_box "Я подтверждаю, что отправление не содержит предметы, запрещённые к пересылке.
                  С условиями пересылки ознакомлен и согласен. Даю своё согласие на обработку моих персональных данных.
                  В случае объективной невозможности пересылки воздушным транспортом:",
                  at: [7, cursor-182], size: 4.4

        rectangle_and_inscription(7, cursor-200, 4, 'Вернуть по обратному адресу')
        rectangle_and_inscription(145, cursor-200, 4, 'Направить наземным транспортом')

        draw_text 'ИНФОРМАЦИЯ ПО ПРИЁМУ', at: [70, cursor-217], size: 8, style: :bold

        formatted_text_box [ {text: 'Отправление принято: ' + "\n", styles: [:bold]},
                             {text: 'Почтовый индекс места приёма ' + "\n"},
                             {text: 'Фактическая масса ' + "\n"},
                             {text: 'Стоимость отправления, руб.: ' + "\n", styles: [:bold]},
                             {text: 'Тариф за пересылку ' + '_' * 64 + "\n"},
                             {text: 'Доп. тариф, прочие услуги ' + '_' * 57 + "\n"},
                             {text: 'Тариф за СМС-уведомление ' + '_' * 56 + "\n"},
                             {text: 'Тариф за объявленную ценность ' + '_' * 50 + "\n"},
                             {text: 'ИТОГО К ОПЛАТЕ (включая НДС) ' + '_' * 47 + "\n", styles: [:bold]},
                             {text: 'Дата приёма ' + '__________ __________ __________' + '        Время приёма ' + '_________ : _________' + "\n"},
                             {text: 'ФИО служащего ' + '_' * 23 + '    Подпись служащего ' + '_' * 20}
        ], at: [7, cursor-220], leading: 3.3


        move_cursor_to 335
        draw_text  "КОМУ", at: [277, cursor-20], size: 12, style: :bold
        formatted_text_box [ { text: 'ФИО или наименование организации ' + '_' * 47 + "\n" },
                             { text: "_" * 87 + "\n" },
                             { text: 'Мобильный телефон ' + '_' * 32 + "\n" },
                             { text: 'Адрес ' + '_' * 80 + "\n" },
                             { text: "_" * 87 + "\n" },
                             { text: "_" * 87 + "\n" },
                             { text: "_" * 50 + ' Индекс ' + '_' * 28 + "\n" }
                           ], at: [277, cursor-27], leading: 5

          draw_text 'Возможность принять отправление получателем в:', at: [277, cursor-113]
          rectangle_and_inscription(287, cursor-120, 4, 'Субботу')
          rectangle_and_inscription(327, cursor-120, 4, 'Воскресенье и праздничные дни')
          underline_text(430, cursor- 122, 48, 'укажите дни и время работы')
          text_box "ФОРМА ОПЛАТЫ", at: [277, cursor-132], size: 8, style: :bold, width: 255, align: :center
          rectangle_and_inscription(287, cursor-141, 4, 'Отправителем')
          rectangle_and_inscription(347, cursor-141, 4, 'Получателем')
          rectangle_and_inscription(403, cursor-141, 4, 'По договору № ' + '17-2.2/222')
          formatted_text_box [ { text: 'Объявленная ценность: ' + ' 2048 руб.' + "\n" },
                               { text: 'прописью две тысячи сорок восемь рублей', size: 5 }
                             ], at: [277, cursor-150], leading: 0.5
           formatted_text_box [ { text: 'Наложенный платёж: ' + ' 2048 руб.' + "\n" },
                                { text: 'прописью две тысячи сорок восемь рублей', size: 5 }
                              ], at: [277, cursor-167], leading: 0.5
            draw_text 'Подпись отправителя: ' + 'ООО "Экстра"', at: [277, cursor-198], size: 8
            text_box "ИНФОРМАЦИЯ О ДОСТАВКЕ", at: [277, cursor-211], size: 8, style: :bold, width: 255, align: :center

            draw_text 'Доставка: ', at: [277, cursor-225], style: :bold
            rectangle_and_inscription(279, cursor-228, 4, 'Доставлено')
            rectangle_and_inscription(326, cursor-228, 4, 'Неверный адрес')
            rectangle_and_inscription(388, cursor-228, 4, 'Нет адресата')
            rectangle_and_inscription(441, cursor-228, 4, 'Отказ от получения')
            rectangle_and_inscription(514, cursor-228, 4, 'Иное')

            draw_text 'Вручение в окне приёма: ', at: [277, cursor-242], style: :bold
            rectangle_and_inscription(279, cursor-245, 4, 'Вручено')
            rectangle_and_inscription(315, cursor-245, 4, 'Отказ от получения')

            rectangle_and_inscription(277, cursor-253, 4, '')
            draw_text 'Возврат', at: [283, cursor-259], style: :bold
            draw_text 'Дата ' + '22.11.2018   ' + 'Время ' + '12:30', at: [313, cursor-259]
            formatted_text_box [ {text: 'Предъявлен: ', size: 8},
                                 {text: underline_text(cursor-152, cursor-278, 30, 'наименование документа')}
                               ], at: [277, cursor-275]
            draw_text 'Выдан: ' + '_____ _____ _____' + 'Кем выдан: ' + underline_text(cursor+48, cursor-293, 73, 'наименование и код учреждения, выдавшего документ'),
              at: [277, cursor-294]
            text_box 'Зарегистрирован: ' + '_' * 66, at: [277, cursor-305], width: 260
            text_box 'ФИО получателя: ' + '_' * 30 + '  Подпись получателя: ' + '_' * 13, at: [277, cursor-316], width: 260

            draw_text 'Даю своё согласие на обработку моих персональных данных.', at: [277, cursor-329], size: 8



          # draw_text '_' * 28, at: [437, cursor-125]

        line_width thickness
        stroke_bounds
      end
    end

    data_box(0, 745, 545, 370, 7)
    # data_box(0, 345, 545, 370, 7)

    render

  end

end
