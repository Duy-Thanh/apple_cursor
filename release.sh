#!/bin/bash
# A script for preparing binaries for version release of Apple Cursors, by Abdulkaiz Khatri


declare -A names
names["macOS-BigSur"]="macOS Big Sur Cursors"
names["macOS-BigSur-White"]="macOS Big Sur White Cursors"
names["macOS-Monterey"]="macOS Monterey Cursors"
names["macOS-Monterey-White"]="macOS Monterey White Cursors"

# Cleanup old builds
rm -rf themes bin

# Building macOS XCursor binaries
for key in "${!names[@]}";
do
    comment="${names[$key]}";
    ctgen build.toml -p x11 -d "bitmaps/$key" -n "$key" -c "$comment" &
    PID=$!
    wait $PID
done


# Building macOS Windows binaries
for key in "${!names[@]}";
do
    comment="${names[$key]}";
    ctgen build.toml -p windows -s 16 -d "bitmaps/$key" -n "$key-Small" -c "$comment" &
    ctgen build.toml -p windows -s 24 -d "bitmaps/$key" -n "$key-Regular" -c "$comment" &
    ctgen build.toml -p windows -s 32 -d "bitmaps/$key" -n "$key-Large" -c "$comment" &
    ctgen build.toml -p windows -s 48 -d "bitmaps/$key" -n "$key-Extra-Large" -c "$comment" &
    PID=$!
    wait $PID
done

# Compressing Binaries
mkdir -p bin
cd themes

for key in "${!names[@]}";
do
    tar -czvf "../bin/${key}.tar.gz" "${key}" &
    PID=$!
    wait $PID
done

for key in "${!names[@]}";
do
    zip -rv "../bin/${key}-Windows.zip" "${key}-Small-Windows" "${key}-Regular-Windows" "${key}-Large-Windows" "${key}-Extra-Large-Windows" &
    PID=$!
    wait $PID
done

cd ..

echo "$x_bin"
