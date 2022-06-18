--  Stochastic MACD RSI strategy
--  This indicator provides a graphical output to display momentum movements in the market.

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
    name = 'MoFX',
    short_name = 'MoFX',
    icon = 'indicators:CCI',
    overlay = true
}

input_group {
"BUY",
buy_color = input {default = "lime", type = input.color}
}

input_group {
"SELL",
sell_color = input { default = "orangered", type = input.color },
}



input_group {
    "Stockhastic",
    k_period = input (13, "Stockhastic period K", input.integer, 1),
    d_period = input (3, "Stockhastic period D", input.integer, 1),
    smooth = input (3, "Stockhastic smoothing", input.integer, 1),
    overboughtZone = input (80, "Stockhastic overbought", input.integer, 1),
    oversoldZone = input (20, "Stockhastic oversold", input.integer, 1),
}

input_group {
    "RSI",
    rsi_period = input (14, "RSI period", input.integer, 1),
    buyRegion = input (50, "RSI buy region", input.integer, 1),
    sellRegion = input (50, "RSI sell region", input.integer, 1),
}

input_group {
    "MACD",
    fast = input (12, "MACD fast period", input.integer, 1, 250),
    slow = input (26, "MACD slow period", input.integer, 1, 250),
    signal_period = input (9, "MACD signal period", input.integer, 1, 250),
}

-- ================================================================================================================================
-- ================================================================================================================================


-- ==============  STK ======================
k = sma (stochastic (close, k_period), smooth) * 100
d = sma (k, d_period)

-- if we are in overbought zone then adjust accordingly. and d > overboughtZone
if k > overboughtZone then
    stkIsTop = true
    stkIsSELL = false
    stkIsBottom = false
    stkIsBUY = false
end

-- if we are in oversold zone then adjust accordingly.and d < oversoldZone 
if k < oversoldZone then
    stkIsBottom = true
    stkIsBUY = false
    stkIsTop = false
    stkIsSELL = false
end

-- if we are in overbought zone
if stkIsTop == true then
    -- if we cross down and leave overbought zone
    if k < overboughtZone and d < overboughtZone and k < d then
        -- we are ready to look for a sell opportunity.
        stkIsSELL = true
        stkIsBUY = false
    end
end

-- if are in oversold zone
if stkIsBottom == true then
    -- if we cross up and leave oversold zone
    if k > oversoldZone and d > oversoldZone and k > d then
        -- we are ready to look for a buy opportunity.
        stkIsBUY = true
        stkIsSELL = false
    end
end

if stkIsSELL == true and k > d then
        -- if we are looking for a sell and we have an opposite cross then the signal is canceled.
        -- we can continue looking for a sell since momentum is downwards.
        stkIsSELL = false
        --stkIsTop = false
end

if stkIsBUY == true then
    if k < d then
        -- if we are looking for a buy and we have an opposite cross then the signal is canceled.
        -- we can continue looking for a buy since momentum is upwards.
        stkIsBUY = false
        --stkIsBottom = false
    end
end
---------------------------------------------------------------------

-- ================= RSI ======================
myrsi = rsi(close, rsi_period)

-- If RSI is in the sell Region, the trend is down and we are only interested in sell opportunities.
if myrsi < sellRegion then
     rsiIsSELL = true
     rsiIsBUY = false
end
-- If RSI is in the buy Region, the trend is up and we are only interested in buy opportunities.
if myrsi > buyRegion then
     rsiIsSELL = false
     rsiIsBUY = true
end
---------------------------------------------------------------------


-- ===============  MACD =================
fastMA = ema(close, fast)
slowMA = ema(close, slow)

macd = fastMA - slowMA
signal = ema(macd, signal_period)
histo = macd - signal

-- If we have a cross up then we are ready to buy.
if  macd > signal then -- macd[1] < signal[1] and
        macdIsBUY = true
        macdSELL = false
else
    macdIsBUY = false
end
-- If we have a cross down then we are ready to sell.
if  macd < signal then -- macd[1] > signal[1] and
        macdIsBUY = false
        macdIsSELL = true
