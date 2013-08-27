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

    move_cursor_to 700

    text "АНФ 09/04"


    render

  end

end