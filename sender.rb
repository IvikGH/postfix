class Sender
  attr_accessor :jsons

  PACK_SIZE = 10

  def initialize
    @jsons = []
  end

  def process_data(new_jsons=nil)
    if new_jsons
      @jsons += new_jsons
      while @jsons.size >= PACK_SIZE
        result = send(jsons[0,PACK_SIZE])
        @jsons = @jsons.drop(PACK_SIZE) if result
      end
    else
      send(@jsons)
    end
  end

  def send(jsons)
    # p '. . . sending json data'
    # p @jsons
    if true # < < < true подтверждение об успешной доставке
      return true
    else
      false #  < < < true подтверждение о cбое доставки
    end
  end
end
