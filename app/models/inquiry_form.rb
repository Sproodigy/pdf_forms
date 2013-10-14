# encoding: utf-8

class InquiryForm < Prawn::Document
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

      stroke_vertical_line 0, 540, :at => 385

      base_z = 530
      draw_text "Форма № МС-42", at: [315, base_z], size: 7
      draw_text "______________________________", at:[0, base_z-10]
      draw_text "(наименование предприятия связи)", at: [10, base_z-20], size: 7
      draw_text "Кассовая справка", at: [140, base_z-35], style: :bold
      draw_text "оператора ____________________________________________", at: [50, base_z-50]
      draw_text "за __________________________ месяц 20     г.", at: [80, base_z-70]
          

    render

  end

end