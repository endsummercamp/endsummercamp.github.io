
for file in $(find . -name "*.png"); do
    echo "Processing $file"
    magick $file -define webp:lossless=true -resize 400x400 $file.webp
done