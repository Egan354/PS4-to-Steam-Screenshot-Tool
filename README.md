# PS4-to-Steam Screenshot Tool

A simple but effective tool to convert screenshots from your PS4 into the correct format for Steam, while preserving the original "Date Taken."

This tool automates the process of renaming files, generating thumbnails, and setting correct timestamps and metadata, making your custom screenshots appear correctly in the Steam Uploader.

---

## Features

- **Automatic Renaming**  
  Converts filenames into Steam's required `YYYY-MM-DD_#####.jpg` format.

- **Date Extraction**  
  Parses the original date from PS4 filenames (e.g., `20220708...`) and applies it to the new file.

- **Accurate Timestamps**  
  Sets `Date Created`, `Date Modified`, and the EXIF `Date Taken` metadata.

- **Thumbnail Generation**  
  Automatically creates 200x112 thumbnails required for the Steam Uploader.

- **Drag-and-Drop Simplicity**  
  Process an entire folder by simply dragging it onto the script.

---

## Prerequisites

The tool requires [ImageMagick](https://imagemagick.org/script/download.php) to be installed.

**Installation Note:**  
During setup, ensure you check the option to _"Add application directory to your system path"_.

> `exiftool.exe` is already included, so no additional installation is required.

---

## Usage

1. **Download the [latest release](https://github.com/Egan354/PS4-to-Steam-Screenshot-Tool/releases)**  
   Grab the `.zip` file from the Releases section.

2. **Extract the files**  
   Unzip the contents to a folder of your choice (e.g., Desktop).

3. **Prepare your screenshots**  
   Place all screenshots to be converted in a single folder.  
   For best results, filenames should include a timestamp like `Screenshot_20220708155658.jpg`.

4. **Run the tool**  
   Drag your screenshot folder onto `ps4_to_steam_tool.bat`.

5. **Enter the Steam App ID**  
   When prompted, input the App ID of the game.  
   For example, Cuphead’s store URL is `https://store.steampowered.com/app/268910/`, so the App ID is `268910`.

6. **Done**  
   The tool will process your files, open the output folder, and relaunch Steam.  
   Your screenshots will be ready for upload with the correct metadata.

---

## How It Works

This tool is built using:

- **ImageMagick** for image conversion and thumbnail generation  
- **ExifTool** for writing EXIF metadata  
- **PowerShell** for setting filesystem-level timestamps

---

## Contributing

Contributions are welcome. Feel free to fork the repository, submit issues, or open pull requests with improvements or bug fixes.
