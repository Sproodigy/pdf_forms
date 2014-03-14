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

    text 'ООО "Экстра"', style: :bold
    move_down 10
    text '443068, г. Самара, ул. Ново-Садовая д. 106, корп. 109', style: :bold
    move_down 10
    text 'Тел.: 8-800-100-31-01', style: :bold
    move_down 30
    text 'Образец заполнения платёжного поручения', align: :center, style: :bold

    two_dimensional_array = [ ['БИК'], ['Сч. №'] ]
    table_1 = make_table ([ ['40702810029180000336'],
                            ['042202824
                              30101810200000000824'] ])
    table ([ ['Банк получателя
              ФИЛИАЛ "НИЖЕГОРОДСКИЙ" ОАО "АЛЬФА-БАНК" Г. НИЖНИЙ НОВГОРОД'],
              [table_1] ])


    render

  end

end