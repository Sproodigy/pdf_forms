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

    draw_text "Накладная №264 от 31 июля 2013 г.", at: [10, 710], size: 14, style: :bold
    
    stroke do
        horizontal_line 0, 540, :at => 705
    end 

    stroke do
        self.line_width = 2
        horizontal_line 0, 540, :at => 705
    end

    draw_text "Поставщик:", at: [0, 680]
    draw_text 'ООО "Экстра" 443168, г. Самара', at: [70, 680], style: :bold

    draw_text "Покупатель:", at: [0, 650]
    draw_text 'ООО "Тринити-Групп"', at: [70, 650], style: :bold
    move_down 100
    
    data = [ ["<b>№</b>", "<b>Товар</b>", "<b>Кол-во", "<b>Цена", "<b>Сумма"]] + [["","","","",""]] * 10
    table(data, :column_widths => [30, 280, 70, 80, 80], cell_style: { inline_format: true }) do |t|
      t.cells.border_width = 1
      t.before_rendering_page do |page|
        page.row(0).border_top_width = 2
        page.row(-1).border_bottom_width = 2
        page.column(0).border_left_width = 2
        page.column(-1).border_right_width = 2

      end

    end

    move_down 20
 
    draw_text "Итого 62'448.00", at: [440, cursor], style: :bold
    draw_text "Без налога (НДС).", at: [430, cursor-15], style: :bold
    draw_text "Всего: 62'448.00", at: [440, cursor-30], style: :bold
    move_down 50

    draw_text "Всего наименований 37, на сумму 62'448.00", at: [0, cursor], style: :italic
    draw_text "Шестьдесят две тысячи четыреста сорок восемь рублей 00 копеек", at:[0, cursor-15], style: :italic
    move_down 40

    draw_text "Отпустил", at: [0, cursor-30]
    draw_text "Получил", at: [285, cursor-30]
    move_down 30


  stroke do

    line_width 1
    horizontal_line 55, 270, :at => cursor
    horizontal_line 333, 540, :at => cursor

  end

    move_down 7  

    a = "подпись"
    draw_text a, at: [150, cursor], size: 7
    draw_text a, at: [420, cursor], size: 7

    render
  end
  
end