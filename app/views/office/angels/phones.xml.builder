xml.instruct! :xml
xml.rows do
  xml.page(@page)
  xml.total(@total_pages)
  xml.records(@count)
  angels.each do |angel|
    xml.row(:id => angel.id) do 
      xml.cell(angel.id)
      xml.cell(angel.first_name)
      xml.cell(angel.last_name)
      xml.cell(angel.email)
      xml.cell(angel.home_phone)
    end
  end
end
