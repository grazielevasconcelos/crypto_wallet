module ApplicationHelper
  def data_para_formato_brasil(data)
    data.strftime('%d/%m/%Y')
  end
end
