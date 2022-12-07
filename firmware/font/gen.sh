for c in {a..z} {0..9}; do 
    convert -resize 7x13\! -font Nimbus-Roman -pointsize 10 label:$c xbm:$c > $c.xbm; 
done