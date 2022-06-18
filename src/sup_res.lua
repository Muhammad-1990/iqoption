--  Forex market support and resistance indicator
--  This indicator provides a graphical output to display the most recent support and resistance.

--  Author: Muhammad Ahmod
--  Repo: https://github.com/Muhammad-1990/iqoption

-- Released under MIT License
-- Copyright (c) 2021 Muhammad Ahmod.

-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, 
-- including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Setup indicator 'constructor'
instrument {
    name = 'Support And Resistance',
    icon = 'indicators:MA',
    overlay = true
}

tf = {"1s", "5s", "10s", "15s", "30s", "1m", "2m", "5m", "10m", "15m", "30m", "1H", "2H", "4H", "8H", "12H", "1D", "1W", "1M", "1Y"}
candle_tf1 = input(10, "Support 1 and Resistance 1 ", input.string_selection,tf)
candle_tf2 = input(12, "Support 2 and Resistance 2 ", input.string_selection,tf)

input_group {
   "Support 1",
   colorSupport1 = input { default = "rgba(50, 205, 50, 0.5)", type = input.color },
   widthSupport1 = input { default = 1, type = input.line_width}
}

input_group {
   "Support 2",
   colorSupport2 = input { default = "rgba(50, 205, 50, 0.8)", type = input.color },
   widthSupport2 = input { default = 2, type = input.line_width}
}

input_group {
   "Resistance 1",
   colorResistance1 = input { default = "rgba(255, 0, 0, 0.5)", type = input.color },
   widthResistance1 = input { default = 1, type = input.line_width}
}

input_group {
   "Resistance 2",
   colorResistance2 = input { default = "rgba(255, 0, 0, 0.8)", type = input.color }, 
   widthResistance2 = input { default = 2, type = input.line_width}
}

sec1 = security (current_ticker_id, tf[candle_tf1])
sec2 = security (current_ticker_id, tf[candle_tf2])

sup1 = lowest(sec1.low, 1)
sup2 = lowest(sec2.low, 1)
Res1 = highest(sec1.high, 1)
Res2 = highest(sec2.high, 1)


if sec1 and sec2 then
    if (sec2.close > sec2.open) then
        fill (sec2.close, sec2.high, "Supply1", sec2.high > sec2.close and "rgba(250, 128, 114, 0.1)")
    end
    
    if (sec2.close < sec2.open) then
        fill (sec2.close, sec2.low, "Supply2", sec2.low < sec2.close and "rgba(152, 251, 152, 0.1)")
    end
    
    plot(sup1[0],"Support 1", colorSupport1, widthSupport1,0, style.levels, na_mode.continue)
    plot(sup2[0],"Support 2", colorSupport2, widthSupport2,0, style.levels, na_mode.continue)
    
    plot(Res1[0],"Resistance 1", colorResistance1, widthResistance1,0, style.levels, na_mode.continue)
    plot(Res2[0],"Resistance 2", colorResistance2, widthResistance2,0, style.levels, na_mode.continue)


end
