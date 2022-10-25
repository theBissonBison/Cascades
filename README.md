###Cascades
#Cascades provides a simple GUI for YT-DLP, with convenient hotkeys to trigger downloads in a jiffy.

- You can download YouTube videos as well as videos from other streaming sites such as Vimeo (and Soundcloud, if that's your thing). It works on the vast majority of these sites - you just have to test it if you want to know if it works for a particular site.
- If you want to download multiple videos at once, use List mode (in the GUI, next to the URL box). This allows you to enter all the URLs at once and only download once to a single batch folder.
- You can configure various downloads folder targets (eg. Videos, Music, Downloads) in settings. You can also set up alternate folders for the fast-download hotkeys (below).


##Hotkeys:
* Alt+D  -- Press when you have a video open in a browser tab, or in clipboard (or in a window that isn't currently selected!). It will open the download prompt and ask for the remaining info to set up the download.
* Alt+V and Alt-M  -- These are the fast download keys, for videos and music respectively. Press these under the same conditions as Alt-D, but instead of opening the dialogue, they will directly download files to your preselected videos and music folders and produce a dialogue on completion.
* Alt+G  -- Opens the basic GUI without looking for URL info (allows you to input manually, or just open it to change settings).
* Alt+A  -- Like Alt-D, but will select [A]ny tab you have open without looking for YouTube. This is what you use to download from non-YouTube sites. It opens the GUI after finding the URL.
* Alt+L  -- Still a tad experimental, this bad boi will jump through every tab in your open browser window and automatically select YouTube URLs into list mode, allowing you to download all the songs from your listening session at once. Only works in Chrome right now :(


Dependencies - YT-DLP and FFMPEG (both included in .msi installer package).