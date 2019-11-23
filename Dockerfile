FROM alpine:3.10
MAINTAINER kost - https://github.com/kost

ENV ULX3SBASEDIR=/opt

# qt5-qtbase-dev
RUN apk --update add git patch bash wget build-base python3-dev boost-python3 boost-static boost-dev libusb-dev libusb-compat-dev libftdi1-dev libtool automake autoconf make cmake pkgconf eigen-dev eigen bison flex gawk libffi-dev zlib-dev tcl-dev graphviz readline-dev py2-pip && \
 rm -f /var/cache/apk/* && \
 echo "Success [deps]"

COPY root /

RUN cd $ULX3SBASEDIR && \
 git clone https://github.com/emard/ulx3s-bin && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/f32c/tools f32c-tools && \
 cd f32c-tools/ujprog && \
 cp $ULX3SBASEDIR/patches/Makefile.alpine . && \
 make -f Makefile.alpine && \
 install -m 755 -s ujprog /usr/local/bin && \
 cd $ULX3SBASEDIR && \
 git clone https://git.code.sf.net/p/openocd/code openocd && \
 cd openocd && \
 ./bootstrap && \
 LDFLAGS="--static" ./configure --enable-static && \
 make -j$(nproc) && \
 make install && \
 strip /usr/local/bin/openocd && \
 cd $ULX3SBASEDIR && \
 git clone --recursive https://github.com/SymbiFlow/prjtrellis && \
 cd prjtrellis/libtrellis/ && \
 cmake -DCMAKE_INSTALL_PREFIX=/usr && \
 make -j$(nproc) &&\
 make install && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/YosysHQ/nextpnr.git && \
 cd nextpnr && \
 patch -p0 < $ULX3SBASEDIR/patches/nextpnr-CMakeLists.txt.patch && \
 EIGEN3_INCLUDE_DIR=/usr/include/eigen3 cmake -DARCH=ecp5 -DTRELLIS_ROOT=/opt/prjtrellis -DBUILD_GUI=OFF -DBUILD_PYTHON=OFF -DSTATIC_BUILD=ON && \
 make -j$(nproc) && \
 make install && \
 strip /usr/local/bin/nextpnr-ecp5 && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/YosysHQ/yosys.git && \
 cd yosys && \
 make config-gcc-static && \
 make -j$(nproc) && \
 make install && \
 strip /usr/local/bin/yosys && \
 git clone https://github.com/richardeoin/ftx-prog.git && \
 cd ftx-prog && \
 make CFLAGS="-I/usr/include/libftdi1" LDFLAGS="/usr/lib/libftdi1.a /usr/lib/libusb-1.0.a /usr/lib/libusb.a -static" && \
 install -m 755 -s ftx_prog /usr/local/bin/ && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/emard/FleaFPGA-JTAG.git && \
 cd FleaFPGA-JTAG/FleaFPGA-JTAG-linux && \
 make CFLAGS="-I/usr/include/libftdi1 /usr/lib/libftdi1.a /usr/lib/libusb-1.0.a /usr/lib/libusb.a -static" && \
 install -m 755 -s FleaFPGA-JTAG /usr/local/bin && \
 cd $ULX3SBASEDIR && \
 pip2 install esptool && \
 pip2 install pyserial && \
 pip3 install esptool && \
 pip3 install pyserial && \
 echo "Success [build]"


#VOLUME ["/fpga"]
WORKDIR /fpga



