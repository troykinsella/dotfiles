from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
import colors
import os
import subprocess
import distro

mod = "mod4"
terminal = "alacritty"
editor = "emacsclient -c -a emacs"

#############
# Functions #
#############

def distro_icon():
    d = distro.linux_distribution()[0]
    if d == "Arch Linux":
        return "󰣇"
    if d == "Ubuntu":
        return ""
    if d == "Debian":
        return ""
    return "???"


def htop():
    qtile.cmd_spawn(terminal + ' -e htop')


def search():
    qtile.cmd_spawn("rofi -show drun")


########
# Keys #
########

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "b", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "f", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "n", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "p", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "b", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "f", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "n", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "p", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "b", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "f", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "n", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "p", lazy.layout.grow_up(), desc="Grow window up"),
    # Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
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
    Key([mod], "a", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "e", lazy.spawn(editor), desc="Run emacs"),
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn a command using a prompt widget"),
]

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
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

###########
# Layouts #
###########

colors = colors.DoomOne

layout_theme = {
    "border_width": 0,
    "margin": 5,
    "border_focus": colors[8],
    "border_normal": colors[0]
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(border_width = 0, margin = [0, 0, 5, 0]),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="SauceCodePro Nerd Font",
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()
widgets = [
    widget.Spacer(length = 8),
    widget.TextBox(
        text = distro_icon(),
        fontsize = 20,
        padding = 8,
        mouse_callbacks = {'Button1': lambda: search()},
    ),
    widget.Spacer(length = 8),
    widget.CurrentLayoutIcon(
        foreground = colors[1],
        padding = 4,
        scale = 0.6
    ),
    widget.GroupBox(
        font="SauceCodePro Nerd Font Bold",
        borderwidth = 3,
        highlight_method = "block",
        active = colors[8],
        block_highlight_text_color = colors[4],
        highlight_color = colors[5],
        inactive = colors[1],
        foreground = colors[4],
        this_current_screen_border = colors[2],
        this_screen_border = colors[3],
        other_current_screen_border = colors[4],
        other_screen_border = colors[5],
        urgent_border = colors[7],
        rounded = True,
        disable_drag = True,
    ),
    widget.Prompt(),
    widget.WindowName(
        font="SauceCodePro Nerd Font Bold",
        foreground = colors[6],
        max_chars = 40
    ),
    widget.Spacer(length = 8),
    widget.Net(
        foreground = colors[5],
        interface = "enp1s0", # TODO: <--
        format = "↓{down} ↑{up}",
        updateinterval = 1.0,
    ),
    widget.Spacer(length = 8),
    widget.CPU(
        format = ' {load_percent}%',
        mouse_callbacks = {'Button1': lambda: htop()},
        foreground = colors[4],
    ),
    widget.Spacer(length = 8),
    widget.Memory(
        foreground = colors[8],
        mouse_callbacks = {'Button1': lambda: htop()},
        format = ' {MemUsed:.0f}{mm}',
    ),
    widget.Spacer(length = 8),
#    widget.PulseVolume(
#        foreground = colors[7],
#        mouse_callbacks = {'Button3': lambda: qtile.cmd_spawn("pavucontrol")},
#        update_interval = 0
#    ),
    widget.Volume(
        foreground = colors[7],
        fmt = ' {}',
    ),
    widget.Spacer(length = 8),
    # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
    # widget.StatusNotifier(),
    widget.Systray(),
    widget.Spacer(length = 8),
    widget.Clock(format=" %I:%M %p"),
    widget.Spacer(length = 8),
]

if len(os.listdir("/sys/class/power_supply")) > 0:
    widgets.append(
        widget.Battery(
            low_percentage=0.3,
            low_background="#0ee9af",
            background=colors[4],
            low_foreground=colors[0],
            update_interval=1,
            charge_char='',
            discharge_char='',
            format='{char} {percent:2.0%}',
        ),
    )

screens = [
    Screen(
        bottom=bar.Bar(
            widgets,
            24,
            border_width = 0,
            margin = [0, 5, 5, 5],
            background = colors[0],
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
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
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

wmname = "LG3D"
