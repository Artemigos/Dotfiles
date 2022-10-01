from asyncio import get_event_loop, new_event_loop
from typing import Callable

from dbus_next.aio.message_bus import MessageBus
from dbus_next.constants import BusType, MessageType
from dbus_next.message import Message

from libqtile.widget import base

def _default_formatter(status, artist, song):
    if status is None:
        return ''
    if status == PlaybackStatus.Stopped:
        return f'[{status}]'
    return f'[{status}] {artist} - {song}'

class PlaybackStatus:
    Paused = 'Paused'
    Playing = 'Playing'
    Stopped = 'Stopped'

class MprisTracker:
    player_path = '/org/mpris/MediaPlayer2'
    player_interface = 'org.mpris.MediaPlayer2.Player'
    properties_interface = 'org.freedesktop.DBus.Properties'
    tracking_name = 'org.freedesktop.DBus'
    tracking_path = '/org/freedesktop/DBus'
    tracking_interface = 'org.freedesktop.DBus.Monitoring'
    signal_tracking_interface = 'org.freedesktop.DBus'

    def __init__(self, objname: str, song_handler: Callable[[str, str, str], None]):
        self.objname = objname
        self.song_handler = song_handler
        self.last_status = None
        self.last_artist = None
        self.last_song = None

    async def _config_async(self):
        await self._track_song_changes()
        await self._fetch_current_song()
        await self._track_name_acquisition()

    async def _fetch_current_song(self):
        try:
            bus = await MessageBus(bus_type=BusType.SESSION).connect()
            introspection = await bus.introspect(self.objname, MprisTracker.player_path)
            obj = bus.get_proxy_object(self.objname, MprisTracker.player_path, introspection)
            props_iface = obj.get_interface(MprisTracker.properties_interface)
            props = await props_iface.call_get_all(MprisTracker.player_interface)
            self._handle_prop_change(MprisTracker.player_interface, props, [])
            bus.disconnect()
        except:
            self.song_handler(None, None, None)

    async def _track_song_changes(self):
        bus = await MessageBus(bus_type=BusType.SESSION).connect()
        introspection = await bus.introspect(MprisTracker.tracking_name, MprisTracker.tracking_path)
        obj = bus.get_proxy_object(MprisTracker.tracking_name, MprisTracker.tracking_path, introspection)
        iface = obj.get_interface(MprisTracker.signal_tracking_interface)
        await iface.call_add_match(f"type='signal',member='PropertiesChanged',sender='{self.objname}'")
        bus.add_message_handler(self._handle_prop_change_message)

    async def _track_name_acquisition(self):
        bus = await MessageBus(bus_type=BusType.SESSION).connect()
        introspection = await bus.introspect(MprisTracker.tracking_name, MprisTracker.tracking_path)
        obj = bus.get_proxy_object(MprisTracker.tracking_name, MprisTracker.tracking_path, introspection)
        iface = obj.get_interface(MprisTracker.tracking_interface)
        await iface.call_become_monitor([f"type='signal',member='NameLost',arg0='{self.objname}'"], 0)
        bus.add_message_handler(self._handle_name_change_message)

    def _handle_prop_change_message(self, msg: Message):
        if msg.message_type == MessageType.SIGNAL and msg.member == 'PropertiesChanged':
            self._handle_prop_change(*msg.body)

    def _handle_prop_change(self, iface, changed_properties: dict, _):
        if iface == MprisTracker.player_interface:
            status = self.last_status
            if 'PlaybackStatus' in changed_properties:
                status = self.last_status = changed_properties.get('PlaybackStatus').value or None

            artist = self.last_artist
            song = self.last_song
            if 'Metadata' in changed_properties:
                meta = changed_properties.get('Metadata').value
                artist = self.last_artist = meta.get('xesam:artist').value[0] or None
                song = self.last_song = meta.get('xesam:title').value or None

            self.song_handler(status, artist, song)
            if status is None or artist is None or song is None:
                get_event_loop().create_task(self._fetch_current_song())

    def _handle_name_change_message(self, msg: Message):
        if msg.message_type == MessageType.SIGNAL and msg.member == 'NameLost':
            self.song_handler(None, None, None)

class SimpleMpris2(base._TextBox):
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ('name', 'spotify', 'Name of the widget.'),
        ('objname', 'org.mpris.MediaPlayer2.spotify', 'DBUS MSPRIS 2 compatible player identifier.'),
        ('display_formatter', _default_formatter, 'Function formatting the song data.'),
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, '', **config)
        self.add_defaults(SimpleMpris2.defaults)
        self.song_data = None
        self.tracker = MprisTracker(self.objname, self._update_text)

    async def _config_async(self):
        self._update_text(None, None, None)
        await self.tracker._config_async()

    def _update_text(self, status, artist, song):
        new = status, artist, song
        if self.song_data != new:
            self.song_data = new
            text = self.display_formatter(*new)
            self.update(text)

    def cmd_info(self):
        return dict(
            status=self.song_data[0],
            artist=self.song_data[1],
            song=self.song_data[2],
        )

if __name__ == '__main__':
    def formatter(status, artist, song):
        print(_default_formatter(status, artist, song) or '-')

    loop = new_event_loop()
    tracker = MprisTracker('org.mpris.MediaPlayer2.spotify', formatter)

    try:
        loop.run_until_complete(tracker._config_async())
        loop.run_forever()
    except KeyboardInterrupt:
        pass

