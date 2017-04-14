#!/bin/bash
#
# Author: Mr.x
#
# Copyright (c) http://mrxing.org
#
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
cd `dirname $0`
EXEC_PATH=`pwd`

LOG()
{
	date >> ${EXEC_PATH}/log/caffe.make.log
	for param in $@; do
		echo "$param" >> ${EXEC_PATH}/log/caffe.make.log
	done
	echo '' >> ${EXEC_PATH}/log/caffe.make.log
}

alias make='make -j8' # TUDO: 根据性能更改线程数

if [ -e ${EXEC_PATH}/log/caffe.make.log ]; then
	mv ${EXEC_PATH}/log/caffe.make.log ${EXEC_PATH}/log/caffe.make.log.old
else
	touch ${EXEC_PATH}/log/caffe.make.log
fi

LOG 'start make all ..'
make all
flag=$?
if [ $flag -eq 0 ] # all
then
	LOG 'make all completed..' 'start make pycaffe ..'
	make pycaffe
	flag=$?
fi
if [ $flag -eq 0 ] # pycaffe
then
	LOG 'make pycaffe completed..' 'start make matcaffe ..'
	make matcaffe
	flag=$?
fi
if [ $flag -eq 0 ] # matcaffe
then
	LOG 'make matcaffe completed..' 'start make test ..'
	make test
	flag=$?
fi
if [ $flag -eq 0 ] # test
then
	LOG 'make test completed..' 'start make runtest ..'
	make runtest
	flag=$?
fi
if [ $flag -eq 0 ] # runtest
then
	LOG 'make runtest completed..' 'start cmake ..'
	cd build
	cmake -D CMAKE_INSTALL_PREFIX=/opt/caffe ..
	flag=$?
fi
if [ $flag -eq 0 ] # cmake
then
	LOG 'cmake completed..' 'start make all ..'
	make all
	flag=$?
fi
if [ $flag -eq 0 ] # all
then
	LOG 'make all completed..' 'start make install ..'
	sudo make install
	flag=$?
fi
if [ $flag -eq 0 ] # install
then
	LOG 'make install completed..' 'start make runtest ..'
	make runtest
	flag=$?
fi
if [ $flag -eq 0 ] # runtest
then
	LOG 'make runtest completed..' '' 'all completed..' ''
	cd ..
fi

exit $flag
