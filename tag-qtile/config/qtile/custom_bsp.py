from libqtile.layout import Bsp

class CustomBsp(Bsp):
    defaults = [
        ('name', 'cbsp', 'Name of this layout.'),
    ]

    def __init__(self, **config):
        Bsp.__init__(self, **config)
        self.add_defaults(CustomBsp.defaults)

    def cmd_flip(self):
        node = self.current
        if node and node.parent:
            is_first = node.parent.children.index(node) == 0
            if node.parent.split_horizontal:
                if is_first:
                    self.cmd_flip_right()
                else:
                    self.cmd_flip_left()
            else:
                if is_first:
                    self.cmd_flip_down()
                else:
                    self.cmd_flip_up()

    def cmd_next(self):
        if self.current:
            client = self.focus_next(self.current.client)
            if client:
                self.group.focus(client, True)
                return

        client = self.focus_first()
        if client:
            self.group.focus(client, True)

    def cmd_previous(self):
        if self.current:
            client = self.focus_previous(self.current.client)
            if client:
                self.group.focus(client, True)
                return

        client = self.focus_last()
        if client:
            self.group.focus(client, True)

    def transplant(self, target_node):
        curr_node = self.current
        if target_node and curr_node and curr_node.parent:
            self.current = target_node.insert(curr_node.client, int(self.lower_right), self.ratio)
            curr_node.parent.remove(curr_node)
            self.group.layout_all()

    def cmd_transplant_left(self):
        self.transplant(self.find_left())

    def cmd_transplant_right(self):
        self.transplant(self.find_right())

    def cmd_transplant_up(self):
        self.transplant(self.find_up())

    def cmd_transplant_down(self):
        self.transplant(self.find_down())

