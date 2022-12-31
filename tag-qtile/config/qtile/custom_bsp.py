from libqtile.command.base import expose_command
from libqtile.layout import Bsp

class CustomBsp(Bsp):
    defaults = [
        ('name', 'cbsp', 'Name of this layout.'),
    ]

    def __init__(self, **config):
        Bsp.__init__(self, **config)
        self.add_defaults(CustomBsp.defaults)

    @expose_command()
    def flip(self):
        node = self.current
        if node and node.parent:
            is_first = node.parent.children.index(node) == 0
            if node.parent.split_horizontal:
                if is_first:
                    self.flip_right()
                else:
                    self.flip_left()
            else:
                if is_first:
                    self.flip_down()
                else:
                    self.flip_up()

    def transplant(self, target_node):
        curr_node = self.current
        if target_node and curr_node and curr_node.parent:
            self.current = target_node.insert(
                curr_node.client,
                int(self.lower_right),
                self.ratio)
            curr_node.parent.remove(curr_node)
            self.group.layout_all()

    @expose_command()
    def transplant_left(self):
        self.transplant(self.find_left())

    @expose_command()
    def transplant_right(self):
        self.transplant(self.find_right())

    @expose_command()
    def transplant_up(self):
        self.transplant(self.find_up())

    @expose_command()
    def transplant_down(self):
        self.transplant(self.find_down())
