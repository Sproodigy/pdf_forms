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

    text 'ФГУП "Почта России"' 
    move_down 15
    text 'УФПС САМАРСКОЙ ОБЛАСТИ'
    move_down 15
    text 'Самара-00'
    move_down 15
    text opts[:index], style: :bold
    move_down 15
    text 'Самара-218'

    draw_text 'АНФ 09/04', at: [430, 712]
    draw_text 'Утверждена приказом', at: [430, 700]
    draw_text 'ФГУП "Почта России', at: [430, 688]
    draw_text 'от 24.11.2007 № 582', at: [430, 676]

    text 'Ежедневный отчёт о движении', align: :center, size: 15
    text 'денежных средств и сумм реализации', align: :center, size: 15
    text 'услуг, материальных ценностей,', align: :center, size: 15
    text 'товаров формы 130', align: :center, size: 15
    move_down 10

    text 'Дата создания отчёта:' + ' ' * 39 + "#{Date.current}"
    move_down 15
    text 'Оператор:' + ' ' * 60 + 'Oper'
    move_down 15
    text 'Отчётный период:' + ' ' * 46 + "#{Date.current}"
    move_down 10

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
            ]
    table(data, :column_widths => [60, 330, 100, 50], 
         cell_style: { inline_format: true }) do |t|
      t.cells.border_width = 1
      t.row(1).style size: 14
      t.row(2).style size: 14
      t.row(3).style size: 10, font_style: :bold
      t.row(4).style size: 10
      t.row(5).style size: 10
      t.row(6).style size: 8
      t.row(7).style size: 8


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

    move_down 10
    text 'Заполнил:______________________________ / _______________________________________'
    draw_text '(ответственное лицо)', at: [70, cursor-7]
    draw_text 'Ф. И. О.', at: [265, cursor-7]

    render

  end

end