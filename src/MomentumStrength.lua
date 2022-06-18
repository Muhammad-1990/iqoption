--  Forex market MomentumStrength indicator
--  This indicator provides a graphical output to display the momentum strength.

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
    name = 'MomentumStrength',
    short_name = 'MomentumStrength',
    icon = 'indicators:AO',
    overlay = false
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
    "MACD",
    fast = input (8, "MACD fast period", input.integer, 1, 250),
    slow = input (13, "MACD slow period", input.integer, 1, 250),
    signal_period = input (5, "MACD signal period", input.integer, 1, 250),
}

input_group {
    "Stockhastic",
    k_period = input (10, "Stockhastic period K", input.integer, 1),
    d_period = input (3, "Stockhastic period D", input.integer, 1),
    smooth = input (3, "Stockhastic smoothing", input.integer, 1),
    overboughtZone = input (80, "Stockhastic overbought", input.integer, 1),
    oversoldZone = input (20, "Stockhastic oversold", input.integer, 1),
}

fastSSMA = ssma(close, 21)
mediumSSMA = ssma(close, 50)
slowSSMA = ssma(close, 200)
RSI = rsi(close, 21)

-- ===============  MACD =================
fastMA = ema(close, fast)
slowMA = ema(close, slow)

macd = fastMA - slowMA
signal = ema(macd, signal_period)
histo = macd - signal

-- If we have a cross up then we are ready to buy.
if  macd > signal then
        macdIsBUY = true
        macdIsSELL = false
else
    macdIsBUY = false
end
-- If we have a cross down then we are ready to sell.
if  macd < signal then
        macdIsBUY = false
        macdIsSELL = true
else
    macdIsSELL = false
end
---------------------------------------------------------------------

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

Weight = 1

UPscore = 0
DOWNscore = 0

---------------------------------------------------------------------

if close[0] > fastSSMA then UPscore = UPscore + Weight end
if close[0] < fastSSMA then DOWNscore = DOWNscore - Weight end

if close[0] > mediumSSMA then UPscore = UPscore + Weight end
if close[0] < mediumSSMA then DOWNscore = DOWNscore - Weight end

if close[0] > slowSSMA then UPscore = UPscore + Weight end
if close[0] < slowSSMA then DOWNscore = DOWNscore - Weight end

if fastSSMA > mediumSSMA then UPscore = UPscore + Weight end
if fastSSMA < mediumSSMA then DOWNscore = DOWNscore - Weight end

if mediumSSMA > slowSSMA then UPscore = UPscore + Weight end
if mediumSSMA < slowSSMA then DOWNscore = DOWNscore - Weight end

if RSI > 50 then UPscore = UPscore + Weight end
if RSI < 50 then DOWNscore = DOWNscore - Weight end

if stkIsBUY == true  then UPscore = UPscore + Weight end
if stkIsSELL == true  then DOWNscore = DOWNscore - Weight end

if macdIsBUY == true  then UPscore = UPscore + Weight end
if macdIsSELL == true  then DOWNscore = DOWNscore - Weight end

--------------------------- Histogram spacer ---------------------------------------------
rect {
    first = 0,
    second = -0.1,
    name = "spacer",
    color =  "rgba(50, 205, 50, 0)",
    width = 0.5
}
------------------------------------------------------------------------------------------

PowerScale = (Weight * 8)
PowerScalePercent = 0.85 * PowerScale

if (DOWNscore <= -PowerScalePercent) then
    rect {
        first = 0,
        second = 0.025,
        name = "DOWNscore",
        color = "rgba(255, 0, 0, 1)",
        width = 0.5
    }
end

if (UPscore >= PowerScalePercent) then
    rect {
        first = 0,
        second = 0.025,
        name = "UPscore",
        color =  "rgba(50, 205, 50, 1)",
        width = 0.5
    }
end
