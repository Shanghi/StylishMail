-- local references
local find, match, format, gsub, lower = string.find, string.match, string.format, string.gsub, string.lower
local ceil = math.ceil
local StylishMailPreviewBodyText = StylishMailPreviewBodyText
local SendMailBodyEditBox = SendMailBodyEditBox

----------------------------------------------------------------------------------------------------
-- tag replacements
----------------------------------------------------------------------------------------------------
local BACKGROUND_SIZE = 364 -- the height of a full background

local chosenBackground = 1 -- background value selected in the dropdown menu

local BackgroundType = {
	STATIONERY=1,    -- stationery textures of a large left texture and smaller right texture
	SINGLE=2,        -- a single, centered texture - can't fill up entire width
	SINGLE_BOTTOM=3, -- like SINGLE, but not full height - starts at the bottom
	SINGLE_TOP=4,    -- like SINGLE, but not full height - starts at the top
	DOUBLE=5,        -- the same texture added twice with equal widths to fill up the entire width
	DOUBLE_BOTTOM=6, -- like DOUBLE, but not full height - starts at the bottom
	DOUBLE_TOP=7,    -- like DOUBLE, but not full height - starts at the top
}

local BackgroundList = {
--  name                texture                                   type                        height
	{"No background"},
	{"Auction",          "Interface/Stationery/AuctionStationery", BackgroundType.STATIONERY},
	{"Christmas",        "Interface/Stationery/Stationery_Chr",    BackgroundType.STATIONERY},
	{"Illidan",          "Interface/Stationery/Stationery_ill",    BackgroundType.STATIONERY},
	{"Orgrimmar",        "Interface/Stationery/Stationery_OG",     BackgroundType.STATIONERY},
	{"Thunderbluff",     "Interface/Stationery/Stationery_TB",     BackgroundType.STATIONERY},
	{"Undercity",        "Interface/Stationery/Stationery_UC",     BackgroundType.STATIONERY},
	{"Valentine's",      "Interface/Stationery/Stationery_Val",    BackgroundType.STATIONERY},
	{"Solid: Black",     "Tileset/Generic/Black",                  BackgroundType.DOUBLE},
	{"Solid: Blue",      "Tileset/Generic/Blue",                   BackgroundType.DOUBLE},
	{"Solid: Burgundy",  "Tileset/Generic/burgundy",               BackgroundType.DOUBLE},
	{"Solid: Charcoal",  "Tileset/Generic/Charcoal",               BackgroundType.DOUBLE},
	{"Solid: Gray",      "Tileset/Generic/Grey",                   BackgroundType.DOUBLE},
	{"Solid: Green",     "Tileset/Generic/Green",                  BackgroundType.DOUBLE},
	{"Solid: Red",       "Tileset/Generic/Red",                    BackgroundType.DOUBLE},
	{"Solid: Sky Blue",  "Tileset/Generic/WaterBlue",              BackgroundType.DOUBLE},
	{"Solid: Yellow",    "Tileset/Generic/Yellow",                 BackgroundType.DOUBLE},
}

