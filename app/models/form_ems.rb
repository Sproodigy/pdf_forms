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
      draw_text inscription, at: [x+s+2, y-s]
    end

    def data_box(x, y, width, height, thickness)

      bounding_box([x, y], width: width, height: height) do

        line_width 0.5
        dash([3])
        stroke_vertical_line 330, 0, at: 270
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

        rectangle_and_inscription(7, cursor-155, 5, 'EMS')
        rectangle_and_inscription(38, cursor-155, 5, 'EMS Оптимальное')
        rectangle_and_inscription(113, cursor-155, 5, 'Бизнес Курьер')
        rectangle_and_inscription(180, cursor-155, 5, 'Бизнес Курьер Экспресс')

        rectangle_and_inscription(7, cursor-173, 5, 'Обыкновенное')
        rectangle_and_inscription(73, cursor-173, 5, 'С объявленной ценностью')
        rectangle_and_inscription(176, cursor-173, 5, 'С наложенным платежом')

        stroke do
          horizontal_line 0, 545, at: cursor-180
          horizontal_line 0, 545, at: cursor-208
        end

        text_box "Я подтверждаю, что отправление не содержит предметы, запрещённые к пересылке.
                  С условиями пересылки ознакомлен и согласен. Даю своё согласие на обработку моих персональных данных.
                  В случае объективной невозможности пересылки воздушным транспортом:",
                  at: [7, cursor-182], size: 4.4

        rectangle_and_inscription(7, cursor-200, 5, 'Вернуть по обратному адресу')
        rectangle_and_inscription(145, cursor-200, 5, 'Направить наземным транспортом')



        line_width thickness
        stroke_bounds
      end
    end

    data_box(0, 745, 545, 370, 7)
    # data_box(0, 345, 545, 370, 7)

    render

  end

end
