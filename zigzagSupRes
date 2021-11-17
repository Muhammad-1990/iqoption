--  Forex market support and resistance indicator
--  This indicator provides a graphical output to display support and resistance levels.
--
--  Available Configuration:
--      Percentage retrace.

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
    name = 'zigzag support and resistance',
    short_name = 'zigzagSupRes',
    icon = 'indicators:AO',
    overlay = true
}

percentage = input (10, "Percentage", input.double, 0.01, 100, 1.0) / 100

local reference = make_series ()
reference:set(nz(reference[1], highest(high, 21)))

local is_direction_up = make_series ()
is_direction_up:set(nz(is_direction_up[1], true))

local htrack = make_series ()
local ltrack = make_series ()

local pivot = make_series ()

reverse_range = reference * percentage / 100

if get_value (is_direction_up) then
    htrack:set (max(high, nz(htrack[1], high)))

    if close < htrack[1] - reverse_range then
        pivot:set (htrack)
        is_direction_up:set (false)
        reference:set(htrack)
    end
else
    ltrack:set (min(low, nz(ltrack[1], low)))

    if close > ltrack[1] + reverse_range then
        pivot:set (ltrack)
        is_direction_up:set(true)
        reference:set (ltrack)
    end
end

color = is_direction_up() and  up_color or down_color

x = fixnan(pivot)

count = 0

mytable = { 0,0,0,0,0 }

for i=1,1000,1 do
    if x[i] ~= x[i+1] then
        found = false
        for j=1,5,1 do
            if (x[i] < (mytable[j] + 0.0005)) and (x[i] > (mytable[j] - 0.0005)) then
                found = true
            end
        end
        if found ~= true then
              count = count + 1
             table.insert(mytable,count,x[i])
             sr1=mytable[1]
            sr2=mytable[2]
            sr3=mytable[3]
            sr4=mytable[4]
            sr5=mytable[5] 
        end
    end
    if count == 5 then
        break
    end
end


hline(sr1, "aa", "rgba(50, 205, 50, 0.8)", 1)
hline(sr2, "bb", "rgba(50, 205, 50, 0.8)", 1)
hline(sr3, "cc", "rgba(50, 205, 50, 0.8)", 1)
hline(sr4, "dd", "rgba(50, 205, 50, 0.8)", 1)
hline(sr5, "ee", "rgba(50, 205, 50, 0.8)", 1)