local ColorName = {
	--item qualities
	poor="9d9d9d",             common="ffffff",            uncommon="1eff00",             rare="0070dd",
	epic="a335ee",             legendary="ff8000",         artifact="e6cc80",             heirloom="e6cc80",
	--html/css names - http://www.csgnetwork.com/csgcolorsel140.html
	aliceblue="f0f8ff",        antiquewhite="faebd7",      aqua="00ffff",                 aquamarine="7fffd4",
	azure="f0ffff",            beige="f5f5dc",             bisque="ffe4c4",               black="000000",
	blanchedalmond="ffebcd",   blue="0000ff",              blueviolet="8a2be2",           brown="a52a2a",
	burlywood="deb887",        cadetblue="5f9ea0",         chartreuse="7fff00",           chocolate="d2691e",
	coral="ff7f50",            cornflowerblue="6495ed",    cornsilk="fff8dc",             crimson="dc143c",
	cyan="00ffff",             darkblue="00008b",          darkcyan="008b8b",             darkgoldenrod="b8860b",
	darkgray="a9a9a9",         darkgreen="006400",         darkgrey="a9a9a9",             darkkhaki="bdb76b",
	darkmagenta="8b008b",      darkolivegreen="556b2f",    darkorange="ff8c00",           darkorchid="9932cc",
	darkred="8b0000",          darksalmon="e9967a",        darkseagreen="8fbc8f",         darkslateblue="483d8b",
	darkslategray="2f4f4f",    darkslategrey="2f4f4f",     darkturquoise="00ced1",        darkviolet="9400d3",
	deeppink="ff1493",         deepskyblue="00bfff",       dimgray="696969",              dimgrey="696969",
	dodgerblue="1e90ff",       firebrick="b22222",         floralwhite="fffaf0",          forestgreen="228b22",
	fuchsia="ff00ff",          gainsboro="dcdcdc",         ghostwhite="f8f8ff",           gold="ffd700",
	goldenrod="daa520",        gray="808080",              green="008000",                greenyellow="adff2f",
	grey="808080",             honeydew="f0fff0",          hotpink="ff69b4",              indianred="cd5c5c",
	indigo="4b0082",           ivory="fffff0",             khaki="f0e68c",                lavender="e6e6fa",
	lavenderblush="fff0f5",    lawngreen="7cfc00",         lemonchiffon="fffacd",         lightblue="add8e6",
	lightcoral="f08080",       lightcyan="e0ffff",         lightgoldenrodyellow="fafad2", lightgray="d3d3d3",
	lightgreen="90ee90",       lightgrey="d3d3d3",         lightpink="ffb6c1",            lightsalmon="ffa07a",
	lightseagreen="20b2aa",    lightskyblue="87cefa",      lightslategray="778899",       lightslategrey="778899",
	lightsteelblue="b0c4de",   lightyellow="ffffe0",       lime="00ff00",                 limegreen="32cd32",
	linen="faf0e6",            magenta="ff00ff",           maroon="800000",               mediumaquamarine="66cdaa",
	mediumblue="0000cd",       mediumorchid="ba55d3",      mediumpurple="9370db",         mediumseagreen="3cb371",
	mediumslateblue="7b68ee",  mediumspringgreen="00fa9a", mediumturquoise="48d1cc",      mediumvioletred="c71585",
	midnightblue="191970",     mintcream="f5fffa",         mistyrose="ffe4e1",            moccasin="ffe4b5",
	navajowhite="ffdead",      navy="000080",              oldlace="fdf5e6",              olive="808000",
	olivedrab="6b8e23",        orange="ffa500",            orangered="ff4500",            orchid="da70d6",
	palegoldenrod="eee8aa",    palegreen="98fb98",         paleturquoise="afeeee",        palevioletred="db7093",
	papayawhip="ffefd5",       peachpuff="ffdab9",         peru="cd853f",                 pink="ffc0cb",
	plum="dda0dd",             powderblue="b0e0e6",        purple="800080",               rebeccapurple="663399",
	red="ff0000",              rosybrown="bc8f8f",         royalblue="4169e1",            saddlebrown="8b4513",
	salmon="fa8072",           sandybrown="f4a460",        seagreen="2e8b57",             seashell="fff5ee",
	sienna="a0522d",           silver="c0c0c0",            skyblue="87ceeb",              slateblue="6a5acd",
	slategray="708090",        slategrey="708090",         snow="fffafa",                 springgreen="00ff7f",
	steelblue="4682b4",        tan="d2b48c",               teal="008080",                 thistle="d8bfd8",
	tomato="ff6347",           turquoise="40e0d0",         violet="ee82ee",               wheat="f5deb3",
	white="ffffff",            whitesmoke="f5f5f5",        yellow="ffff00",               yellowgreen="9acd32",
}

