# encoding: utf-8

class InvoiceForm < Prawn::Document
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
    font "DejaVuSans", size: 10


    text "Накладная №264 от 31 июля 2013 г.", size: 18
    stroke_horizontal_rule


    draw_text "Поставщик:", at: [0, 680]
    draw_text 'ООО "Экстра" 443168, г. Самара', at: [70, 680], style: :bold


    draw_text "Покупатель:", at: [0, 650]
    draw_text 'ООО "Тринити-Групп"', at: [70, 650], style: :bold
    move_down 65
    

    data = [ ["<b>№</b>", "<b>Товар</b>", "Кол-во", "Цена", "Сумма"]] + [["","","","",""]] * 28
    table(data, :column_widths => [30, 230, 70, 80, 80], cell_style: { inline_format: true })

       draw_text "Всего наименований 37, на сумму 62'448.00", at: [0, 40], style: :italic
    draw_text "Шестьдесят две тысячи четыреста сорок восемь рублей 00 копеек", at:[0, 25], style: :italic

    
    draw_text "Итого 62'448.00", at: [450, 85], style: :bold
    draw_text "Без налога (НДС).", at: [440, 70], style: :bold
    draw_text "Всего: 62'448.00", at: [450, 55], style: :bold


    render
  end
  
end