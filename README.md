# medialibrary-tools
Useful scripts for media library management

## und2lang.sh
I hate seeing the "und" language tag and "Audio: Unknown" in Plex
und2lang.sh is a Bash script to search through MKV and MP4 video files and add missing ISO 639-2 language codes to audio tracks. The script can be forced to also set the language for audio tracks that already have a language tag. Use `./und2lang.sh -h` to see available commands.
