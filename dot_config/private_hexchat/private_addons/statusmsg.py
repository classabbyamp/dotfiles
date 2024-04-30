# statusmsg.py: indicate messages sent via STATUSMSG
# Configurable via the /statusmsgctl command, run it for more info
# Parameters on statusmsg_param_* correlate to the parameters in the
# corresponding text events (Settings -> Text Events). Modifying
# the event definitions can provide additional configuration abilities.
# Requires Python 3.6+, tested on Python 3.6

# Copyright (c) 2021 Ryan Schmidt <skizzerz@skizzerz.net>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import hexchat

__module_name__ = "statusmsg"
__module_version__ = "2.1"
__module_description__ = "prefixes nicks using status messages"

PREFS = {
    "statusmsg_template": ("$1$2", "$1 => the statusmsg prefix, $2 => parameter, %B => bold, %C => color, %O => end formatting, %U => underline"),
    "statusmsg_param_message": ("1", "0 => disable, 1 => nick, 2 => message, 3 => nick's prefix, 4 => identified text"),
    "statusmsg_param_action": ("1", "0 => disable, 1 => nick, 2 => message, 3 => nick's prefix, 4 => identified text"),
    "statusmsg_param_notice": ("0", "0 => disable, 1 => nick, 2 => channel, 3 => message")
}

# Caches for valid nick prefixes/channel types. key is network name,
# value is a tuple of the valid prefixes/types
STATUSMSG = {}
CHANTYPES = {}

# Temporary storage for when a statusmsg was issued in a given network and channel by a given nick
# Key is the tuple (network, channel, nick) and value is the statusmsg prefix
PENDING = {}

def clear_cache(word, word_eol, userdata):
    network = hexchat.get_info("network")
    if network:
        STATUSMSG[network] = ()
        CHANTYPES[network] = ()
    return hexchat.EAT_NONE


def cache_data(word, word_eol, userdata):
    network = hexchat.get_info("network")
    if network:
        for w in word[1:]:
            if w[0] == ":":
                # got to the end of the tokens in this ISUPPORT line
                break
            parts = w.split("=", maxsplit=1)
            if len(parts) != 2:
                continue
            key, value = parts
            if key == "STATUSMSG":
                STATUSMSG[network] = tuple(value)
            elif key == "CHANTYPES":
                CHANTYPES[network] = tuple(value)
    return hexchat.EAT_NONE


def register_prefix(word, word_eol, userdata):
    # word[0] = ":nick!user@host"
    # word[1] = "PRIVMSG" or "NOTICE"
    # word[2] = "#channel"
    # word[3] = ":message"
    if len(word) < 4 or len(word[2]) < 2:
        # definitely cannot be a statusmsg
        return hexchat.EAT_NONE

    network = hexchat.get_info("network")
    if word[2][0] not in STATUSMSG.get(network, ()) or word[2][1] not in CHANTYPES.get(network, ()):
        # not a statusmsg or not a channel
        return hexchat.EAT_NONE
        
    channel = word[2][1:]
    nick = word[0].split("!")[0][1:]
    prefix = word[2][0]
    PENDING[(network, channel, nick)] = prefix

    # allow regular print event to be emitted; we'll hook into that and add the prefix
    # this avoids duplication of a whole bunch of hexchat logic for determining which print event
    # should be emitted (mostly around determining if a highlight happened)
    return hexchat.EAT_NONE


