class Sender
  attr_accessor :jsons

  def initialize
    @jsons = []
  end

  def process(new_jsons)
    @jsons += new_jsons
    while @jsons.size >= 10
      result = send(jsons[0,10])
      @jsons = @jsons.drop(10) if result
    end
  end

  def send(jsons)
    p jsons
    if true # < < < true подтверждение об успешной доставке
      return true
    else
      false #  < < < true подтверждение о cбое доставки
    end
  end
end
