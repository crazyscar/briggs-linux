#!/bin/env sh

## 创建erlang运行环境的编译包

TARGET_DIR=${HOME}/opt/src

## 注意，这个版本会影响下面两个ln -s
## observer-2.8.2
## erl_interface-3.10.4 

VERSION="21.2"
SOURCE_LINK="http://erlang.org/download/otp_src_${VERSION}.tar.gz"
FILENAME=$(basename $SOURCE_LINK)
SOURCE_DIR=$TARGET_DIR/${FILENAME%.tar.gz}
BUILD_DIR=otp_build_${VERSION}
ABS_BUILD_DIR=$TARGET_DIR/${BUILD_DIR}
OTP_BUILD_TGZ=${BUILD_DIR}.tgz

function get_deps {
    sudo yum install ncurses-devel java-1.8.0-openjdk-devel openssl-devel m4 -y
}

##0 pre_check
#mkdir -p $TARGET_DIR
#cd $TARGET_DIR
#
##1. download
#[ -e $FILENAME ] || wget $SOURCE_LINK
#
##2. exact
#[ $? == 0 ] && [ -d $SOURCE_DIR ] || tar xvf $FILENAME
#
##3. get deps
#echo "install erlang compile dependencies ..."
#get_deps
#
##4. compile
#echo "compile codes and docs ..."
#cd $SOURCE_DIR && ./configure && make -j2 all docs
#
##5. install with DESTDIR
#[ $? == 0] || { echo "build error, exit"; exit 1; }
#mkdir -p $ABS_BUILD_DIR
#
#echo "install with DESTDIR=${ABS_BUILD_DIR}"
#make install DESTDIR=$ABS_BUILD_DIR
#make install-docs DESTDIR=$ABS_BUILD_DIR

#[ $? == 0] || { echo "make install error, exit"; exit 1; }

#6. 生成压缩包
cd $ABS_BUILD_DIR && mkdir -p $BUILD_DIR
#6.1 update_otp.sh 脚本
cat << EOF > ${BUILD_DIR}/update_otp.sh 
#!/bin/env sh

if [[ \$# < 1 ]];then
   echo "\$0 tgz_file"
   exit 1
fi

OTP_TGZ="\$1"

mkdir -p otp_build
tar -xvf \$OTP_TGZ -C otp_build

cp -rf otp_build/* /
rm -f /usr/local/bin/etop
rm -f /usr/local/bin/erl_call

ln -s /usr/local/lib/erlang/lib/observer-2.8.2/priv/bin/etop /usr/local/bin/etop
ln -s /usr/local/lib/erlang/lib/erl_interface-3.10.4/bin/erl_call /usr/local/bin/erl_call

/usr/local/bin/erl -version
EOF
chmod u+x ${BUILD_DIR}/update_otp.sh

#6.2 合并压缩包
TARGET_TGZ=${ABS_BUILD_DIR}/${BUILD_DIR}/${OTP_BUILD_TGZ}
tar zcvf $TARGET_TGZ usr  ## 只压user目录
tar cvf ${BUILD_DIR}_installer.tar ${BUILD_DIR}
