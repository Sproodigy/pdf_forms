class Invoice_for_paymentForm < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def fc(num)
    number_with_precision(num, precision: 2, delimiter: ' ')
  end

  def print_invoice_for_payment(num:, date:, line_items:, adress:, tel:, receiver:, account:, bik:,
																corr_account:, inn:, kpp:, bank:, signer:, client:)
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

    line_items_data = []
    total_sum = 0.00
    line_items.each_with_index do |service, index|
      service_sum = service[2]*service[3]
      total_sum += service_sum
      line_items_data << [index+1, service[0], service[1], service[2], fc(service[3]), fc(service_sum)]
    end 

    total_sum_string = (RuPropisju.propisju_int(total_sum.floor) + ' руб. ' +
          ((total_sum-total_sum.floor)*100).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize

    # Заголовок

    #image "app/assets/images/exxtra_logo_web.png", at: [380, 720], width: 150

    text receiver, style: :bold
    move_down 10
    text adress, style: :bold
    move_down 10
    text tel, style: :bold
    move_down 20
    text 'Образец заполнения платёжного поручения', align: :center, style: :bold
    move_down 10

    # Таблица для реквизитов
    table( [
      [{content: "ИНН #{check_inn_length(inn)}", width: 165, inline_format: true},
       {content: "КПП #{check_kpp_length(kpp)}", width: 165},
       {content: ''}, {content: ''}],
      [{content:"Получатель", colspan: 2},
       {content: 'Сч. №', rowspan: 2, valign: :bottom},
       {content: check_account_length(account), rowspan: 2, width: 165, valign: :bottom}],
      [{content: receiver, colspan: 2,width: 310, valign: :bottom}],
      [{content: "Банк получателя", colspan: 2},
       {content:'БИК', width: 40}, {content: check_bik_length(bik), width: 165}],
      [{content: bank, width: 310, valign: :bottom, colspan: 2},
       {content:'Сч. №', valign: :bottom},   
       {content: check_corr_account_length(corr_account), width: 165, valign: :bottom}]
    ], cell_style: { inline_format: true }) do
      row(0).column(2).borders = [:top, :right]
      row(1).column(2).borders = [:bottom, :left]
      row(0).column(3).borders = [:top, :right]
      row(1).column(3).borders = [:bottom, :left, :right]
      row(1).column(0).borders = [:left]
      row(2).column(0).borders = [:left, :right, :bottom]
      row(3).column(0).borders = [:left]
      row(4).column(0).borders = [:left, :right, :bottom]
      row(3).column(3).borders = [:right]
      row(4).column(3).borders = [:bottom, :right]
    end
    move_down 20

    text "Счёт №#{num} от " + I18n.l(date, format: :long), align: :center, style: :bold, size: 14
    move_down 20

    formatted_text [{text:'Покупатель: '}, {text: client, styles: [:bold]} ]
    move_down 20

    # Основная таблица

    data = [ ['№', 'Наименование товара,работ, услуг', 'Ед. изм.', 'Кол-во', 'Цена', 'Сумма'] ] + line_items_data
    table(data, column_widths: [27, 257, 46, 50, 80, 80], cell_style: { inline_format: true }) do |t|
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
      at: [355, cursor-7], width: 100, leading: 10, align: :right, style: :bold

    # Дополнительная таблица

    table ([ ["#{fc(total_sum)}"], ['---'], ["#{fc(total_sum)}"] ]),
      position: :right, column_widths: [80], cell_style: {font_style: :bold, align: :right} do |t|
      t.before_rendering_page do |page|
        page.row(-1).border_bottom_width = 2
        page.column(0).border_left_width = 2
        page.column(-1).border_right_width = 2
      end 
    end 

    move_down 20

    text "Всего наименований #{line_items.size}, на сумму #{fc(total_sum)}"
    move_down 5
    text total_sum_string, style: :bold
    move_down 30

    text "Руководитель предприятия ____________________________________ (#{signer})"
    move_down 20
    text "Главный бухгалтер _____________________________________________ (#{signer})"


    render

  end

private
  def red_if_size_not(str, size)
    if not size.instance_of? Array
      size = [size]
    end

    if size.include? str.size
      str
    else
      "<color rgb='ff0000'>#{str}</color>"
    end
  end

  def check_inn_length(inn)
    red_if_size_not(inn, [10, 12])
  end

  def check_bik_length(bik)
    red_if_size_not(bik, 9)
  end

  def check_kpp_length(kpp)
    red_if_size_not(kpp, 9)
  end

  def check_account_length(account)
    red_if_size_not(account, 20)
  end

  def check_corr_account_length(corr_account)
    red_if_size_not(corr_account, 20)
  end    

end