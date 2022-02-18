-- Load libraries
local awful = require('awful')
local gears = require('gears')
-- Load custom modules
local utils_tables = require('neconfig.config.utils.utils_tables')
local user_titlebar = require('neconfig.user.config.widgets.user_titlebar')
local user_look_titlebar = require('neconfig.user.look.widgets.user_look_titlebar')
local user_look_colors = require('neconfig.user.look.user_look_colors')
local utils_colors = require('neconfig.config.utils.utils_colors')
local titlebar_widget_template = require('neconfig.config.widgets.titlebar.titlebar_widget_template')

-- Constants
local titlebar_colors_file = gears.filesystem.get_configuration_dir() .. 'neconfig/user/look/widgets/user_look_titlebar_client_colors.lua'
local titlebar_colors_module = 'neconfig.user.look.widgets.user_look_titlebar_client_colors'


-- Add a titlebar if titlebars_enabled is set to true in the rules
client.connect_signal(
    'request::titlebars',
    function(c)
        local client_titlebar = awful.titlebar(
            c,
            {
                position = user_titlebar.position,
            }
        )

        client_titlebar:setup(titlebar_widget_template(c))
    end
)
-- Force update titlebar colors when borders change
client.connect_signal(
    'request::border',
    function(c)
        c:emit_signal('titlebar::refresh_colors')
    end
)


-- Refresh the color of the titlebar
client.connect_signal(
    'titlebar::refresh_colors',
    function(c)
        -- Get color from user colors
        local all_colors = {
            normal = user_look_titlebar.colors.normal,
            focus  = user_look_titlebar.colors.focus or user_look_titlebar.bar.colors.normal,
            urgent = user_look_titlebar.colors.urgent or user_look_titlebar.bar.colors.normal
        }

        -- Calculate state of the current client
        local client_state = (client.focus == c) and 'focus' or 'normal'
        client_state = c.urgent and 'urgent' or client_state
        local current_color = all_colors[client_state]

        -- Replace 'border' or 'client' bg colors by their values
        local col_bg = current_color.bg
        if current_color.bg == 'client' then
            local all_client_colors = require(titlebar_colors_module)
            if all_client_colors[c.class] then
                col_bg = all_client_colors[c.class]
            else
                col_bg = user_look_colors.classes.normal.bg
                c:emit_signal('titlebar::client_color_save')
            end
        elseif current_color.bg == 'border' then
            col_bg = c.border_color
        end


        -- Replace 'auto' or 'border' fg colors by their calues
        local col_fg = current_color.fg
        if current_color.fg == 'auto' then
            col_fg = utils_colors.get_most_contrast_color(
                col_bg,
                user_look_colors.classes.normal.fg,
                user_look_colors.classes.normal.bg
            )
        elseif current_color.fg == 'border' then
            col_fg = c.border_color
        end

        -- Construct the titlebar
        awful.titlebar(
            c,
            {
                position = user_titlebar.position,
                size = user_look_titlebar.size,
                bg = col_bg,
                fg = col_fg,
            }
        )
    end
)


-- Read the color from the client's edge and save it to the file
client.connect_signal(
    'titlebar::client_color_save_now',
    function(c)
        -- Read from the file containing the colors for all clients that were opened before
        local all_client_colors = require(titlebar_colors_module) or {}
        -- Add or update color
        local client_color = utils_colors.get_client_side_color(c, user_titlebar.position)
        all_client_colors[c.class] = client_color
        -- Save the table
        utils_tables.save_table(
            all_client_colors,
            titlebar_colors_file,
            'titlebar_client_colors',
            '▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█   █▀▀ █   █ █▀▀ █▄ █ ▀█▀   █▀▀ █▀█ █   █▀█ █▀█ █▀',
            ' █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄   █▄▄ █▄▄ █ ██▄ █ ▀█  █    █▄▄ █▄█ █▄▄ █▄█ █▀▄ ▄█'
        )
        -- Refresh colors
        c:emit_signal('titlebar::refresh_colors')
    end
)
client.connect_signal(
    'titlebar::client_color_save',
    function(c)
        gears.timer.weak_start_new(
            0.25,
            function()
                -- Client's color is wrong when its not on the visible tag
                -- This prevents it from updating if the client is not visible
                if c:isvisible() then
                    c:emit_signal('titlebar::client_color_save_now')
                end
            end
        )
    end
)
