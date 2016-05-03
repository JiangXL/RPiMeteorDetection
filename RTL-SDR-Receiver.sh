#here is command to install qtcsdr in RP
#qtcsdr
#qtcsdr makes a ham transceiver out of your Raspberry Pi 2 and RTL-SDR!
#https://github.com/ha7ilm/qtcsdr

git clone https://github.com/ha7ilm/qtcsdr
cd qtcsdr
./rpi-install.sh
./rpi-test.sh

#I want to run stl_sdr receiver withou GUI to acclalte
#https://github.com/ha7ilm/rtl-sdr
#我想直接用libcsdr直接输出音频，减少资料利用。
