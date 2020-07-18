#!/usr/bin/env python

######################################################################
import time
import uhal
import logging

from lib.global_device import GlobalDevice
from lib.sca_device import ScaDevice

######################################################################

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

__author__ = "Sheng Dong"
__email__ = "s.dong@mails.ccnu.edu.cn"

if __name__ == '__main__':
    # if len(sys.argv) < 3:
    #     log.info("Please specify the device IP address and the top-level address table file to use")
    #     sys.exit(1)
    device_ip = "192.168.200.106"
    device_uri = "ipbusudp-2.0://" + device_ip + ":50001"
    # address_table_name = sys.argv[2]
    address_table_name = "../etc/address.xml"
    address_table_uri = "file://" + address_table_name

    uhal.setLogLevelTo(uhal.LogLevel.WARNING)
    hw = uhal.getDevice("HappyDaq.udp.0", device_uri, address_table_uri)

    global_dev = GlobalDevice(hw)
    sca_dev = ScaDevice(hw)

    ## Soft reset
    global_dev.set_soft_rst()

    ## Set Sca Clocks
    ## parameters: Do, M, D
    ## clkin = 125MHz
    ## Frq: (clkin * M)/(DO * D)
    sca_dev.set_clock(1, 1, 1, "clk_ref")
    sca_dev.set_clock(1, 1, 1, "clk_dff")

    ## Set Sca IO
    sca_dev.set_bit0(True)
    sca_dev.set_bit1(True)
    sca_dev.start(True)
    sca_dev.dff_enable(True)
    sca_dev.trigger(True)
    time.sleep(0.001)
    sca_dev.trigger(False)

