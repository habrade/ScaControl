import logging

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

__author__ = "Sheng Dong"
__email__ = "s.dong@mails.ccnu.edu.cn"


class FreqCtr():
    def __init__(self, hw):
        self.hw = hw
        self.reg_name_base = "freq_ctr_dev."
        log.info("Frequency Counter Device")

    def enable_crap_mode(self, enable):
        reg_name = self.reg_name_base + "ctrl." + "en_crap_mode"
        node = self.hw.getNode(reg_name)
        if enable:
            node.write(1)
        else:
            node.write(0)
        self.hw.dispatch()

    def sel_chn(self, chn):
        reg_name = self.reg_name_base + "ctrl." + "chan_sel"
        node = self.hw.getNode(reg_name)
        node.write(chn)
        self.hw.dispatch()

    def is_valid(self):
        reg_name = self.reg_name_base + "freq." + "valid"
        node = self.hw.getNode(reg_name)
        busy_raw = node.read()
        self.hw.dispatch()
        return busy_raw.value() == 1

    def get_freq(self):
        reg_name = self.reg_name_base + "freq." + "count"
        node = self.hw.getNode(reg_name)
        busy_raw = node.read()
        self.hw.dispatch()
        return busy_raw.value()

    def get_chn_freq(self, chn):
        self.get_chn_freq(chn)
        if self.is_valid():
            return self.get_freq()
