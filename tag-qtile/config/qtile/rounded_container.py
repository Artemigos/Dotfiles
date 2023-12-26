import math
from typing import Any, Optional

from libqtile import bar
from libqtile.widget import base

class RoundedContainer(base._Widget):
    orientations = base.ORIENTATION_HORIZONTAL
    widget: base._Widget
    defaults: list[tuple[str, Any, str]] = [
        ("widget", None, "Widget wrapped with rounded corners"),
        ("radius", None, "Radius of the rounded corners"),
    ]

    def __init__(self, **config) -> None:
        base._Widget.__init__(self, length=bar.CALCULATED, **config)
        self.add_defaults(self.defaults)
        self.radius: Optional[int]

        if self.widget is None:
            raise Exception('widget required')

    def _radius(self):
        return self.radius or self.height//2

    def calculate_length(self):
        return self.widget.length + 2*self._radius()

    @property
    def width(self):
        return self.widget.width + 2*self._radius()

    @property
    def height(self):
        return self.widget.height - self.bar.margin[0] - self.bar.margin[2]

    def draw(self) -> None:
        self.drawer.clear(self.bar.background)

        radius = self._radius()
        degrees = math.pi / 180.0
        width = self.width
        height = self.height

        self.drawer.ctx.save()
        self.drawer.ctx.new_sub_path()
        self.drawer.ctx.arc(width - radius, radius, radius, -90 * degrees, 0 * degrees)
        self.drawer.ctx.arc(width - radius, height - radius, radius, 0 * degrees, 90 * degrees)
        self.drawer.ctx.arc(radius, height - radius, radius, 90 * degrees, 180 * degrees)
        self.drawer.ctx.arc(radius, radius, radius, 180 * degrees, 270 * degrees)
        self.drawer.ctx.close_path()
        self.drawer.ctx.clip()
        self.drawer.set_source_rgb(self.background or self.bar.background)
        self.drawer.ctx.rectangle(0, 0, width, height)
        self.drawer.ctx.fill()
        self.drawer.ctx.restore()

        self.drawer.draw(offsetx=self.offsetx, offsety=self.offsety, width=self.length)

        self.widget.offsetx = self.offsetx+radius
        self.widget.offsety = self.offsety
        self.widget.draw()

    def timer_setup(self):
        self.widget.timer_setup()

    def _configure(self, qtile, bar):
        super()._configure(qtile, bar)
        self.widget._configure(qtile, bar)

    async def _config_async(self):
        await self.widget._config_async()

    def finalize(self):
        self.widget.finalize()
        super().finalize()

    def button_press(self, x, y, button):
        super().button_press(x, y, button)
        self.widget.button_press(x, y, button)

    def button_release(self, x, y, button):
        super().button_release(x, y, button)
        self.widget.button_release(x, y, button)

    def mouse_enter(self, x, y):
        self.widget.mouse_enter(x, y)

    def mouse_leave(self, x, y):
        self.widget.mouse_leave(x, y)
