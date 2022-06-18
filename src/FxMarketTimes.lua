--  Forex market trading times indicator
--  This indicator provides a graphical output to display the forex markets trading sessions.
--
--  Available Configuration:
--      Market trading times.
--      Market visibility.
--      Color scheme.

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
    name = 'Forex Market Times',
    short_name = 'FXmarketTimes',
    icon = 'indicators:AO',
    overlay = false
}

-- Here we define our 2400hr clock
tf = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "0"}

-- User and default configuration settings related to the Sydney Forex market session.
input_group {
    "Sydney",
    -- Indicates if the Sydney Session should be displayed in the indicator window.
    Sydney_Visible = input { default = false, type = input.plot_visibility },
    -- Sydney Session indication color.
    Sydney_Color = input {default = "#e9eaeb", type = input.color },
    -- Sydney Session market open time.
    Sydney_Open = input(23,"Sydney open", input.string_selection,tf),
    -- Sydney Session market close time.
    Sydney_Close = input(8,"Sydney close", input.string_selection,tf)
}

-- User and default configuration settings related to the Tokyo Forex market session.
input_group {
    "Tokyo",
    -- Indicates if the Tokyo Session should be displayed in the indicator window.
    Tokyo_Visible = input { default = false, type = input.plot_visibility },
    -- Tokyo Session indication color.
    Tokyo_Color = input {default = "#a02de4", type = input.color },
    -- Tokyo Session market open time.
    Tokyo_Open = input(1,"Tokyo open", input.string_selection,tf),
    -- Tokyo Session market close time.
    Tokyo_Close = input(10,"Tokyo close", input.string_selection,tf)
}

-- User and default configuration settings related to the London Forex market session.
input_group {
    "London",
    -- Indicates if the London Session should be displayed in the indicator window.
    London_Visible = input { default = false, type = input.plot_visibility },
    -- London Session indication color.
    London_Color = input {default = "#248cd5", type = input.color },
    -- London Session market open time.
    London_Open = input(9,"London open", input.string_selection,tf),
    -- London Session market close time.
    London_Close = input(18,"London close", input.string_selection,tf)
}

-- User and default configuration settings related to the New York Forex market session.
input_group {
    "New York",
    -- Indicates if the New York Session should be displayed in the indicator window.
    NewYork_Visible = input { default = false, type = input.plot_visibility },
    -- New York Session indication color.
    NewYork_Color = input {default = "#3ebe8f", type = input.color },
    -- New York Session market open time.
    NewYork_Open = input(14,"New York open", input.string_selection,tf),
    -- New York Session market close time.
    NewYork_Close = input(23,"New York close", input.string_selection,tf)
}

-- User and default configuration settings related to preferred Forex market session.
input_group {
    "Preferred",
    -- Indicates if the Preferred Session should be displayed in the indicator window.
    Preferred_Visible = input { default = true, type = input.plot_visibility },
    -- Preferred Session indication color.
    Preferred_Color = input {default = "#3ebe8f", type = input.color },
    -- Preferred Session market open time.
    Preferred_Open = input(8,"Preferred open", input.string_selection,tf),
    -- Preferred Session market close time.
    Preferred_Close = input(14,"Preferred close", input.string_selection,tf)
}

-- histogram gap size that increments according to which sessions are visible so that we dont get an ugly gap between sessions.
size = 0

-- We check if our current candle in question has a valid open_time value
if (open_time ~= nil) then

    --------------------- Sydney session ----------------------------------------
    -- We first check if the user wants to display the Sydney session trading time.
    if Sydney_Visible == true then
        -- Trading sessions might overlap two different date days in most users timezones.
        -- We therefore need to check if our closing hour is less than the opening hour.
        if Sydney_Close < Sydney_Open then
            if (hour >= Sydney_Open and hour < 24) or ( hour >= 0 and hour < Sydney_Close) then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = Sydney_Color,
                    width = 0.5
                }
            end
        else
            if hour >= Sydney_Open and hour < Sydney_Close then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = Sydney_Color,
                    width = 0.5
                }
            end
        end
        size = size + 0.2
    end
    ------------------------------------------------------------------------------

    --------------------- Tokyo session ------------------------------------------
    -- We first check if the user wants to display the Tokyo session trading time.
    if Tokyo_Visible == true then
        -- Trading sessions might overlap two different date days in most users timezones.
        -- We therefore need to check if our closing hour is less than the opening hour.
        if Tokyo_Close < Tokyo_Open then
            if (hour >= Tokyo_Open and hour < 24) or ( hour >= 0 and hour < Tokyo_Close) then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = Tokyo_Color,
                    width = 0.5
                }
            end
        else
            if hour >= Tokyo_Open and hour < Tokyo_Close then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = Tokyo_Color,
                    width = 0.5
                }
            end
        end
        size = size + 0.2
    end
    ------------------------------------------------------------------------------

    --------------------- London session ----------------------------------------
    -- We first check if the user wants to display the London session trading time.
    if London_Visible == true then
        -- Trading sessions might overlap two different date days in most users timezones.
        -- We therefore need to check if our closing hour is less than the opening hour.
        if London_Close < London_Open then
            if (hour >= London_Open and hour < 24) or ( hour >= 0 and hour < London_Close) then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = London_Color,
                    width = 0.5
                }
            end
        else
            if hour >= London_Open and hour < London_Close then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = London_Color,
                    width = 0.5
                }
            end
        end
        size = size + 0.2
    end
    ------------------------------------------------------------------------------

    --------------------- New York session ----------------------------------------
    -- We first check if the user wants to display the New York session trading time.
    if NewYork_Visible == true then
        -- Trading sessions might overlap two different date days in most users timezones.
        -- We therefore need to check if our closing hour is less than the opening hour.
        if NewYork_Close < NewYork_Open then
            if (hour >= NewYork_Open and hour < 24) or ( hour >= 0 and hour < NewYork_Close) then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = NewYork_Color,
                    width = 0.5
                }
            end
        else
            if hour >= NewYork_Open and hour < NewYork_Close then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = NewYork_Color,
                    width = 0.5
                }
            end
        end
        size = size + 0.2
    end
    ------------------------------------------------------------------------------

    --------------------- Preferred session --------------------------------------
    -- We first check if the user wants to display the Preferred session trading time.
    if Preferred_Visible == true then
        -- Trading sessions might overlap two different date days in most users timezones.
        -- We therefore need to check if our closing hour is less than the opening hour.
        if Preferred_Close < Preferred_Open then
            if (hour >= Preferred_Open and hour < 24) or ( hour >= 0 and hour < Preferred_Close) then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = Preferred_Color,
                    width = 0.5
                }
            end
        else
            if hour >= Preferred_Open and hour < Preferred_Close then
                rect {
                    first = size,
                    second = size + 0.1,
                    color = Preferred_Color,
                    width = 0.5
                }
            end
        end
        size = size + 0.2
    end
    ------------------------------------------------------------------------------
end
