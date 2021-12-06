export PATH=$PATH:~/go/bin
git clone git@github.com:minvws/nl-covid19-travelscan-mobile-core-private.git tmp-clcore
cd tmp-clcore
git checkout proof-identifier-denylist
git submodule init
git submodule update
go mod download golang.org/x/mobile
gomobile init
gomobile bind -target ios -o clcore.framework github.com/minvws/nl-covid19-travelscan-mobile-core
cd ../
rm -rf clcore.framework
cp -R tmp-clcore/clcore.framework .
rm -rf tmp-clcore