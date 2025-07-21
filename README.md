PS4-to-Steam Screenshot Tool
A simple but powerful tool to convert screenshots from your PS4 (or any other source) into the correct format for Steam, preserving the original "Date Taken."

This tool automates the entire process of renaming, resizing, and setting the correct file dates and internal metadata, making your custom screenshots appear perfectly in the Steam Uploader.

Features
Automatic Renaming: Converts your files to Steam's YYYY-MM-DD_#####.jpg format.

Date Preservation: Reads the date from your original PS4 filename (e.g., 20220708...) and applies it to the new file.

Correct Timestamps: Sets the "Date Created," "Date Modified," and internal EXIF "Date Taken" metadata, so Steam shows the correct date.

Automatic Thumbnails: Creates the required 200x112 thumbnails for the Steam Uploader.

Simple Drag-and-Drop: Just drag your folder of screenshots onto the script to start.

Prerequisites
You only need one thing installed on your system:

ImageMagick: A powerful image processing tool.

Download [ImageMagick](https://imagemagick.org/script/download.php) here: 

Important: During installation, make sure to check the box that says "Add application directory to your system path" (or similar).

This tool already includes exiftool.exe so you don't need to install it separately.

How to Use
Download the [latest release](https://github.com/Egan354/PS4-to-Steam-Screenshot-Tool/releases): Go to the Releases page and download the .zip file.

Unzip the folder: Extract the contents to a convenient location, like your Desktop.

Prepare your screenshots: Place all the screenshots you want to convert into a single folder. For best results, make sure your filenames include the date, like Screenshot_20220708155658.jpg.

Drag and Drop: Click and drag your folder of screenshots directly onto the ps4_to_steam_tool.bat file.

Enter the Game ID: A window will pop up asking for the game's App ID. You can find this in the URL of the game's Steam store page (e.g., for Cuphead, the URL is store.steampowered.com/app/268910/, so the ID is 268910).

Done! The script will automatically process everything, open the final folders for you to check, and relaunch Steam. Your screenshots will be ready in the Steam Uploader with the correct dates.

How It Works
This tool uses a combination of a Windows Batch script and two powerful command-line utilities:

ImageMagick: For converting images and creating thumbnails.

ExifTool: For writing the correct "Date Taken" metadata into the image files.

PowerShell: For setting the file system's "Date Created" and "Date Modified" timestamps.

Contributing
Feel free to fork this project, suggest improvements, or submit pull requests.
