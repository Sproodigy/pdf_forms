class ActForm < Prawn::Document
  include ActionView::Helpers::NumberHelper

  FULFILLER = 'Исполнитель'
  CLIENT = 'Заказчик'


  def fc(num)
    number_with_precision(num, precision: 2, delimiter: ' ')
  end

  def print_act(num:,	date:,	fulfiller:, client:, services:, fulfiller_title:,
		fulfiller_signer:,	client_title:, client_signer:)


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

    services_data = []
    total_sum = 0.00
    services.each_with_index do |service, index|
      service_sum = service[1]*service[3]
      total_sum += service_sum
      services_data << [index+1, service[0], service[1], service[2], fc(service[3]), fc(service_sum)]
    end 

    total_sum_string = (RuPropisju.propisju_int(total_sum.floor) + ' руб. ' +
          ((total_sum-total_sum.floor)*100).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize

    # Заголовок

    #image "app/assets/images/exxtra_logo_web.png", at: [430, 742], width: 110

    text "Акт №#{num} от " + I18n.l(date, format: :long), style: :bold, size: 14      

    stroke_horizontal_rule
    move_down 20

    text FULFILLER + ":"

    text_box fulfiller, at: [70, 688], width: 370, heigth: 50, style: :bold
    move_down 30

    text CLIENT + ":"

    text_box client, at: [70, 647], width: 450, heigth: 50, style: :bold
    move_down 30


    # Основная таблица

    data = [ ["№", "Услуга", "Кол-во", "Ед.", "Цена", "Сумма"] ] + services_data
    table(data, :column_widths => [20, 223, 50, 36, 100, 110],
                cell_style: { inline_format: true }) do |t|

      t.row(0).style align: :center, font_style: :bold
      t.column(0).style align: :center
      t.column(2).style align: :right
      t.column(4).style align: :right
      t.column(5).style align: :right
      t.before_rendering_page do |page|
        page.row(0).border_top_width = 2
        page.row(-1).border_bottom_width = 2
        page.column(0).border_left_width = 2
        page.column(-1).border_right_width = 2

      end
    end
    move_down 10

    formatted_text [ {text: "Итого: "}, {text: fc(total_sum), styles: [:bold]} ],
                      align: :right
    move_down 3
    text "Без налога (НДС)", align: :right
    move_down 3
    formatted_text [ {text: "Всего: "}, {text: fc(total_sum), styles: [:bold]} ],
                      align: :right

    move_down 15
    formatted_text [ {text: "Всего оказано услуг на сумму: "}, {text: total_sum_string, styles: [:bold]} ]

    move_down 30
    draw_text FULFILLER, at: [0, cursor], style: :bold
    draw_text CLIENT, at: [280, cursor], style: :bold

    draw_text fulfiller_title, at: [72, cursor-25]
    draw_text fulfiller_signer, at: [92, cursor-55]
    draw_text client_title, at: [345, cursor-25]
    draw_text client_signer, at: [380, cursor-55]

    horizontal_line 0, 200, at: cursor-30
    horizontal_line 280, 480, at: cursor-30
    horizontal_line 0, 200, at: cursor-60
    horizontal_line 280, 480, at: cursor-60
    stroke

    font_size 7
    draw_text "должность", at: [75, cursor-36]
    draw_text "должность", at: [360, cursor-36]
    draw_text "подпись", at: [20, cursor-66]
    draw_text "подпись", at: [300, cursor-66]
    draw_text "расшифровка подписи", at: [90, cursor-66]
    draw_text "расшифровка подписи", at: [370, cursor-66]
    font_size 12
    draw_text "М. П.", at: [85, cursor-86]
    draw_text "М. П.", at: [365, cursor-86]

  end

end