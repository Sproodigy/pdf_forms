# encoding: utf-8

class InvoiceForm < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def format_currency(value)
    number_with_precision(value, precision: 2, delimiter: ' ')
  end

  def to_pdf(order)
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

    draw_text "Накладная №264 от 31 июля 2013 г.", at: [0, 710], size: 14, style: :bold

    stroke do
        self.line_width = 2
        horizontal_line 0, 540, :at => 705
    end

    move_down 30 

    text"Поставщик:"
    company = order._store.company
    formatted_text_box  [ { text: company.juridical_title, styles: [:bold]}, { text: ", #{company._zip}, #{company.address}, #{company.phone}" }],
              at: [70, 690]          
    move_down 30       

    text "Покупатель:"
    formatted_text_box [ { text: order.name, styles: [:bold]}, { text: ", #{order._zip}, #{order.region}, #{order.town}, #{order.adress}, тел. #{order.telephone}"}], at: [70, 648]

    move_down 45
    
    data = [ ["<b>№</b>", "<b>Товар</b>", "<b>Кол-во</b>", "<b>Цена</b>", "<b>Сумма</b>"]]

    total_quantity = 0
    total_cost = 0
    order.line_items.each_with_index do |li, index|
      data += [[index+1, li.product_title, li.quantity, format_currency(li.price), format_currency(li.quantity*li.price)]]
      total_quantity += li.quantity
      total_cost += li.quantity*li.price
    end

    table(data, :column_widths => [30, 310, 50, 70, 80],
         cell_style: { inline_format: true }) do |t|
      t.cells.border_width = 1
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
 
    text "Итого: #{format_currency(total_cost)} руб.", style: :bold, align: :right
    text "Без налога (НДС)", style: :bold, align: :right
    text "Всего: #{format_currency(total_cost)} руб.", style: :bold, align: :right

    draw_text "Всего наименований #{total_quantity}, на сумму #{format_currency(total_cost)} руб.", at: [0, cursor], style: :italic
    draw_text RuPropisju.rublej(total_cost).mb_chars.capitalize + '.', at:[0, cursor-15], style: :italic
    move_down 40

    draw_text "Отпустил", at: [0, cursor-30]
    draw_text "Получил", at: [285, cursor-30]
    move_down 30


  stroke do

    line_width 1
    horizontal_line 55, 222 , :at => cursor
    horizontal_line 333, 500, :at => cursor

  end

    move_down 7  

    data = "подпись"
    draw_text data, at: [120, cursor], size: 7
    draw_text data, at: [400, cursor], size: 7

    render
    
  end
  
end