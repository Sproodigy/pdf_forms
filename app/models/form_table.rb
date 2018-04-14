require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class FormTable < Prawn::Document

	def prepare_fonts
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

		font_families.update("PostIndex" => { normal: "#{Rails.root}/app/assets/fonts/PostIndex.ttf" })
		font "DejaVuSans", :size => 9
	end

  def data_for_table
    {
     name: 'John',
     lastname: 'Dou',
     age: 38
    }
  end

	def print_form_table()

    person = data_for_table
    data = [ ["Name", "Lastname", "Age"] ]
    data += [ [person[:name], person[:lastname], person[:age]] ]

    table(data, :position => 100, :cell_style => {align: :center}) do |t|

      # t.column.style align: :center, :padding => [12, 0, 0, 1]
      # t.column(1).style align: :center, :padding => [12, 0, 0, 0]
      # t.column(2).style align: :center, :padding => [2, 0, 0, 0]
      # t.column(4).style align: :center, :padding => [17, 0, 0, 0]

      end

		render
  end
end
