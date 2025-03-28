# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os, subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.wayland import InputConfig

mod = "mod4"
terminal = guess_terminal()
wallpaper_path = os.path.expanduser("~") + "/.git/repos/wallpapers/"
has_battery = any(os.path.exists(f"/sys/class/power_supply/{bat}") for bat in os.listdir("/sys/class/power_supply/"))
def get_network_status():
    # Check for LAN connection (Ethernet)
    lan_status = os.popen("ip link show eth0 | grep 'state UP'").read().strip()
    if lan_status:
        return "󰈀 Connected  "
    else:
        # Check for WLAN connection (Wi-Fi)
        wlan_status = os.popen("iwgetid -r").read().strip()
        if wlan_status:
            return f"󰖩 {wlan_status}  "
    # If neither LAN nor WLAN is connected
    return "No connection  "

keys = [
    # The essentials
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "Delete", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "q", lazy.spawn("sysact"), desc="Launch system script"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
    Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # Dmenu scripts launched using SUPER+z + "key"
    KeyChord([mod], "z",[
        Key([], "z", lazy.spawn("zzzzz"), desc="zzzz"),
    ])
]

colors = {
    "background": ["#141617"],
    "foreground": ["#d4be98"],
    "cursorColor": ["#ddc7a1"],
    "black": ["#1d2021"],
    "red": ["#ea6962"],
    "green": ["#a9b665"],
    "yellow": ["#d8a657"],
    "blue": ["#7daea3"],
    "magenta": ["#d3869b"],
    "cyan": ["#89b482"],
    "white": ["#d4be98"],
    "blackBright": ["#928374"],
    "redBright": ["#ea6962"],
    "greenBright": ["#a9b665"],
    "yellowBright": ["#d8a657"],
    "blueBright": ["#7daea3"],
    "magentaBright": ["#d3869b"],
    "cyanBright": ["#89b482"],
    "whiteBright": ["#d4be98"],
}

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        ))

layout_theme = {
    "border_width": 2,
    "margin": 5,
    "new_client_position": "before_current",
    "single_border_width": 0,
    "single_margin": 5,
    "border_focus": "#7daea3",
    "border_normal": "#a9b665"
}

layouts = [
        layout.Floating(**layout_theme),
        layout.MonadTall(**layout_theme),
        layout.MonadWide(**layout_theme),
        layout.Columns(**layout_theme),
]

groups = [
    Group("Dev", layout="columns", label='<span foreground="#d3869d">󰧚</span>'),
    Group("Web", layout="columns", label='<span foreground="#7daea3">󰈹</span>'),
    Group("Gaming", layout="floating", label='<span foreground="#89b482">󰊗</span>'),
    Group("Comms", layout="columns", label='<span foreground="#a9b665">󰇮</span>'),
    Group("Media", layout="columns", label='<span foreground="#d8a657">󰕧</span>'),
    Group("Server", layout="columns", label='<span foreground="#e78a4e">󰣳</span>'),
    Group("Hidden", layout="columns", label='<span foreground="#ea6962">󰈉</span>'),
]

# Allow MODKEY+[0 through 9] to bind to groups
dgroups_key_binder = simple_key_binder("mod4")

widget_defaults = dict(
    font="sans-serif bold",
    fontsize=12,
    padding=2,
    backgroud="#141617"
)
extension_defaults = widget_defaults.copy()

def init_bar_widgets(primary=True):
    widgets = [
        widget.GroupBox(
            font="Material Design Icons",
            fontsize=15,
            markup=True,
            padding=4,
            highlight_method='line',
            highlight_color="#141617",
            this_current_screen_border="#d4be98",
        ),
        widget.WindowName(
            foreground="#d4be98",
            padding=8,
            max_chars=50,
        ),
        widget.Prompt(
            foreground="#d4be98",
            padding=8,
        ),
        widget.CPU(
            foreground="#d3869d",
            format='󰘚 {load_percent}%  '
        ),
        widget.Memory(
            foreground="#7daea3",
            format="󰆼 {MemPercent}%  ",
        ),
        widget.GenPollText(
            foreground="#89b482",
            func=get_network_status, update_interval=5,
        ),
        *(
            [widget.Battery(
                foreground="#d8a657",
                format="󰁹 {percent:2.0%}  "
            )] if has_battery else []
        ),
        widget.Clock(
            foreground="#e78a4e",
            format='󰃭 %a %d %B  <span foreground="#ea6962">󱑎 %I:%M</span> '),
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        widget.StatusNotifier(),
        #widget.Systray(),
    ]
    if primary:
        widgets.insert(
            -1,
            widget.Systray(
                padding=2,
            ),
        )
    return widgets

screens = [
    Screen(
        top=bar.Bar(
            widgets=init_bar_widgets(),
            size=24,
            margin=[5, 5, 0, 5],
            background='#141617'
        ),
        wallpaper=wallpaper_path + "gruvbox/001.png",
        wallpaper_mode="fill"
    ),
    Screen(
        top=bar.Bar(
            widgets=init_bar_widgets(primary=False),
            size=24,
            margin=[5, 5, 0, 5],
            background='#141617'
        ),
        wallpaper=wallpaper_path + "gruvbox/001.png",
        wallpaper_mode="fill"
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call(home)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
#wl_input_rules = None
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_layout="us", kb_variant="altgr-intl",
        kb_model="pc104", kb_options="caps:swapescape",
        kb_repeat_rate=50, kb_repeat_delay=150
    ),
    "type:pointer": InputConfig(
        accel_profile="flat",
        natural_scroll="True"
    )
}

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
