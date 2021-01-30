# StylishMail

### [Downloads](https://github.com/Shanghi/StylishMail/releases)

***

## Purpose:
This will let you add text colors and game textures to your mail. The recipient doesn't need the addon. While the added images won't be pixel perfect (because things like the viewer's mail font and UI scale settings affect positions), it should be close enough to consider the mail to be stylish.

## Using:
To open the preview window, click the magnifying glass button at the top left of the mail window.

### Ways to use colors:
**`<c=white>`** this text would be white - can be any html/css color name
<br/>**`<c=epic>`** colored by item quality - can be poor/common/uncommon/rare/epic/legendary/artifact
<br/>**`<c=ff0000>`** [hex-style color code](http://www.rapidtables.com/web/color/color-picker.htm)
<br/>**`</c>`** resets the color completely and using it is optional - it's OK to switch colors without it

Example: `normal text <c=red>now red text <c=ffff00>now it's yellow</c> now it's back to normal`

### Ways to add images:
First you'll need to get the name and path of a texture (how is explained later). An example path (capitalization doesn't matter): **`Interface\Icons\Spell_Magic_PolymorphChicken`**

To add a square image the same size as the text, like an emoticon:
<br/>**`<img=Interface\Icons\Spell_Magic_PolymorphChicken>`**

To set a width and height (the width's maximum is 360):
<br/>**`<img=Interface\Icons\Spell_Magic_PolymorphChicken w=128 h=128>`**

For a rectangle the same height as the text, set only the width (2 is around 2 times long):
<br/>**`<img=Interface\Icons\Spell_Magic_PolymorphChicken w=2>`**

To move its position, set x and y. It will still leave an empty spot at the original position that text will skip over, so you may want to put large images at the end then move them up.
<br/>**`x=10`** would move it right and **`x=-10`** would move it left.
<br/>**`y=10`** would move it up and **`y=-10`** would move it down.
<br/>Full example: **`<img=Interface\Icons\Spell_Magic_PolymorphChicken h=64 w=64 x=35 y=8>`**

Warning! With stacked images, there doesn't seem to be a useful rule about which is shown on top. It can be different for them or when you restart the game, so it's only safe to put a 2nd image on a transparent section of another.

### Ways to add backgrounds:
These are just normal images with their size and position automatically calculated.

You can add a background 3 ways.
1. On the preview window, pick one from the dropdown menu. It will only be used if the preview window is opened so that it won't be accidentally added.
2. Use the tag **`<bg1=TexturePath>`** anywhere in the message. This will make the texture big and show it in the middle. It's best for images that have transparent backgrounds (like a fancy magic symbol) because it can't take up the entire width.
3. Use the tag **`<bg2=TexturePath>`** anywhere in the message. This will put 2 copies of the image side by side to fill up the width.

If you don't want a background to take up the whole height of the page, you can add a top or bottom setting to tell where to start and how tall to make it.
<br/>Examples: **`<bg2=TexturePath top=250>`** or **`<bg1=TexturePath bottom=200>`**

You can paste these anywhere into your mail (one at a time) to see examples of every combination:
<br/>**`<bg1=spells/AuraRune5Green>`**
<br/>**`<bg1=World\KALIMDOR\Darkshore\PassiveDoodads\DarkshoreTrees\DarkshoreTree01_Vines top=175>`**
<br/>**`<bg1=World\KALIMDOR\Ashenvale\PassiveDoodads\AshenvaleTreeLogs\AshenvaleMidTree01 bottom=120>`**
<br/>**`<bg2=World/GOOBER/G_GRAVEBURSTTANARIS>`**
<br/>**`<bg2=World\GOOBER\mm_xmas_treelights_01 top=90>`**
<br/>**`<bg2=creature/bonegolem/BoneGolemSkullbag bottom=200>`**

### Saving and Loading
Letter drafts are saved/loaded/deleted by the mail's subject, so you must set one first.

### How to extract and view all game textures
This looks like a lot of steps, but every click is explained!
1. Download MPQ Editor at http://www.zezula.net/en/mpq/download.html and extract it anywhere (no install needed).
2. Open it and at the top left pick MPQs > Open MPQs.
3. Select all the MPQ files in the World of Warcraft/Data folder and click open.
4. On the new window that popped up, right click anywhere in the top left section (Base MPQ(s)) and pick "Add MPQs..."
5. Open the Data/enUS folder (enUS for US clients, so yours may be enGB, frFR, etc) and select and open all the MPQ files there.
6. On the right side under Additional Options, check "Merged Mode" then click OK.
7. From the top bar, pick Tools > Search File(s).
8. On the Find files line, put **`*.blp`** then click Start search.
9. When it's finally done it will show a file count at the bottom. Click the top file in the list, then press shift+end on the keyboard to select them all.
10. Right click on any of them and pick "Extract..."
11. Set a folder they'll go into then click OK.
12. You can close the program and delete it now.

Convert those .blp files to .png to view them easily:
1. Download BLP2PNG at http://www.wowinterface.com/downloads/info6127-BLP2PNG.html and extract it anywhere (no install needed).
2. Drag the folder that all the extracted files went into onto that program's icon.
3. When it's done, you might want to delete all the unneeded .blp files.

Now you can browse through the files looking for a nice picture. Capitalization doesn't matter and you can use **`/`** or **`\`** or **`\\`** in the path. Here's some examples:
<br/>**`Environments\Stars\Auchindoun_VortexCloud01`**
<br/>**`interface/cursor/cast`**
<br/>**`WORLD\\SCALE\\1_NULL`**

## Screenshots:
![!](https://i.imgur.com/ykGKIDe.jpg)
![!](https://i.imgur.com/PPaIKtC.jpg)
![!](https://i.imgur.com/2OpJ67M.jpg)
![!](https://i.imgur.com/zYbRTDN.jpg)
