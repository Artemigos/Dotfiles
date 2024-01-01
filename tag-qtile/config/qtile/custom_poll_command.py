import subprocess

from libqtile.widget import base

def preprocess_sep_to_sep(from_sep = '\n', to_sep = ', '):
    def _(text):
        if text is not None:
            return to_sep.join(text.split(from_sep))
        return text
    return _

class CustomPollCommand(base.ThreadPoolText):
    defaults = [
        ('cmd', None, 'the command to poll'),
        ('update_interval', 3, 'update time in seconds'),
        ('format', '{}', 'text format of the widget'),
        ('empty_format', '', 'format when command output is empty'),
        ('preprocess', None, 'function for preprocessing the text'),
    ]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(CustomPollCommand.defaults)

    def _configure(self, qtile, bar):
        base.ThreadPoolText._configure(self, qtile, bar)
        self.add_callbacks({"Button1": self.force_update})

    def poll(self):
        process = subprocess.run(
            self.cmd,
            capture_output=True,
            text=True,
            shell=False,
        )
        result = process.stdout.strip()
        if self.preprocess:
            result = self.preprocess(result)
        if result is None or result == '':
            return self.empty_format
        else:
            return self.format.format(result)
