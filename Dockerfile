FROM alpin3/ulx3s-core
MAINTAINER kost - https://github.com/kost

ENV ULX3SBASEDIR=/opt GHDLSRC=/opt/ghdl-git GHDLOPT=/opt/ghdl

# qt5-qtbase-dev
RUN apk --update add git patch bash wget build-base python3-dev boost-python3 boost-static boost-dev libusb-dev libusb-compat-dev libftdi1-dev libtool automake autoconf make cmake pkgconf eigen-dev eigen bison flex gawk libffi-dev zlib-dev tcl-dev graphviz readline-dev py2-pip libgnat gcc-gnat libunwind-dev readline-dev ncurses-static openjdk11 util-linux-dev && \
 rm -f /var/cache/apk/* && \
 echo "[i] Success [v1] [deps]"

COPY root /

RUN apk add -f --allow-untrusted $ULX3SBASEDIR/apk/libgnat-8.3.0-r0.apk && \
 rm -f /var/cache/apk/* && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/ldoolitt/vhd2vl.git && \
 cd vhd2vl/src && \
 make WARNS="-static" && \
 install -m 755 -s vhd2vl /usr/local/bin && \
 cd $ULX3SBASEDIR && \
 git clone --recursive https://github.com/SymbiFlow/prjtrellis && \
 cd prjtrellis/libtrellis/ && \
 cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DSTATIC_BUILD=OFF -DBUILD_PYTHON=ON -DBUILD_SHARED=ON . && \
 make -j$(nproc) &&\
 make install && \
 cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DSTATIC_BUILD=ON -DBUILD_PYTHON=OFF -DBUILD_SHARED=OFF . && \
 make -j$(nproc) &&\
 make install && \
 strip /usr/local/bin/ecp* && \
 ln -sf /usr/local/lib64/trellis /usr/local/lib/trellis && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/YosysHQ/nextpnr.git && \
 cd nextpnr && \
 patch -p0 < $ULX3SBASEDIR/patches/nextpnr-CMakeLists.txt.patch && \
 EIGEN3_INCLUDE_DIR=/usr/include/eigen3 cmake -DARCH=ecp5 -DTRELLIS_ROOT=/opt/prjtrellis -DBUILD_GUI=OFF -DBUILD_PYTHON=OFF -DSTATIC_BUILD=ON && \
 make -j$(nproc) && \
 make install && \
 strip /usr/local/bin/nextpnr-ecp5 && \
 cd $ULX3SBASEDIR && \
 ln -sf /usr/lib/libgnat.a /usr/lib/libgnat-8.a && \
 ln -sf /usr/lib/libgnarl.a /usr/lib/libgnarl-8.a && \
 git clone https://github.com/ghdl/ghdl.git $GHDLSRC && \
 cd $GHDLSRC && \
 patch -p1 < $ULX3SBASEDIR/patches/ghdl.patch && \
 ./configure --enable-libghdl --enable-synth --prefix=$GHDLOPT && \
 make && \
 rm ghdl_mcode && \
 gnatmake -o ghdl_mcode -gnat12 -aI./src -aI./src/vhdl -aI./src/grt -aI./src/psl -aI./src/vhdl/translate -aI./src/ghdldrv -aI./src/ortho -aI./src/ortho/mcode -aI./src/synth -gnaty3befhkmr -gnatwa -gnatf -g -gnata -gnatwe -gnatw.A ghdl_jit.adb -bargs -E -largs memsegs_c.o chkstk.o jumps.o times.o grt-cstdio.o grt-cgnatrts.o grt-cvpi.o grt-cdynload.o fstapi.o lz4.o fastlz.o -lunwind  -lm -Wl,--version-script=/opt/ghdl-git/./src/grt/grt.ver -Wl,--allow-multiple-definition -static -s && \
 make libghdlsynth.a && \
 make install && \
 install -m 755 $GHDLOPT/bin/ghdl /usr/local/bin/ghdl && \
 make libghdlsynth.a-install && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/ghdl/ghdl-yosys-plugin && \
 cd ghdl-yosys-plugin && \
 cd $ULX3SBASEDIR && \
 git clone https://github.com/YosysHQ/yosys.git && \
 cp -a /opt/ghdl-yosys-plugin/src /opt/yosys/frontends/ghdl && \
 cd yosys && \
 patch -p1 < $ULX3SBASEDIR/patches/yosys.diff && \
 cp -a $ULX3SBASEDIR/patches/Makefile.conf . && \
 make -j$(nproc) && \
 make install && \
 strip /usr/local/bin/yosys && \
 cd $ULX3SBASEDIR && \
 git clone -b wip --recurse-submodules https://github.com/sylefeb/Silice.git && \
 cd Silice && \
 export PATH=/usr/lib/jvm/java-11-openjdk/bin:$PATH && \
 mkdir build && cd build && \
 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-static" -G "Unix Makefiles" .. && \
 make -j `nproc` && \
 install -m 755 -s silice /usr/local/bin && \
 cd $ULX3SBASEDIR && \
 rm -rf /opt/src /opt/micropython /opt/vhd2vl /opt/ghdl-git /opt/ghdlsynth-beta /opt/nextpnr /opt/prjtrellis /opt/yosys /opt/Silice && \
 echo "[i] Success: [build]"

#VOLUME ["/fpga"]
#WORKDIR /opt



