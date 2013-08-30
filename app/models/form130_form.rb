# encoding: utf-8

class Form130Form < Prawn::Document
  include ActionView::Helpers::NumberHelper


  def to_pdf(opts = {})
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
    font "DejaVuSans", size: 10

    draw_text 'ФГУП "Почта России"', at: [0, 735] 
    draw_text 'УФПС САМАРСКОЙ ОБЛАСТИ', at: [0, 720]
    move_down 7
    text 'Самара-00'
    move_down 3
    text opts[:index], style: :bold
    move_down 3
    text 'Самара-123, ООО "Экстра"'
    move_down 7

    draw_text 'АНФ 09/04', at: [430, 735], size: 8
    draw_text 'Утверждена приказом', at: [430, 725], size: 8
    draw_text 'ФГУП "Почта России"', at: [430, 715], size: 8
    draw_text 'от 24.11.2007 № 582', at: [430, 705], size: 8

    text 'Ежедневный отчёт о движении', align: :center, size: 15
    text 'денежных средств и сумм реализации', align: :center, size: 15
    text 'услуг, материальных ценностей,', align: :center, size: 15
    text 'товаров формы 130', align: :center, size: 15
    move_down 10

    text 'Дата создания отчёта:' + ' ' * 39 + "#{Date.today.strftime('%d.%m.%Y')}"
    move_down 5
    text 'Оператор:' + ' ' * 60 + 'Oper'
    move_down 5

    report_date = opts[:date].present? ? opts[:date] : Date.today
    text 'Отчётный период:' + ' ' * 46 + "#{report_date.strftime('%d.%m.%Y')}"
    move_down 15

    sum = number_to_currency(opts[:sum])
    q = opts[:quantity]

    data = [ ["Код", "Название", "Сумма", "Кол-во"],
              ["1", "Остаток на начало дня", "0,00 р.", "0"],
              ["2", "Доход", sum, q],
              ["2.5", "Посылки", sum, q],
              ["2.5.2", "Безналичными", sum, q],
              ["2.5.2.1", "Организации", sum, q],
              ["2.5.2.1.2", "По авансовым книжкам", sum, q],
              ["2.5.2.1.2.1", "Плата за посылки", sum, q],
              ["2.35", "Итого по разделу 2", sum, q],
              ["2.35.2", "Безналичными", sum, q],
              ["2.35.2.4", "Безналичными", sum, q],
              ["3", "Поступление", "0,00 р.", "0" ],
              ["4", "Расход", "0,00 р.", "0"],
              ["5", "Остаток на конец дня", "0,00 р.", "0"]
            ]
    table(data, :column_widths => [55, 315, 120, 50], 
         cell_style: { inline_format: true }) do |t|
      t.cells.border_width = 1
      t.row(1).style size: 13
      t.row(2).style size: 13
      t.row(3).style size: 10, font_style: :bold
      t.row(4).style size: 10
      t.row(5).style size: 9
      t.row(6).style size: 8
      t.row(7).style size: 8
      t.row(8).style size: 10, font_style: :bold
      t.row(10).style size: 9
      t.row(11).style size: 13
      t.row(12).style size: 13
      t.row(13).style size: 13


      t.column(2).style align: :right
      t.column(3).style align: :right
      t.column(4).style align: :right
      t.before_rendering_page do |page|
        page.row(0).border_top_width = 2
        page.row(-1).border_bottom_width = 2
        page.column(0).border_left_width = 2
        page.column(-1).border_right_width = 2

      end

    end

    move_down 25
    text 'Заполнил:______________________________ / __________________________________________'
    draw_text '(ответственное лицо)', at: [70, cursor-7]
    draw_text 'Ф. И. О.', at: [300, cursor-7]

    move_down 50

    repeat(:all) do
      draw_text "ID: #{opts[:index]}.#{Time.now.strftime('%y%m%d.%H%M%S.%2N')}", :at => bounds.bottom_left
      draw_text "Лист 1 Всего листов 1", at: [bounds.right-150, 0]
    end 

    render

  end

end