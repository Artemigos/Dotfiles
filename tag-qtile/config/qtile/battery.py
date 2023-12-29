import os

from libqtile.widget import Battery

BAT_DIR = '/sys/class/power_supply'

def machine_has_battery() -> bool:
    bats = [f for f in os.listdir(BAT_DIR) if f.startswith("BAT")]
    return any(bats)

class BatteryOverride(Battery):
    def build_string(self, status) -> str:
        val = Battery.build_string(self, status)
        if val == 'Full':
            return self.full_char + ' 100%'
        if val == 'Empty':
            return self.empty_char + ' 0%'
        return val
