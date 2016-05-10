class Invoice_for_paymentForm < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def fc(num)
    number_with_precision(num, precision: 2, delimiter: ' ')
  end

  def print_invoice_for_payment(num:, date:, line_items:, address:, tel:, receiver:, account:, bik:,
																corr_account:, inn:, kpp:, bank:, signer:, contract:, client:)
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


    if client.is_a?(String)

      # Заголовок

      #image "app/assets/images/exxtra_logo_web.png", at: [380, 720], width: 150

      text receiver, style: :bold
      move_down 10
      text address, style: :bold
      move_down 10
      text tel, style: :bold
      move_down 20
      text 'Образец заполнения платёжного поручения', align: :center, style: :bold
      move_down 10

    elsif client.is_a?(Hash)

      formatted_text [ {text: 'ДОГОВОР–СЧЁТ № ' + client[:num] + ' от ' + I18n.l(date, format: :long) } ],
                     style: :bold, align: :center
      move_down 5

      formatted_text  [ {text: '"ПОСТАВЩИК"' + ': ', styles: [:bold]}, {text: receiver + ', ИНН ' + inn},
                        {text: ' в лице директора ' + signer + ', действующего на основании Устава, и'} ]
      move_down 5

      formatted_text  [ {text: '"ПОКУПАТЕЛЬ"' + ': ', styles: [:bold]}, {text: client[:name] + ', '  +
          'в лице директора ' + client[:signer] + ', действующего на основании Устава/доверенности № ' + client [:proxy] +
          ', с другой стороны, заключили настоящий Договор о нижеследующем:'} ]
      move_down 5

      text contract, size: 7, :width => 550
      move_down 5

    else
      raise 'Wrong client value'
    end

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

    if client.is_a?(String)
      text "Счёт №#{num} от " + I18n.l(date, format: :long), align: :center, style: :bold, size: 14
    else

    end

    move_down 15

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

    text_box "Всего наименований #{line_items.size}, на сумму #{fc(total_sum)}\n" + total_sum_string, style: :bold,
             at: [0, cursor-10]

    if client.is_a?(String)

      move_down 40
      text "Руководитель предприятия ____________________________________ (#{signer})"
      move_down 20
      text "Главный бухгалтер _____________________________________________ (#{signer})"

    elsif client.is_a?(Hash)

      move_down 40

      cell_1 = make_cell(:content => "'ПОСТАВЩИК':\n #{receiver}, ИНН  #{inn}, КПП  #{kpp}\n #{tel}\n\n #{address}\n
                               р/с #{account}, БИК  #{bik}\n #{bank}\n к/с #{corr_account}\n
                               Директор ____________  #{signer}\n Гл. бухгалтер ____________  #{signer}\n\n
                               #{I18n.l(date, format: :long)}                                                              М.П.")

      cell_2 = make_cell(:content =>"'ПОКУПАТЕЛЬ':\n #{client[:name]}, ИНН #{client[:inn]}, КПП #{client[:kpp]}\n #{client[:tel]}\n
                               #{client[:address]}\n\n р/с #{client[:account]}, БИК #{client[:bik]}\n #{client[:bank]}\n к/с #{client[:corr_account]}\n\n
                               Директор ____________ #{client[:signer]}\n Гл. бухгалтер ____________  #{client[:signer]}\n\n
                                   #{I18n.l(date, format: :long)}                                                          М.П.")

        table([ [cell_1, cell_2] ], :column_widths => 270) do
          cells.borders = []
        end

      end
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