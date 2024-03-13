from libqtile.config import Group, Match

groups = [
    Group("1"),
    Group("2", matches = [
        Match(wm_class = "firefox"),
        Match(wm_class = "brave"),
    ]),
    Group("3", matches = [
        Match(wm_class = "discord")
    ]),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
]
