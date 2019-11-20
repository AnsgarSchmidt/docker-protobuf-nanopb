FROM    ubuntu:20.04

RUN     apt update && apt upgrade -y
RUN     apt install -y autoconf automake libtool curl make g++ unzip build-essential mc vim git python python-pip

RUN     git clone -b master --single-branch --depth 1 https://github.com/google/protobuf.git
WORKDIR protobuf
RUN     ./autogen.sh
RUN     ./configure
RUN     make -j 10
RUN     make install
RUN     ldconfig
WORKDIR python
ENV     PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
ENV     PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=2
RUN     python setup.py build   --cpp_implementation 
RUN     python setup.py test    --cpp_implementation
RUN     python setup.py install --cpp_implementation

WORKDIR /
RUN     git clone -b master --single-branch --depth 1 https://github.com/nanopb/nanopb.git
WORKDIR /nanopb/generator/proto
RUN     make -j 10

WORKDIR /
ADD     generateCode.sh generateCode.sh
RUN     chmod 700 /generateCode.sh
CMD     /generateCode.sh
