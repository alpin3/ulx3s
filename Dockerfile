FROM alpin3/ulx3s-core
MAINTAINER kost - https://github.com/kost

ENV ULX3SBASEDIR=/opt

# qt5-qtbase-dev
RUN apk --update add git patch bash wget build-base python3-dev boost-python3 boost-static boost-dev libusb-dev libusb-compat-dev libftdi1-dev libtool automake autoconf make cmake pkgconf eigen-dev eigen bison flex gawk libffi-dev zlib-dev tcl-dev graphviz readline-dev py2-pip && \
 rm -f /var/cache/apk/* && \
 echo "Success [deps]"

COPY root /

RUN cd $ULX3SBASEDIR && \
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
 echo "Success [build]"


#VOLUME ["/fpga"]
WORKDIR /fpga



