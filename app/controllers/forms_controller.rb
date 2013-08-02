class FormsController < ApplicationController
  def invoice
    pdf = InvoiceForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'invoice.pdf', disposition: 'inline'
  end
end
