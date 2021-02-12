defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    array =  String.split(expr)
    tokens = tagTokens(array)
    postfix = shuntingYard(tokens, [], [])
    output = readExpr(postfix, []) 
    output
  end

  def tagTokens(array) do
    Enum.map(array, fn x ->
    case x do
      "+" -> {:op, "+"}
      "-" -> {:op, "-"}
      "/" -> {:op, "/"}
      "*" -> {:op, "*"}
       _ -> {:num, parse_float(x)}
    end
    end)
  end

  def shuntingYard(tokens, outstack, opstack) do
    if length(tokens) > 0 do
      elem = hd tokens
      bool = "true"
      case elem do
        {:num, x} -> outstack ++ [x]
        {:op, x} -> 
          if length(opstack) == 0 do 
	    opstack ++ [x]
          else
	    top = hd opstack
	    prec = precedence(x) - precedence(top)
            case prec do
              1 -> opstack = [x] ++ opstack
	      0 -> outstack ++ [top]
		   opstack = tl opstack
		   opstack ++ [x]
	      -1 -> opstack ++ [top]
		    opstack = tl opstack
		    bool = "false"
		    shuntingYard(tokens, outstack, opstack)
	      _ -> nil
              end
  	   end
        _ -> nil
      end
      if bool == "true" do
      tail = tl tokens
      shuntingYard(tail, outstack, opstack)
      end
   else 
      outstack ++ opstack
      outstack
   end
 end

 def precedence(x) do
  rank = 0
  if x == "+" or x == "-" do
     rank = 1
  else 
     rank = 2
  end
  rank
 end

 def readExpr(postfix, stack) do
   head = hd postfix
   if head == "+" or head == "-" or head == "/" or head == "*" do
     num1 = hd stack
     stack = tl stack
     num2 = hd stack
     stack = tl stack
     case head do
       "+" -> calculation = num1 + num2
	      stack = [calculation] ++ stack
       "-" -> calculation = num1 - num2
	      stack = [calculation] ++ stack
       "/" -> calculation = num1 / num2
    	      stack = [calculation] ++ stack
       "*" -> calculation = num1 * num2
	      stack = [calculation] ++ stack
       _ -> nil
     end
   else 
     stack = [head] ++ stack
   end
   if length(postfix) > 0 do
     tailPost = tl postfix
     readExpr(tailPost, stack)
   else
     answer = hd stack
     answer
   end
 end
end