def print_statusmsg(word, word_eol, userdata, attrs):
    network = hexchat.get_info("network")
    channel = hexchat.get_info("channel")
    nick = hexchat.strip(word[0])
    prefix = PENDING.get((network, channel, nick))
    if prefix is None:
        return hexchat.EAT_NONE

    # avoid recursion
    del PENDING[(network, channel, nick)]
    template = hexchat.get_pluginpref("statusmsg_template")
    event = userdata["event"]
    param = hexchat.get_pluginpref("statusmsg_param_" + userdata["pref"]) - 1
    color = userdata["color"]

    # check if we're disabled
    if param < 0:
        return hexchat.EAT_NONE

    # massage template into what it should be
    word[param] = (template.replace("%B", "\x02")
                           .replace("%C", "\x03")
                           .replace("%O", "\x0f")
                           .replace("%U", "\x1f")
                           .replace("$1", prefix)
                           .replace("$2", word[param]))

    if not attrs:
        attrs = {}

    # capture our context in case something changes it on us through executing these things
    # we re-send the event with our additional annotation, then apply the normal behavior of
    # a message (red channel name for regular messages, blue channel name + icon flash for pings,
    # grey for notices)
    ctx = hexchat.get_context()
    ctx.emit_print(event, *word, time=attrs.time)
    if color == 3:
        ctx.command("GUI FLASH")
    ctx.command(f"GUI COLOR {color}")

    return hexchat.EAT_ALL


def send_statusmsg(word, word_eol, userdata):
    channel = hexchat.get_info("channel")
    if not channel:
        print("You are not on a channel!")
        return hexchat.EAT_ALL

    prefix = userdata["prefix"]
    message = word_eol[1]
    hexchat.command(f"msg {prefix}{channel} {message}")
    return hexchat.EAT_ALL


def statusmsgctl(word, word_eol, userdata):
    if len(word) == 1:
        for pref, (default, help) in PREFS.items():
            value = hexchat.get_pluginpref(pref)
            print(f"{pref} = {value}")
            print(f"        {help}")
        print("To view a specific setting: /STATUSMSGCTL <setting>")
        print("To modify a specific setting: /STATUSMSGCTL <setting> <value>")

    elif len(word) == 2:
        if word[1] not in PREFS:
            print("Unknown statusmsg pref, see /STATUSMSGCTL for a list of valid prefs")
            return hexchat.EAT_ALL
        value = hexchat.get_pluginpref(word[1])
        print(f"{word[1]} = {value}")

    else:
        if word[1] not in PREFS:
            print("Unknown statusmsg pref, see /STATUSMSGCTL for a list of valid prefs")
            return hexchat.EAT_ALL
        hexchat.set_pluginpref(word[1], word_eol[2])
        print(f"{word[1]} = {word_eol[2]}")

    return hexchat.EAT_ALL


event_map = {
    "Channel Action": ("action", 2),
    "Channel Action Hilight": ("action", 3),
    "Channel Message": ("message", 2),
    "Channel Msg Hilight": ("message", 3),
    "Channel Notice": ("notice", 1)
}

hexchat.hook_server("001", clear_cache)
hexchat.hook_server("005", cache_data)
hexchat.hook_server("PRIVMSG", register_prefix)
hexchat.hook_server("NOTICE", register_prefix)
for evt, (pref, color) in event_map.items():
    hexchat.hook_print_attrs(evt, print_statusmsg, userdata={"event": evt, "pref": pref, "color": color})
hexchat.hook_command("vmsg", send_statusmsg, userdata={"prefix": "+"}, help="Send message to all voiced users on a channel.")
hexchat.hook_command("omsg", send_statusmsg, userdata={"prefix": "@"}, help="Send message to all opped users on a channel.")
hexchat.hook_command("statusmsgctl", statusmsgctl, help="View and modify statusmsg plugin settings.")

for pref, (value, help) in PREFS.items():
    if hexchat.get_pluginpref(pref) is None:
        hexchat.set_pluginpref(pref, value)

# if we're loaded while already connected to a network, we cant get the info out of ISUPPORT,
# so obtain it via the channel list instead
for ch in hexchat.get_list("channels"):
    if ch.network in CHANTYPES:
        continue
    CHANTYPES[ch.network] = ch.chantypes
    # technically wrong, but we don't have access to the real STATUSMSG token here
    STATUSMSG[ch.network] = ch.nickprefixes

print(f"Loaded {__module_name__} v{__module_version__}")