-- replace special tags in the text - is_body is if it's the body of the mail instead of the subject
local function ExpandText(text, is_body)
	local background, background_type, background_height -- for custom backgrounds

	if text ~= "" then
		text = gsub(text, "<([^<>]+)>", function(tag)
			tag = lower(tag)
			-- clear color
			if tag == "/c" then
				return "|r"
			-- set color
			elseif find(tag, "^c=.+") then
				local color = lower(match(tag, "^c.-=(.+)"))
				color = ColorName[color] or (find(color, "^%x%x%x%x%x%x$") and color)
				return color and "|cff"..color or "<"..tag..">"
			-- set a texture
			elseif find(tag, "^img=.+") then
				local texture, width, height, x, y
				for field in tag:gmatch("%S+") do
					local key, value = match(field, "^(.-)=(.*)")
					if     key == "img" then texture = value
					elseif key == "w"   then width   = value
					elseif key == "h"   then height  = value
					elseif key == "x"   then x       = value
					elseif key == "y"   then y       = value
					elseif texture and not key and not width and not height and not x and not y then
						texture = texture .. " " .. field -- texture name had a space, so add the rest
					end
				end
				if texture then
					texture = gsub(texture, "[\\]+", "/")
					height = tonumber(height) or 0
					width = tonumber(width) or 0
					x = tonumber(x) or 0
					y = tonumber(y) or 0
					if height == 0 then
						if width > 22 then
							width = 22
						end
					elseif width > 360 then
						width = 360
					end
					return format("|T%s:%d:%d:%d:%d|t", texture, height, width, x, y)
				end
			-- set a background
			elseif find(tag, "^bg[12]=.+") then
				background = tag:sub(5)
				local texture, position, height
				texture, position, height = background:match("(.+)%s+(%a+)=(%d+)%s*$")
				texture = texture or background
				background = gsub(texture, "%s+$", "")
				background_height = tonumber(height) or BACKGROUND_SIZE
				if position == "top" then
					background_type = tag:sub(3,3) == "1" and BackgroundType.SINGLE_TOP or BackgroundType.DOUBLE_TOP
				elseif position == "bottom" then
					background_type = tag:sub(3,3) == "1" and BackgroundType.SINGLE_BOTTOM or BackgroundType.DOUBLE_BOTTOM
				else
					background_type = tag:sub(3,3) == "1" and BackgroundType.SINGLE or BackgroundType.DOUBLE
				end
				return ""
			end
			return "<" .. tag .. ">"
		end)
		text = gsub(text, "[\n]+$", "") -- remove trailing lines
	end

	-- set the background - dropdown backgrounds will only be used if the preview window is open
	-- Height: 331 usable + 14 above = 345
	-- Width : 360 usable safely + 23 to the right of that + 14 left = 397
	if is_body and (background or (chosenBackground ~= 1 and StylishMailPreviewFrame:IsVisible())) then
		-- dropdown style override any others (if they're allowed)
		if chosenBackground ~= 1 and StylishMailPreviewFrame:IsVisible() then
			local info = BackgroundList[chosenBackground]
			background = info[2]
			background_type = info[3]
			background_height = info[4] or BACKGROUND_SIZE
		end
		StylishMailPreviewBodyText:SetText(text) -- must set so any previous background is removed
		local height = StylishMailPreviewBodyText:GetHeight()
		local lines = height > 3 and ceil(StylishMailPreviewBodyText:GetHeight()/15) or 1
		local y = lines * 20
		if background_type == BackgroundType.STATIONERY then -- special calculations because the right side is smaller
			text = format("%s\n|T%s1:%d:340:-15:%d|t\n|T%s2:%d:85:324:%d|t", text, background, BACKGROUND_SIZE, 15+y, background, BACKGROUND_SIZE, BACKGROUND_SIZE+15+y)
		elseif background_type == BackgroundType.SINGLE then -- shorter than others - it's more important not to cut off the bottom
			text = format("%s\n|T%s:332:360:8:%d|t", text, background, 15+y)
		elseif background_type == BackgroundType.SINGLE_TOP then
			text = format("%s\n|T%s:%d:360:8:%d|t", text, background, background_height, 15+y)
		elseif background_type == BackgroundType.SINGLE_BOTTOM then
			local diff = BACKGROUND_SIZE - background_height
			y = y - diff
			text = format("%s\n|T%s:%d:360:8:%d|t", text, background, background_height, 15+y)
		elseif background_type == BackgroundType.DOUBLE then
			text = format("%s\n|T%s:%d:200:-16:%d|t\n|T%s:%d:200:184:%d|t", text, background, BACKGROUND_SIZE, 15+y, background, BACKGROUND_SIZE, BACKGROUND_SIZE+15+y)
		elseif background_type == BackgroundType.DOUBLE_TOP then
			local diff = BACKGROUND_SIZE - background_height
			text = format("%s\n|T%s:%d:200:-16:%d|t\n|T%s:%d:200:184:%d|t", text, background, background_height, 15+y, background, background_height, BACKGROUND_SIZE+15-diff+y)
		elseif background_type == BackgroundType.DOUBLE_BOTTOM then
			local diff = BACKGROUND_SIZE - background_height
			y = y - diff
			text = format("%s\n|T%s:%d:200:-16:%d|t\n|T%s:%d:200:184:%d|t", text, background, background_height, 15+y, background, background_height, BACKGROUND_SIZE+15-diff+y)
		end
	end
	return text
end

----------------------------------------------------------------------------------------------------
-- setup
----------------------------------------------------------------------------------------------------
-- allow longer messages and subjects
SendMailBodyEditBox:SetMaxLetters(5000)
SendMailSubjectEditBox:SetMaxLetters(256)

do
	--------------------------------------------------
	-- preview frame setup - mostly from MailFrame.lua
	--------------------------------------------------
	local itemRowCount = 1
	local marginxl = 23 + 4;
	local marginxr = 43 + 4;
	local areax = StylishMailPreviewFrame:GetWidth() - marginxl - marginxr;
	local iconx = OpenMailAttachmentButton1:GetWidth() + 2;
	local icony = OpenMailAttachmentButton1:GetHeight() + 2;
	local gapx1 = floor((areax - (iconx * ATTACHMENTS_PER_ROW_RECEIVE)) / (ATTACHMENTS_PER_ROW_RECEIVE - 1));
	local gapx2 = floor((areax - (iconx * ATTACHMENTS_PER_ROW_RECEIVE) - (gapx1 * (ATTACHMENTS_PER_ROW_RECEIVE - 1))) / 2);
	local gapy1 = 3;
	local gapy2 = 3;
	local areay = gapy2 + StylishMailPreviewHelpText:GetHeight() + gapy2 + (icony * itemRowCount) + (gapy1 * (itemRowCount - 1)) + gapy2;
	local indentx = marginxl + gapx2;
	local indenty = 103 + gapy2;
	local tabx = (iconx + gapx1);
	local taby = (icony + gapy1);
	local scrollHeight = 305 - areay;
	if (scrollHeight > 256) then
		scrollHeight = 256;
		areay = 305 - scrollHeight;
	end
	StylishMailPreviewScrollFrame:SetHeight(scrollHeight);
	StylishMailPreviewScrollChildFrame:SetHeight(scrollHeight);
	StylishMailPreviewHorizontalBarLeft:SetPoint("TOPLEFT", "StylishMailPreviewFrame", "BOTTOMLEFT", 15, 44 + areay);
	StylishMailScrollBarBackgroundTop:SetHeight(min(scrollHeight, 256));
	StylishMailScrollBarBackgroundTop:SetTexCoord(0, 0.484375, 0, min(scrollHeight, 256) / 256);
	StylishMailStationeryBackgroundLeft:SetHeight(scrollHeight);
	StylishMailStationeryBackgroundLeft:SetTexCoord(0, 1.0, 0, min(scrollHeight, 256) / 256);
	StylishMailStationeryBackgroundRight:SetHeight(scrollHeight);
	StylishMailStationeryBackgroundRight:SetTexCoord(0, 1.0, 0, min(scrollHeight, 256) / 256);

	--------------------------------------------------
	-- preview frame: background and text
	--------------------------------------------------
	StylishMailStationeryBackgroundLeft:SetTexture("Interface/Stationery/STATIONERYTEST1");
	StylishMailStationeryBackgroundRight:SetTexture("Interface/Stationery/STATIONERYTEST2");
	StylishMailPreviewSender:SetText(UnitName("player"))
	StylishMailPreviewHelpText:SetJustifyH("LEFT")
	StylishMailPreviewHelpText:SetText(
		"|cffffff00Colors:|r |cff00ff00<c=red>|rtext|cff00ff00</c>|r or |cff00ff00<c=ff0000>|rtext|cff00ff00</c>|r\n"..
		"|cffffff00Images:|r |cff00ff00<img=TexturePath h=64 w=64 x=0 y=0>|r\n"..
		"|cffffff00Background:|r |cff00ff00<bg1=TexturePath top=250>|r\n"..
		"|cffffff00Background:|r |cff00ff00<bg2=TexturePath bottom=250>|r\n"..
		"(h/w/x/y/top/bottom are optional and can be left off)")

	--------------------------------------------------
	-- preview frame: background dropdown menu
	--------------------------------------------------
	local function StylishMailPreviewDropDown_OnClick()
		chosenBackground = this.value
		UIDropDownMenu_SetSelectedValue(StylishMailPreviewDropDown, chosenBackground)
		StylishMailPreviewBodyText:SetText(ExpandText(SendMailBodyEditBox:GetText(), true))
	end

	local function StylishMailPreviewDropDown_Initialize()
		local info
		for i=1,#BackgroundList do
			info = UIDropDownMenu_CreateInfo()
			info.checked = nil
			info.func    = StylishMailPreviewDropDown_OnClick
			info.value   = i
			info.text    = BackgroundList[i][1]
			UIDropDownMenu_AddButton(info)
		end
	end

	UIDropDownMenu_SetWidth(115, StylishMailPreviewDropDown)
	UIDropDownMenu_Initialize(StylishMailPreviewDropDown, StylishMailPreviewDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(StylishMailPreviewDropDown, 1);
	chosenBackground = 1

	--------------------------------------------------
	-- preview frame: save, load, delete buttons
	--------------------------------------------------
	local function UpdateSaveButton()
		if SendMailSubjectEditBox:GetText() ~= "" then
			StylishMailPreviewSaveButton:Enable()
		else
			StylishMailPreviewSaveButton:Disable()
		end
	end
	local function UpdateLoadButton()
		if StylishMailSave then
			StylishMailPreviewLoadButton:Enable()
		else
			StylishMailPreviewLoadButton:Disable()
		end
	end
	local function UpdateDeleteButton()
		if StylishMailSave and StylishMailSave[SendMailSubjectEditBox:GetText()] then
			StylishMailPreviewDeleteButton:Enable()
		else
			StylishMailPreviewDeleteButton:Disable()
		end
	end

	-- load menu
	local loadMenuFrame = CreateFrame("Frame", "StylishMailLoadMenu", UIParent, "UIDropDownMenuTemplate")
	local loadMenuTable

	local function StylishMailPreviewLoadButton_OnClick()
		local info = StylishMailSave and StylishMailSave[this.value]
		if info then
			chosenBackground = info[1]
			UIDropDownMenu_SetSelectedValue(StylishMailPreviewDropDown, chosenBackground)
			UIDropDownMenu_SetText(BackgroundList[chosenBackground][1], StylishMailPreviewDropDown)
			SendMailSubjectEditBox:SetText(this.value)
			StylishMailPreviewSubject:SetText(ExpandText(SendMailSubjectEditBox:GetText()))
			SendMailBodyEditBox:SetText(info[2])
			StylishMailPreviewBodyText:SetText(ExpandText(SendMailBodyEditBox:GetText(), true))
			UpdateSaveButton()
			UpdateDeleteButton()
		end
	end

	local function BuildLoadMenu(force)
		if not loadMenuTable or force then
			CloseDropDownMenus()
			loadMenuTable = nil
			if StylishMailSave then
				loadMenuTable = {}
				for subject in pairs(StylishMailSave) do
					loadMenuTable[#loadMenuTable+1] = {
						func         = StylishMailPreviewLoadButton_OnClick,
						value        = subject,
						text         = subject,
						notCheckable = 1,
					}
				end
				loadMenuTable[#loadMenuTable+1] = {notCheckable=1, text="Close"}
			end
		end
	end

	-- handle clicks on the buttons
	StylishMailPreviewSaveButton:SetScript("OnClick", function()
		StylishMailSave = StylishMailSave or {}
		local subject = SendMailSubjectEditBox:GetText()
		StylishMailSave[subject] = {
			UIDropDownMenu_GetSelectedValue(StylishMailPreviewDropDown), SendMailBodyEditBox:GetText()
		}
		StylishMailPreviewSavedText:Show()
		UpdateLoadButton()
		UpdateDeleteButton()
		BuildLoadMenu(true)
	end)
	StylishMailPreviewLoadButton:SetScript("OnClick", function()
		if StylishMailSave and loadMenuTable then
			CloseDropDownMenus()
			loadMenuFrame:SetPoint("BOTTOMLEFT", StylishMailPreviewLoadButton, "BOTTOMLEFT")
			EasyMenu(loadMenuTable, loadMenuFrame, StylishMailPreviewLoadButton, 0, 0, "MENU")
		end
	end)
	StylishMailPreviewDeleteButton:SetScript("OnClick", function()
		local subject = SendMailSubjectEditBox:GetText()
		if StylishMailSave[subject] then
			StylishMailSave[subject] = nil
			if next(StylishMailSave) == nil then
				StylishMailSave = nil
			end
			BuildLoadMenu(true)
			UpdateLoadButton()
			UpdateDeleteButton()
			StylishMailPreviewSavedText:Hide()
		end
	end)

	--------------------------------------------------
	-- preview frame: update it as they type
	--------------------------------------------------
	local OriginalSubjectTextChanged = SendMailSubjectEditBox:GetScript("OnTextChanged")
	SendMailSubjectEditBox:SetScript("OnTextChanged", function()
		OriginalSubjectTextChanged(this)
		if StylishMailPreviewFrame:IsVisible() then
			StylishMailPreviewSubject:SetText(ExpandText(SendMailSubjectEditBox:GetText()))
			UpdateSaveButton()
			UpdateDeleteButton()
			StylishMailPreviewSavedText:Hide()
		end
	end)

	local OriginalBodyTextChanged = SendMailBodyEditBox:GetScript("OnTextChanged")
	SendMailBodyEditBox:SetScript("OnTextChanged", function()
		OriginalBodyTextChanged(this)
		if StylishMailPreviewFrame:IsVisible() then
			StylishMailPreviewBodyText:SetText(ExpandText(SendMailBodyEditBox:GetText(), true))
			StylishMailPreviewSavedText:Hide()
		end
	end)

	--------------------------------------------------
	-- preview frame: showing it
	--------------------------------------------------
	StylishMailPreviewFrame:SetScript("OnShow", function()
		BuildLoadMenu()
		UpdateSaveButton()
		UpdateLoadButton()
		UpdateDeleteButton()
		StylishMailPreviewSubject:SetText(ExpandText(SendMailSubjectEditBox:GetText()))
		StylishMailPreviewBodyText:SetText(ExpandText(SendMailBodyEditBox:GetText(), true))
		StylishMailPreviewSavedText:Hide()
	end)

	--------------------------------------------------
	-- mail frame: add preview button
	--------------------------------------------------
	local previewButton = CreateFrame("Button", "StylishMailPreviewButton", SendMailFrame)
	previewButton:SetWidth(20)
	previewButton:SetHeight(20)
	previewButton:SetPoint("TOPLEFT", 74, -15)
	previewButton:SetNormalTexture("Interface/MINIMAP/Tracking/None")
	previewButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-SquareQuickslot")
	previewButton:SetScript("OnClick", function()
		if StylishMailPreviewFrame:IsVisible() then
			StylishMailPreviewFrame:Hide()
		else
			StylishMailPreviewFrame:Show()
		end
	end)
end

----------------------------------------------------------------------------------------------------
-- hook sending mail function to expand tags before sending
----------------------------------------------------------------------------------------------------
local OriginalSendMail = SendMail
SendMail = function(name, subject, message)
	OriginalSendMail(name, ExpandText(subject), ExpandText(message, true))
end
