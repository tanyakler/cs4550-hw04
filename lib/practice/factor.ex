defmodule Practice.Factor do
  
  
  def factor(x) do 

    facthelper(x, 2, [])
  end
  
  def facthelper(num, currf, factarray) do
    if num > 1 do
      if rem(trunc(num), currf) == 0 do
        facthelper(num / currf, currf, [currf | factarray])
      else
        facthelper(num, currf + 1, factarray)
      end
    else
      factarray |> Enum.reverse()
    end

  end

end
