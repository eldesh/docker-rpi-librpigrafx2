
FROM resin/rpi-raspbian:stretch-20180228

ARG PREFIX
ARG PKG_CONFIG_PATH=/opt/vc/lib/pkgconfig:${PREFIX}/lib/pkgconfig:/usr/lib/pkgconfig
ARG CFLAGS="-O2 -ffast-math -fPIC -I${PREFIX}/include -I/opt/vc/include -L${PREFIX}/lib -L/opt/vc/lib"
ARG LDFLAGS="-L${PREFIX}/lib -L/opt/vc/lib"
ARG BUILD=armv6-rpi-linux-gnueabihf
ARG HOST=armv6-rpi-linux-gnueabihf

ENV PKG_CONFIG_PATH=${PKG_CONFIG_PATH}

WORKDIR /root/lib
USER root

RUN apt-get update -y \
 && apt-get install -y \
      git \
      zlib1g \
      libpng-dev \
      flex \
      make \
      libraspberrypi-dev \
      bzip2 \
 && curl -SL http://jaist.dl.sourceforge.net/project/cunit/CUnit/2.1-3/CUnit-2.1-3.tar.bz2 | tar -jxf - \
 && cd CUnit-2.1-3 \
   && autoreconf -i -f \
   && ./configure --prefix=${PREFIX} --build=${BUILD} --host=${HOST} \
   && make \
   && make install \
 && cd .. \
 && git clone git@github.com:Idein/librpicam.git \
 && cd librpicam \
   && autoreconf -i -m \
   && ./configure --prefix=${PREFIX} --build=${BUILD} --host=${HOST} \
   && make \
   && make install \
 && cd .. \
 && git clone https://github.com/Idein/librpiraw.git \
 && cd librpiraw \
   && autoreconf -i -m \
   && ./configure --prefix=${PREFIX} --build=${BUILD} --host=${HOST} \
   && make \
   && make install \
 && cd .. \
 && git clone https://github.com/Terminus-IMRC/qpu-assembler2.git \
 && cd qpu-assembler2 \
   && make \
   && make install PREFIX=${PREFIX} \
 && cd .. \
 && git clone https://github.com/Terminus-IMRC/qpu-bin-to-hex.git \
 && cd qpu-bin-to-hex \
   && make \
   && make install PREFIX=${PREFIX} \
 && cd .. \
 && git clone https://github.com/Idein/qmkl.git \
 && cd qmkl \
   && cmake -D CMAKE_C_COMPILER=${CC} -D CMAKE_INSTALL_PREFIX:PATH=${PREFIX} . \
   && make \
   && make install \
 && cd .. \
 && git clone https://github.com/Terminus-IMRC/librpigrafx2.git \
 && cd librpigrafx2 \
   && autoreconf -i -m \
   && ./configure --prefix=${PREFIX} --build=${BUILD} --host=${HOST} \
   && make \
   && make install \
 && cd .. \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]

