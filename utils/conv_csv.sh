#!/bin/bash
mkdir -p ./build

##########################################################################################

cat <<EOF > ./build/dos_bench_embed.md
<style>
.odd {
	background: lightgray;
}
.even {
	background: beige;
}
</style>
EOF

head -n 1 bench.csv | sed 's/,/ | /g ; s/^/| / ; s/$/ |/' >> ./build/dos_bench_embed.md

cat <<EOF >> ./build/dos_bench_embed.md
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
EOF

tail -n +2 bench.csv | sed 's/,/ | /g ; s/^/| / ; s/$/ |/' >> ./build/dos_bench_embed.md