else
    macdSELL = false
end
---------------------------------------------------------------------


period = input (200, "front.period", input.integer, 1)
source = input (1, "front.ind.source", input.string_selection, inputs.titles_overlay)

input_group {
    "front.ind.dpo.generalline",
    color = input { default = "#57A1D0", type = input.color },
    width = input { default = 1, type = input.line_width}
}

local sourceSeries = inputs [source]

maSlow = ssma (sourceSeries, period)

if close < maSlow then
    maSlowIsSELL = true
    maSlowIsBUY = false
end
if close > maSlow then
    maSlowIsBUY = true
    maSlowIsSELL = false
end

fEMA = ssma(close, 21)
mEMA = ssma(close, 50)
sEMA = ssma(close, 200)

plot (fEMA, "fEMA", "green", width)
plot (mEMA, "mEMA", "yellow", width)
plot (sEMA, "sEMA", "white", width)

fill(ema(close, 1),sEMA,"Area", close > sEMA and "rgba(34, 139, 34, 0.5)" or close < sEMA and "rgba(220, 20, 60, 0.5)" )

-- If all sell conditions are met then we have a clear signal that a sell opportunity may present itself.
-- We represent this by drawing a sell indicator above the signal candle.
plot_shape(
    (stkIsSELL == true and rsiIsSELL == true and macdIsSELL == true and maSlowIsSELL == true and fEMA < mEMA and mEMA < sEMA) ,
    "Sell",
    shape_style.arrowdown,
    shape_size.normal,
    sell_color,
    shape_location.abovebar,
    0,
    "Sell",
    sell_color
)

if  stkIsSELL == true and rsiIsSELL == true and macdIsSELL == true and maSlowIsSELL == true and fEMA < mEMA and mEMA < sEMA then
    StopLoss = (highest (high, 5)) 
    diff = StopLoss - close[0]
    TakeProfit = close[0] - (diff * 1.5)

    rect {
        first = StopLoss,
        second = close[0],
        name = "myStopLoss",
        color = "rgba(255, 0, 0, 0.25)",
        width = 1
    }

    rect {
        first = close[0],
        second = TakeProfit,
        name = "myTakeProfit",
        color =  "rgba(50, 205, 50, 0.25)",
        width = 1
    }

    -- reset the signal service
    stkIsTop = false
    stkIsBottom = false
    stkIsSELL = false
    stkIsBUY = false
    rsiIsSELL = false
    rsiIsBUY = false
    macdIsSELL = false
    macdIsBUY = false

end


-- If all buy conditions are met then we have a clear signal that a buy opportunity may present itself.
-- We represent this by drawing a buy indicator above the signal candle.
plot_shape(
    (stkIsBUY == true and rsiIsBUY == true and macdIsBUY == true and maSlowIsBUY == true and fEMA > mEMA and mEMA > sEMA) ,
    "Buy",
    shape_style.arrowup,
    shape_size.normal,
    buy_color,
    shape_location.belowbar,
    0,
    "Buy",
    buy_color
)

if stkIsBUY == true and rsiIsBUY == true and macdIsBUY == true and maSlowIsBUY == true and fEMA > mEMA and mEMA > sEMA then

    StopLoss = (lowest (low, 5))
    diff =  close[0] - StopLoss 
    TakeProfit = close[0] + (diff * 1.5)

    rect {
        first = StopLoss,
        second = close[0],
        name = "myStopLoss",
        color = "rgba(255, 0, 0, 0.25)",
        width = 1
    }

    rect {
        first = close[0],
        second = TakeProfit,
        name = "myTakeProfit",
        color =  "rgba(50, 205, 50, 0.25)",
        width = 1
    }

    -- reset the signal service
    stkIsTop = false
    stkIsBottom = false
    stkIsSELL = false
    stkIsBUY = false
    rsiIsSELL = false
    rsiIsBUY = false
    macdIsSELL = false
    macdIsBUY = false
end
