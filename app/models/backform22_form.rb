require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

class Backform22Form < Prawn::Document

	def to_pdf
		font_families.update(
				'DejaVuSans' => {
						normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
						bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
						italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
						bold_italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf",
						extra_light: "#{Rails.root}/app/assets/fonts/DejaVuSans-ExtraLight.ttf",
						condensed: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed.ttf",
						condensed_bold: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed-Bold.ttf"
				})
		font 'DejaVuSans', size: 10

		draw_backform22(40, 0)

		render

	end

	def draw_backform22(x,y)
		translate(x,y) do

		text_box "<u>Заполняется получателем</u>", style: :bold, inline_format: true
		move_down 24
		text 'Предъявлен _____________ Серия______ №___________ выдан "_____" _____________ 20_____ г.'
		move_down 12
		text 'Кем ' + '_' * 87
		draw_text '(наименование учреждения, выдавшего документ)', at:[140, cursor-4], size: 7
		move_down 12
		text 'Зарегистрирован ' + '_' * 73
		draw_text '(указать при получении почтовых отправлений и денежных переводов,', at:[110, cursor-4], size: 7
		move_down 12
		text '_' * 92
		draw_text 'адресованных "до востребования", на а/я, по месту учёбы,', at:[107, cursor-4], size: 7
		move_down 12
		text '_' * 92
		draw_text 'при несовпадении места регистрации с указанным адресом)', at:[105, cursor-4], size: 7
		text_box 'Почтовое отправление, указанное на лицевой
							стороне извещения, с верным весом, исправными оболочкой, печатями, пломбами, перевязью,
							почтовый перевод получил.',
		          at: [0, cursor-10],	style: :bold, size: 7, width: 210, leading: 5
		draw_text '"_______" ___________________ 20 ______г.', at: [261, cursor-18]
		draw_text '_' * 25 + '         _________', at: [261, cursor-38]
		draw_text '(фамилия)' + ' ' * 34 + '(подпись)', at: [306, cursor-48], size: 7
		draw_text 'по доверенности', at: [261, cursor-62]
		draw_text '№______________', at: [353, cursor-72]
		move_down 65
		text "Даю своё согласие на обработку моих персональных\nданных.", style: :bold, size: 7
		move_down 10
		text 'Выдал (доставил) ' + '_' * 25 + ' от  "________"  __________________  20________ г.'
		draw_text '(подпись)', at: [144, cursor-4], size: 7

		line_width  2
		stroke_horizontal_line 0, 459, at: [cursor-8]

		move_down 11
		text 'Служебные отметки:', style: :bold
		draw_text 'Оператор', at: [300, cursor-20], style: :bold
		stroke_vertical_line 0, 770, at: 460
		end

	end

end