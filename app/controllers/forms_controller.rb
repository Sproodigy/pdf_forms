class FormsController < ApplicationController
  def invoice
    pdf = InvoiceForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'invoice.pdf', disposition: 'inline'
  end

  def test
    pdf = TestForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'test.pdf', disposition: 'inline'
  end

  def work
    pdf = WorkForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'work.pdf', disposition: 'inline'
  end
end
