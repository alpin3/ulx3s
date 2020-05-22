#!/bin/sh
# EMAIL=mail@example.com ./debianize.sh dist/blah.tar.gz

if [ "x$VERSION" = "x" ]; then
	VERSION=`date '+%Y.%m.%d'`
fi
if [ "x$EMAIL" = "x" ]; then
	EMAIL=unknown@example.com
fi
if [ "x$TARFILE" = "x" ]; then
	TARFILE="ulx3s-toolchain-$VERSION.tar.gz"
fi

set -x

TMPWORK=tmpdeb
mkdir -p $TMPWORK/usr
tar -C $TMPWORK/usr -xvz --strip-components=1 -f $1
cd $TMPWORK/usr
cd share
rm -rf ca-certificates info man perl5
cd .. # usr
pwd
mv ghdl share
cd .. # root
pwd
mkdir -p etc/profile.d
cat <<EOF > etc/profile.d/ulx3s-linux.sh
#!/bin/sh

export GHDL_PREFIX=/usr/share/ghdl/lib/ghdl
EOF
chmod +x etc/profile.d/ulx3s-linux.sh
tar -cvz --owner root --group root -f ../$TARFILE .
cd ..
fakeroot alien --target=amd64 --description="ulx3s open source toolchain" --version=$VERSION $TARFILE

