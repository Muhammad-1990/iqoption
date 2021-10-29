--  Engulfing Pattern indicator
--  This indicator provides a graphical output to display engulfing candles and a three line strike entry point.
--
--  Available Configuration:
--      Moving Averages period
--      RSI period
--      Color scheme.
--      Visibility

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
    name = 'Engulfing pattern',
    short_name = 'EngulfPattern',
    icon = 'indicators:Fractal',
    overlay = true
}

input_group {
    "BUY",
    buy_color = input {default = "lime", type = input.color}
}
    
input_group {
    "SELL",
    sell_color = input { default = "red", type = input.color },
}

input_group {
    "RSI",
    rsi_period = input (14, "RSI period", input.integer, 1),
    buyRegionRSI = input (50, "RSI buy region", input.integer, 1),
    sellRegionRSI = input (50, "RSI sell region", input.integer, 1),
}

input_group {
    "Fast",
    fast = input (21, "MA", input.integer, 1, 200),
    Show_fast = input { default = true, type = input.plot_visibility },
}
input_group {
    "Medium",
    medium = input (50, "MA", input.integer, 1, 200),
    Show_medium = input { default = true, type = input.plot_visibility },
}
input_group {
    "Slow",
    slow = input (200, "MA", input.integer, 1, 200),
    Show_slow = input { default = true, type = input.plot_visibility },
}
input_group {
    "Trend fill",
    trend_Fill = input { default = true, type = input.plot_visibility },
}

RSI = rsi(close, rsi_period)

fastSSMA = ssma(close, fast)
mediumSSMA = ssma(close, medium)
slowSSMA = ssma(close, slow)

if Show_fast == true then
    plot (fastSSMA, "fastSSMA", "white", 1)
end

if Show_medium == true then
    plot (mediumSSMA, "mediumSSMA", "lime", 1)
end

if Show_slow == true then
    plot (slowSSMA, "slowSSMA", "red", 3)
end

-- Check that moving averages are alinged to represent a uptrend.
upTrend =  conditional((fastSSMA > mediumSSMA) and (mediumSSMA > slowSSMA) and (RSI > buyRegionRSI))
-- Check that moving averages are alinged to represent a downtrend.
downTrend = conditional((fastSSMA < mediumSSMA) and (mediumSSMA < slowSSMA) and (RSI < sellRegionRSI))

-- Check if current candle is green and previous is red and current is bigger than previous.
bulishEngulfing     = conditional((close[0] > open[0]) and (close[1] < open[1]) and (abs(close[0]-open[0]) > abs(open[1] - close[1])))
-- Check if current candle is red and previous is grenn and current is bigger than previous.
bearishEngulfing    = conditional((close[0] < open[0]) and (close[1] > open[1]) and (abs(open[0] - close[0]) > abs(close[1]-open[1])))

-- Check if current candle is green and previous 3 is red and current is bigger than previous.
bulishThreeLineStrike   = conditional(close[3] < open[3] and close[2] < open[2] and close[1] < open[1] and close > open and abs(close - open) > abs(open[1] - close[1]))
-- Check if current candle is red and previous 3 is green and current is bigger than previous.
bearishThreeLineStrike  = conditional(close[3] > open[3] and close[2] > open[2] and close[1] > open[1] and close < open and abs(open - close) > abs(close[1] - open[1]))

-- Output if we have a bulish engulfing in uptrend.
plot_shape((upTrend[0] and bulishEngulfing)
            ,"BuyEng"
            ,shape_style.triangleup
            ,shape_size.tiny
            ,buy_color
            ,shape_location.belowbar
            ,0
            ,""
            ,buy_color 
) 

-- Output if we have a bearish engulfing in downtrend.
plot_shape((downTrend[0] and bearishEngulfing)
           ,"SellEng"
           ,shape_style.triangledown 
           ,shape_size.tiny 
           ,sell_color
           ,shape_location.abovebar
           ,0
           ,""
           ,sell_color
)

-- Output if we have a 3 line strike in uptrend.
plot_shape((upTrend[0] and bulishThreeLineStrike)
            ,"Buy3LS"
            ,shape_style.triangleup
            ,shape_size.normal 
            ,buy_color
            ,shape_location.belowbar
            ,0
            ,""
            ,buy_color 
) 

-- Output if we have a 3 line strike in downtrend.
plot_shape((downTrend[0] and bearishThreeLineStrike)
        ,"Sell3LS"
        ,shape_style.triangledown 
        ,shape_size.normal 
        ,sell_color
        ,shape_location.abovebar
        ,0
        ,""
        ,sell_color
) 

-- Check if user is displaying trend fill option
if trend_Fill == true then
    -- Fill trend from 1 period down to slow period.
    fill(sma(close, 1),slowSSMA,"Area", close > slowSSMA and "rgba(34, 139, 34, 0.25)" or close < slowSSMA and "rgba(220, 20, 60, 0.25)" )
end
