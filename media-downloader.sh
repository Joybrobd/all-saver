#!/data/data/com.termux/files/usr/bin/bash

# Media Downloader for Termux
# Downloads videos or audio from Instagram, YouTube, and Facebook using yt-dlp
# Author: [Your Name]
# License: MIT
# Requirements: Termux, yt-dlp, python, ffmpeg, wget

# Ensure dependencies are installed
command -v yt-dlp >/dev/null 2>&1 || { echo "Error: yt-dlp is not installed. Run 'pip install -U yt-dlp'"; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo "Error: ffmpeg is not installed. Run 'pkg install ffmpeg'"; exit 1; }

# Print header
echo "Media Downloader for Instagram, YouTube, and Facebook"
echo "--------------------------------------------------"

# Get URL (from argument if shared via Termux, else prompt)
if [ -z "$1" ]; then
    read -p "Enter the video URL: " url
else
    url="$1"
fi

# Validate URL
if [[ ! "$url" =~ ^https?:// ]]; then
    echo "Error: Invalid URL. Please enter a valid URL starting with http:// or https://"
    exit 1
fi

# Prompt for download type
echo "Select download type:"
echo "1. Video"
echo "2. Audio (MP3)"
read -p "Enter option (1 or 2): " option

# Set output directory
output_dir="/data/data/com.termux/files/home/storage/shared/Downloads"

# Ensure output directory exists
mkdir -p "$output_dir" || { echo "Error: Failed to create output directory $output_dir"; exit 1; }

# Download based on user choice
case "$option" in
    1)
        echo "Downloading video..."
        yt-dlp -o "$output_dir/%(title)s.%(ext)s" --merge-output-format mp4 "$url"
        ;;
    2)
        echo "Downloading audio..."
        yt-dlp -o "$output_dir/%(title)s.%(ext)s" -x --audio-format mp3 --audio-quality 0 "$url"
        ;;
    *)
        echo "Error: Invalid option. Please select 1 or 2."
        exit 1
        ;;
esac

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Download completed! Files saved to $output_dir"
else
    echo "Error: Download failed. Check the URL, your connection, or ensure the content is publicly accessible."
    exit 1
fi
