# encoding: utf-8

class Invoice_for_paymentForm < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def fc(num)
    number_with_precision(num, precision: 2, delimiter: ' ')
  end

  def to_pdf
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

    # Заголовок

    text 'ООО "Экстра"', style: :bold
    move_down 10
    text '443068, г. Самара, ул. Ново-Садовая д. 106, корп. 109', style: :bold
    move_down 10
    text 'Тел.: 8-800-100-31-01', style: :bold
    move_down 30
    text 'Образец заполнения платёжного поручения', align: :center, style: :bold
    move_down 10

    # Таблица для реквизитов
    
    two_dimensional_array_1 = [ [{content:'БИК', width: 40}],
     [{content:'Сч. №', width: 40, height: 33, padding: [17, 0, 0, 5]}] ]
    two_dimensional_array_2 = [ [{content:'042202824', width: 180}],
     [{content:'30101810200000000824', width: 180, height: 33, padding: [17, 0, 0, 5]}] ]

    table ([ 
      [{content: 'ИНН 6316152650', width: 150},
       {content: 'КПП 631601001', width: 150}, 
       {content: 'Сч. №', rowspan: 2, width: 40, padding: [63, 0, 0, 5]},
       {content: '40702810029180000336', rowspan: 2, width: 170, padding: [63, 0, 0, 5]}],
      [{content:"Получатель\n\nООО \"Экстра\"", colspan: 2 }],
      [{content: "Банк получателя\n\nФИЛИАЛ \"НИЖЕГОРОДСКИЙ\" ОАО \"АЛЬФА-БАНК\" Г.НИЖНИЙ НОВГОРОД",
        colspan: 2, width: 170}, two_dimensional_array_1, two_dimensional_array_2] 
    ])
    move_down 20

    text 'СЧЁТ №86 от 07 февраля 2014 г.',
      style: :bold, align: :center, size: 16
    move_down 20

    formatted_text [{text:'Покупатель: '}, {text: 'ООО "Медхелп", ИНН 3662175880/366201001, 394026, г. Воронеж, ул. Варейкиса, 70',
      styles: [:bold]} ]
    move_down 20

    # Основная таблица

    data = [ ['№', 'Наименование товара, работ, услуг', 'Ед. изм.', 'Кол-во', 'Цена', 'Сумма'],
             ['900', 'Каша "Самарский Здоровяк" №54', 'Шт.', '999', '3000', '38909830'] ]
    table(data, column_widths: [27, 240, 46, 50, 80, 80], cell_style: { inline_format: true }) do |t|
      t.row(0).style align: :center, font_style: :bold
      t.column(0).style align: :center
      t.column(3).style align: :right
      t.column(4).style align: :right
      t.column(5).style align: :right
      t.before_rendering_page do |page|
        page.row(0).border_top_width = 2
        page.row(-1).border_bottom_width = 2
        page.column(0).border_left_width = 2
        page.column(-1).border_right_width = 2
       end 
    end

    text_box "Итого:\nБез налога (НДС):\nВсего к оплате:", 
      at: [340, cursor-7], width: 100, leading: 10, align: :right, style: :bold

    # Дополнительная таблица

    table ([ ['32,836.00'], ['---'], ['32,836.00'] ]),
      position: :right, column_widths: [80], cell_style: {font_style: :bold, align: :right} do |t|
      t.before_rendering_page do |page|
        page.row(-1).border_bottom_width = 2
        page.column(0).border_left_width = 2
        page.column(-1).border_right_width = 2
      end 
    end 

    move_down 20

    text 'Всего наименований 28, на сумму 32,836.00 руб.'
    move_down 5
    text 'Тридцать две тысячи восемьсот тридцать шесть рублей 00 копеек', style: :bold
    move_down 30

    text 'Руководитель предприятия ____________________________________ (Афанасьева Марина Васильевна)'
    move_down 20
    text 'Главный бухгалтер _____________________________________________ (Афанасьева Марина Васильевна)'  


    render

  end

end