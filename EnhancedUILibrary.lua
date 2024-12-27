local SolariaLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Utility functions
local function CreateTween(instance, properties, duration)
	return TweenService:Create(
		instance,
		TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	)
end

-- Helper function to get appropriate parent for UI
local function getUIParent()
	if RunService:IsStudio() then
		return Players.LocalPlayer:WaitForChild("PlayerGui")
	else
		local success, result = pcall(function()
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		end)

		if success then
			return result
		else
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		end
	end
end

function SolariaLib:CreateWindow(config)
	config = config or {}

	-- Default configuration
	local windowConfig = {
		Name = config.Name or "Solaria Interface",
		Icon = config.Icon or 0,
		LoadingTitle = config.LoadingTitle or "Solaria Interface Suite",
		LoadingSubtitle = config.LoadingSubtitle or "by Developer",
		DisablePrompts = config.DisablePrompts or false,
		DisableBuildWarnings = config.DisableBuildWarnings or false,
		ConfigurationSaving = {
			Enabled = config.ConfigurationSaving and config.ConfigurationSaving.Enabled or false,
			FolderName = config.ConfigurationSaving and config.ConfigurationSaving.FolderName or nil,
			FileName = config.ConfigurationSaving and config.ConfigurationSaving.FileName or "SolariaConfig"
		},
		Discord = {
			Enabled = config.Discord and config.Discord.Enabled or false,
			Invite = config.Discord and config.Discord.Invite or "",
			RememberJoins = config.Discord and config.Discord.RememberJoins or true
		},
		KeySystem = config.KeySystem or false,
		KeySettings = {
			Title = config.KeySettings and config.KeySettings.Title or "Key System",
			Subtitle = config.KeySettings and config.KeySettings.Subtitle or "Key Verification",
			Note = config.KeySettings and config.KeySettings.Note or "No method of obtaining the key is provided",
			FileName = config.KeySettings and config.KeySettings.FileName or "Key",
			SaveKey = config.KeySettings and config.KeySettings.SaveKey or true,
			GrabKeyFromSite = config.KeySettings and config.KeySettings.GrabKeyFromSite or false,
			Key = config.KeySettings and config.KeySettings.Key or {"Default"}
		}
	}

	-- Get appropriate UI parent
	local uiParent = getUIParent()

	-- Create loading screen if not disabled
	if not windowConfig.DisablePrompts then
		local LoadingScreen = Instance.new("ScreenGui")
		LoadingScreen.Name = "LoadingScreen"
		LoadingScreen.Parent = uiParent

		local LoadingFrame = Instance.new("Frame")
		LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
		LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
		LoadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		LoadingFrame.Parent = LoadingScreen

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 8)
		UICorner.Parent = LoadingFrame

		local LoadingTitle = Instance.new("TextLabel")
		LoadingTitle.Text = windowConfig.LoadingTitle
		LoadingTitle.Size = UDim2.new(1, 0, 0, 30)
		LoadingTitle.Position = UDim2.new(0, 0, 0.2, 0)
		LoadingTitle.BackgroundTransparency = 1
		LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		LoadingTitle.Font = Enum.Font.GothamBold
		LoadingTitle.TextSize = 18
		LoadingTitle.Parent = LoadingFrame

		local LoadingSubtitle = Instance.new("TextLabel")
		LoadingSubtitle.Text = windowConfig.LoadingSubtitle
		LoadingSubtitle.Size = UDim2.new(1, 0, 0, 20)
		LoadingSubtitle.Position = UDim2.new(0, 0, 0.4, 0)
		LoadingSubtitle.BackgroundTransparency = 1
		LoadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
		LoadingSubtitle.Font = Enum.Font.Gotham
		LoadingSubtitle.TextSize = 14
		LoadingSubtitle.Parent = LoadingFrame

		wait(1)
		LoadingScreen:Destroy()
	end

	-- Key System Implementation
	if windowConfig.KeySystem then
		local keyVerified = false

		local function verifyKey(inputKey)
			for _, validKey in ipairs(windowConfig.KeySettings.Key) do
				if inputKey == validKey then
					return true
				end
			end
			return false
		end

		local KeySystem = Instance.new("ScreenGui")
		KeySystem.Name = "KeySystem"
		KeySystem.Parent = uiParent

		local KeyFrame = Instance.new("Frame")
		KeyFrame.Size = UDim2.new(0, 300, 0, 200)
		KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
		KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		KeyFrame.Parent = KeySystem

		local KeyCorner = Instance.new("UICorner")
		KeyCorner.CornerRadius = UDim.new(0, 8)
		KeyCorner.Parent = KeyFrame

		local KeyTitle = Instance.new("TextLabel")
		KeyTitle.Text = windowConfig.KeySettings.Title
		KeyTitle.Size = UDim2.new(1, 0, 0, 30)
		KeyTitle.Position = UDim2.new(0, 0, 0.1, 0)
		KeyTitle.BackgroundTransparency = 1
		KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		KeyTitle.Font = Enum.Font.GothamBold
		KeyTitle.TextSize = 18
		KeyTitle.Parent = KeyFrame

		local KeySubtitle = Instance.new("TextLabel")
		KeySubtitle.Text = windowConfig.KeySettings.Subtitle
		KeySubtitle.Size = UDim2.new(1, 0, 0, 20)
		KeySubtitle.Position = UDim2.new(0, 0, 0.25, 0)
		KeySubtitle.BackgroundTransparency = 1
		KeySubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
		KeySubtitle.Font = Enum.Font.Gotham
		KeySubtitle.TextSize = 14
		KeySubtitle.Parent = KeyFrame

		local KeyNote = Instance.new("TextLabel")
		KeyNote.Text = windowConfig.KeySettings.Note
		KeyNote.Size = UDim2.new(1, -40, 0, 40)
		KeyNote.Position = UDim2.new(0, 20, 0.4, 0)
		KeyNote.BackgroundTransparency = 1
		KeyNote.TextColor3 = Color3.fromRGB(180, 180, 180)
		KeyNote.Font = Enum.Font.Gotham
		KeyNote.TextSize = 12
		KeyNote.TextWrapped = true
		KeyNote.Parent = KeyFrame

		local KeyInput = Instance.new("TextBox")
		KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
		KeyInput.Position = UDim2.new(0.1, 0, 0.65, 0)
		KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		KeyInput.BorderSizePixel = 0
		KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
		KeyInput.PlaceholderText = "Enter Key..."
		KeyInput.TextSize = 14
		KeyInput.Font = Enum.Font.Gotham
		KeyInput.Parent = KeyFrame

		local KeyButton = Instance.new("TextButton")
		KeyButton.Size = UDim2.new(0.8, 0, 0, 30)
		KeyButton.Position = UDim2.new(0.1, 0, 0.85, 0)
		KeyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		KeyButton.BorderSizePixel = 0
		KeyButton.Text = "Submit"
		KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		KeyButton.TextSize = 14
		KeyButton.Font = Enum.Font.GothamBold
		KeyButton.Parent = KeyFrame

		local KeyButtonCorner = Instance.new("UICorner")
		KeyButtonCorner.CornerRadius = UDim.new(0, 4)
		KeyButtonCorner.Parent = KeyButton

		KeyButton.MouseButton1Click:Connect(function()
			if verifyKey(KeyInput.Text) then
				keyVerified = true
				KeySystem:Destroy()
			else
				KeyInput.Text = ""
				KeyInput.PlaceholderText = "Invalid Key!"
				wait(1)
				KeyInput.PlaceholderText = "Enter Key..."
			end
		end)

		repeat wait() until keyVerified
	end

	-- Main UI Creation
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SolariaUI"
	ScreenGui.Parent = uiParent

	-- Main container
	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(0, 600, 0, 400)
	Container.Position = UDim2.new(0.5, -300, 0.5, -200)
	Container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Container.BorderSizePixel = 0
	Container.Parent = ScreenGui

	-- Add aspect ratio constraint
	local AspectRatio = Instance.new("UIAspectRatioConstraint")
	AspectRatio.AspectRatio = 1.5
	AspectRatio.Parent = Container

	-- Enhanced shadow
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Size = UDim2.new(1, 40, 1, 40)
	Shadow.Position = UDim2.new(0, -20, 0, -20)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
	Shadow.Parent = Container

	-- Main frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = Container

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame

	-- Title bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 40)
	TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
	})
	TitleGradient.Rotation = 45
	TitleGradient.Parent = TitleBar

	-- Title text
	local TitleText = Instance.new("TextLabel")
	TitleText.Name = "TitleText"
	TitleText.Size = UDim2.new(1, -20, 1, 0)
	TitleText.Position = UDim2.new(0, 15, 0, 0)
	TitleText.BackgroundTransparency = 1
	TitleText.Text = windowConfig.Name
	TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleText.TextXAlignment = Enum.TextXAlignment.Left
	TitleText.Font = Enum.Font.GothamBold
	TitleText.TextSize = 16
	TitleText.Parent = TitleBar

	-- Tab container
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(0, 150, 1, -40)
	TabContainer.Position = UDim2.new(0, 0, 0, 40)
	TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = MainFrame

	local TabHolder = Instance.new("ScrollingFrame")
	TabHolder.Name = "TabHolder"
	TabHolder.Size = UDim2.new(1, -10, 1, -10)
	TabHolder.Position = UDim2.new(0, 5, 0, 5)
	TabHolder.BackgroundTransparency = 1
	TabHolder.BorderSizePixel = 0
	TabHolder.ScrollBarThickness = 2
	TabHolder.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 45)
	TabHolder.Parent = TabContainer

	local GridLayout = Instance.new("UIGridLayout")
	GridLayout.CellSize = UDim2.new(1, -10, 0, 35)
	GridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	GridLayout.Parent = TabHolder

	-- Content frame
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Size = UDim2.new(1, -160, 1, -50)
	ContentFrame.Position = UDim2.new(0, 155, 0, 45)
		ContentFrame.BackgroundTransparency = 1
		ContentFrame.Parent = MainFrame

		local ContentPadding = Instance.new("UIPadding")
		ContentPadding.PaddingLeft = UDim.new(0, 5)
		ContentPadding.PaddingRight = UDim.new(0, 5)
		ContentPadding.PaddingTop = UDim.new(0, 5)
		ContentPadding.PaddingBottom = UDim.new(0, 5)
		ContentPadding.Parent = ContentFrame

		local library = {}
		local tabs = {}
		local currentTab = nil

		function library:AddTab(name)
			local TabButton = Instance.new("TextButton")
			TabButton.Name = name
			TabButton.Size = UDim2.new(1, -10, 0, 35)
			TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			TabButton.BorderSizePixel = 0
			TabButton.Text = name
			TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
			TabButton.Font = Enum.Font.GothamSemibold
			TabButton.TextSize = 14
			TabButton.Parent = TabHolder
			TabButton.AutoButtonColor = false

			local TabCorner = Instance.new("UICorner")
			TabCorner.CornerRadius = UDim.new(0, 6)
			TabCorner.Parent = TabButton

			local TabStroke = Instance.new("UIStroke")
			TabStroke.Color = Color3.fromRGB(45, 45, 45)
			TabStroke.Thickness = 1
			TabStroke.Parent = TabButton

			local TabContent = Instance.new("ScrollingFrame")
			TabContent.Name = name.."Content"
			TabContent.Size = UDim2.new(1, 0, 1, 0)
			TabContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			TabContent.BorderSizePixel = 0
			TabContent.ScrollBarThickness = 2
			TabContent.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 45)
			TabContent.Visible = false
			TabContent.Parent = ContentFrame

			local ContentList = Instance.new("UIListLayout")
			ContentList.Parent = TabContent
			ContentList.SortOrder = Enum.SortOrder.LayoutOrder
			ContentList.Padding = UDim.new(0, 8)

			local ContentPadding = Instance.new("UIPadding")
			ContentPadding.PaddingLeft = UDim.new(0, 8)
			ContentPadding.PaddingRight = UDim.new(0, 8)
			ContentPadding.PaddingTop = UDim.new(0, 8)
			ContentPadding.PaddingBottom = UDim.new(0, 8)
			ContentPadding.Parent = TabContent

			-- Tab switching
			TabButton.MouseButton1Click:Connect(function()
				if currentTab then
					CreateTween(currentTab, {Position = UDim2.new(0.05, 0, 0, 0)}):Play()
					wait(0.2)
					currentTab.Visible = false
				end

				TabContent.Position = UDim2.new(-0.05, 0, 0, 0)
				TabContent.Visible = true
				CreateTween(TabContent, {Position = UDim2.new(0, 0, 0, 0)}):Play()
				currentTab = TabContent

				for _, tab in pairs(tabs) do
					local btn = tab.Button
					CreateTween(btn, {
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						TextColor3 = Color3.fromRGB(180, 180, 180)
					}):Play()
				end

				CreateTween(TabButton, {
					BackgroundColor3 = Color3.fromRGB(45, 45, 45),
					TextColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()
			end)

			if #tabs == 0 then
				TabContent.Visible = true
				currentTab = TabContent
				TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			end

			table.insert(tabs, {Content = TabContent, Button = TabButton})

			local tab = {}

			function tab:AddButton(text, callback)
				local Button = Instance.new("TextButton")
				Button.Name = "Button"
				Button.Size = UDim2.new(1, -10, 0, 35)
				Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				Button.BorderSizePixel = 0
				Button.Text = "   "..text
				Button.TextColor3 = Color3.fromRGB(255, 255, 255)
				Button.Font = Enum.Font.GothamSemibold
				Button.TextSize = 14
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = TabContent

				local ButtonCorner = Instance.new("UICorner")
				ButtonCorner.CornerRadius = UDim.new(0, 6)
				ButtonCorner.Parent = Button

				local ButtonStroke = Instance.new("UIStroke")
				ButtonStroke.Color = Color3.fromRGB(45, 45, 45)
				ButtonStroke.Thickness = 1
				ButtonStroke.Parent = Button

				-- Enhanced button animations
				Button.MouseEnter:Connect(function()
					CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2):Play()
				end)

				Button.MouseLeave:Connect(function()
					CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2):Play()
				end)

				Button.MouseButton1Click:Connect(function()
					CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2):Play()
					callback()
					wait(0.2)
					CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2):Play()
				end)

				return Button
			end

			function tab:AddToggle(text, default, callback)
				local Toggle = Instance.new("Frame")
				Toggle.Name = "Toggle"
				Toggle.Size = UDim2.new(1, -10, 0, 35)
				Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				Toggle.BorderSizePixel = 0
				Toggle.Parent = TabContent

				local ToggleCorner = Instance.new("UICorner")
				ToggleCorner.CornerRadius = UDim.new(0, 6)
				ToggleCorner.Parent = Toggle

				local ToggleStroke = Instance.new("UIStroke")
				ToggleStroke.Color = Color3.fromRGB(45, 45, 45)
				ToggleStroke.Thickness = 1
				ToggleStroke.Parent = Toggle

				local ToggleButton = Instance.new("Frame")
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Size = UDim2.new(0, 22, 0, 22)
				ToggleButton.Position = UDim2.new(1, -32, 0.5, -11)
				ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Parent = Toggle

				local ToggleButtonCorner = Instance.new("UICorner")
				ToggleButtonCorner.CornerRadius = UDim.new(0, 4)
				ToggleButtonCorner.Parent = ToggleButton

				local ToggleText = Instance.new("TextLabel")
				ToggleText.Name = "ToggleText"
				ToggleText.Size = UDim2.new(1, -50, 1, 0)
				ToggleText.Position = UDim2.new(0, 12, 0, 0)
				ToggleText.BackgroundTransparency = 1
				ToggleText.Text = text
				ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleText.TextXAlignment = Enum.TextXAlignment.Left
				ToggleText.Font = Enum.Font.GothamSemibold
				ToggleText.TextSize = 14
				ToggleText.Parent = Toggle

				local toggled = default or false

				local function updateToggle()
					local targetColor = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
					local targetStrokeColor = toggled and Color3.fromRGB(0, 140, 225) or Color3.fromRGB(45, 45, 45)

					CreateTween(ToggleButton, {BackgroundColor3 = targetColor}, 0.2):Play()
					CreateTween(ToggleStroke, {Color = targetStrokeColor}, 0.2):Play()
					callback(toggled)
				end

				Toggle.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						toggled = not toggled
						updateToggle()
					end
				end)

				-- Hover effect
				Toggle.MouseEnter:Connect(function()
					CreateTween(Toggle, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2):Play()
				end)

				Toggle.MouseLeave:Connect(function()
					CreateTween(Toggle, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2):Play()
				end)

				updateToggle()
				return Toggle
		end
		local function limitTextLength(textBox, maxLength)
			textBox:GetPropertyChangedSignal("Text"):Connect(function()
				if #textBox.Text > maxLength then
					textBox.Text = string.sub(textBox.Text, 1, maxLength)
				end
			end)
		end

		-- Input için yeni fonksiyon ekleyelim
		function tab:AddInput(text, placeholder, maxLength, callback)
			local Input = Instance.new("Frame")
			Input.Name = "Input"
			Input.Size = UDim2.new(1, -10, 0, 35)
			Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Input.BorderSizePixel = 0
			Input.Parent = TabContent

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 6)
			InputCorner.Parent = Input

			local InputBox = Instance.new("TextBox")
			InputBox.Name = "InputBox"
			InputBox.Size = UDim2.new(0, 100, 0, 25)
			InputBox.Position = UDim2.new(1, -110, 0.5, -12.5)
			InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			InputBox.BorderSizePixel = 0
			InputBox.Text = ""
			InputBox.PlaceholderText = placeholder
			InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			InputBox.Font = Enum.Font.GothamSemibold
			InputBox.TextSize = 14
			InputBox.Parent = Input

			-- Text sınırlaması uygula
			limitTextLength(InputBox, maxLength or 10)


			local InputBoxCorner = Instance.new("UICorner")
			InputBoxCorner.CornerRadius = UDim.new(0, 4)
			InputBoxCorner.Parent = InputBox

			InputBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					callback(InputBox.Text)
				end
			end)

			-- Hover efekti
			Input.MouseEnter:Connect(function()
				CreateTween(Input, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2):Play()
			end)

			Input.MouseLeave:Connect(function()
				CreateTween(Input, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2):Play()
			end)

			return Input
		end

		-- Dropdown için yeni fonksiyon
		function tab:AddDropdown(text, options, callback)
			local Dropdown = Instance.new("Frame")
			Dropdown.Name = "Dropdown"
			Dropdown.Size = UDim2.new(1, -10, 0, 35)
			Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Dropdown.BorderSizePixel = 0
			Dropdown.Parent = TabContent

			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 6)
			DropdownCorner.Parent = Dropdown

			local DropdownStroke = Instance.new("UIStroke")
			DropdownStroke.Color = Color3.fromRGB(45, 45, 45)
			DropdownStroke.Thickness = 1
			DropdownStroke.Parent = Dropdown

			local DropdownText = Instance.new("TextLabel")
			DropdownText.Name = "DropdownText"
			DropdownText.Size = UDim2.new(0, 200, 1, 0)
			DropdownText.Position = UDim2.new(0, 12, 0, 0)
			DropdownText.BackgroundTransparency = 1
			DropdownText.Text = text
			DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownText.TextXAlignment = Enum.TextXAlignment.Left
			DropdownText.Font = Enum.Font.GothamSemibold
			DropdownText.TextSize = 14
			DropdownText.Parent = Dropdown

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Name = "DropdownButton"
			DropdownButton.Size = UDim2.new(0, 120, 0, 25)
			DropdownButton.Position = UDim2.new(1, -130, 0.5, -12.5)
			DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			DropdownButton.BorderSizePixel = 0
			DropdownButton.Text = "Select..."
			DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownButton.Font = Enum.Font.GothamSemibold
			DropdownButton.TextSize = 14
			DropdownButton.Parent = Dropdown

			local DropdownButtonCorner = Instance.new("UICorner")
			DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
			DropdownButtonCorner.Parent = DropdownButton

			local DropMenu = Instance.new("Frame")
			DropMenu.Name = "DropMenu"
			DropMenu.Size = UDim2.new(0, 120, 0, 0)
			DropMenu.Position = UDim2.new(1, -130, 1, 5)
			DropMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			DropMenu.BorderSizePixel = 0
			DropMenu.Visible = false
			DropMenu.ZIndex = 5
			DropMenu.Parent = Dropdown

			local DropMenuCorner = Instance.new("UICorner")
			DropMenuCorner.CornerRadius = UDim.new(0, 4)
			DropMenuCorner.Parent = DropMenu

			local DropMenuStroke = Instance.new("UIStroke")
			DropMenuStroke.Color = Color3.fromRGB(55, 55, 55)
			DropMenuStroke.Thickness = 1
			DropMenuStroke.Parent = DropMenu

			local DropMenuList = Instance.new("UIListLayout")
			DropMenuList.SortOrder = Enum.SortOrder.LayoutOrder
			DropMenuList.Parent = DropMenu

			local isOpen = false

			local function toggleDropdown()
				isOpen = not isOpen
				if isOpen then
					DropMenu.Visible = true
					CreateTween(DropMenu, {Size = UDim2.new(0, 120, 0, #options * 25)}, 0.2):Play()
				else
					CreateTween(DropMenu, {Size = UDim2.new(0, 120, 0, 0)}, 0.2):Play()
					wait(0.2)
					DropMenu.Visible = false
				end
			end

			for i, option in ipairs(options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Name = option
				OptionButton.Size = UDim2.new(1, 0, 0, 25)
				OptionButton.BackgroundTransparency = 1
				OptionButton.Text = option
				OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				OptionButton.Font = Enum.Font.GothamSemibold
				OptionButton.TextSize = 14
				OptionButton.ZIndex = 6
				OptionButton.Parent = DropMenu

				OptionButton.MouseButton1Click:Connect(function()
					DropdownButton.Text = option
					callback(option)
					toggleDropdown()
				end)
			end

			DropdownButton.MouseButton1Click:Connect(toggleDropdown)

			return Dropdown
		end

		-- ColorPicker için yeni fonksiyon
		function tab:AddColorPicker(text, default, callback)
			local ColorPicker = Instance.new("Frame")
			ColorPicker.Name = "ColorPicker"
			ColorPicker.Size = UDim2.new(1, -10, 0, 35)
			ColorPicker.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			ColorPicker.BorderSizePixel = 0
			ColorPicker.Parent = TabContent

			local ColorPickerCorner = Instance.new("UICorner")
			ColorPickerCorner.CornerRadius = UDim.new(0, 6)
			ColorPickerCorner.Parent = ColorPicker

			local ColorPickerStroke = Instance.new("UIStroke")
			ColorPickerStroke.Color = Color3.fromRGB(45, 45, 45)
			ColorPickerStroke.Thickness = 1
			ColorPickerStroke.Parent = ColorPicker

			local ColorPickerText = Instance.new("TextLabel")
			ColorPickerText.Name = "ColorPickerText"
			ColorPickerText.Size = UDim2.new(0, 200, 1, 0)
			ColorPickerText.Position = UDim2.new(0, 12, 0, 0)
			ColorPickerText.BackgroundTransparency = 1
			ColorPickerText.Text = text
			ColorPickerText.TextColor3 = Color3.fromRGB(255, 255, 255)
			ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
			ColorPickerText.Font = Enum.Font.GothamSemibold
			ColorPickerText.TextSize = 14
			ColorPickerText.Parent = ColorPicker

			local ColorDisplay = Instance.new("Frame")
			ColorDisplay.Name = "ColorDisplay"
			ColorDisplay.Size = UDim2.new(0, 30, 0, 25)
			ColorDisplay.Position = UDim2.new(1, -40, 0.5, -12.5)
			ColorDisplay.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Parent = ColorPicker

			local ColorDisplayCorner = Instance.new("UICorner")
			ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
			ColorDisplayCorner.Parent = ColorDisplay

			local ColorPickerButton = Instance.new("TextButton")
			ColorPickerButton.Name = "ColorPickerButton"
			ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
			ColorPickerButton.BackgroundTransparency = 1
			ColorPickerButton.Text = ""
			ColorPickerButton.Parent = ColorDisplay

			-- ColorPicker popup window
			local Popup = Instance.new("Frame")
			Popup.Name = "Popup"
			Popup.Size = UDim2.new(0, 200, 0, 220)
			Popup.Position = UDim2.new(1, 10, 0, 0) -- Updated position to appear to the right
			Popup.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			Popup.BorderSizePixel = 0
			Popup.Visible = false
			Popup.ZIndex = 100
			Popup.Parent = ColorPicker

			local PopupCorner = Instance.new("UICorner")
			PopupCorner.CornerRadius = UDim.new(0, 6)
			PopupCorner.Parent = Popup

			local PopupStroke = Instance.new("UIStroke")
			PopupStroke.Color = Color3.fromRGB(45, 45, 45)
			PopupStroke.Thickness = 1
			PopupStroke.Parent = Popup

			-- Renk tekerleği
			local ColorWheel = Instance.new("ImageLabel")
			ColorWheel.Name = "ColorWheel"
			ColorWheel.Size = UDim2.new(0, 150, 0, 150)
			ColorWheel.Position = UDim2.new(0.5, -75, 0, 10)
			ColorWheel.Image = "rbxassetid://6020299385" -- Updated to a valid color wheel asset ID
			ColorWheel.BackgroundTransparency = 1
			ColorWheel.ZIndex = 101
			ColorWheel.Parent = Popup

			-- Renk seçici işaretçi
			local Picker = Instance.new("Frame")
			Picker.Name = "Picker"
			Picker.Size = UDim2.new(0, 6, 0, 6)
			Picker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Picker.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Picker.ZIndex = 102
			Picker.Parent = ColorWheel

			-- Parlaklık çubuğu
			local ValueSlider = Instance.new("Frame")
			ValueSlider.Name = "ValueSlider"
			ValueSlider.Size = UDim2.new(0, 150, 0, 20)
			ValueSlider.Position = UDim2.new(0.5, -75, 1, -40)
			ValueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ValueSlider.ZIndex = 101
			ValueSlider.Parent = Popup

			local ValueGradient = Instance.new("UIGradient")
			ValueGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			})
			ValueGradient.Parent = ValueSlider

			-- Parlaklık seçici
			local ValuePicker = Instance.new("Frame")
			ValuePicker.Name = "ValuePicker"
			ValuePicker.Size = UDim2.new(0, 2, 1, 0)
			ValuePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ValuePicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ValuePicker.ZIndex = 102
			ValuePicker.Parent = ValueSlider

			-- Renk seçme fonksiyonları
			local function updateColor(hue, sat, val)
				local color = Color3.fromHSV(hue, sat, val)
				ColorDisplay.BackgroundColor3 = color
				callback(color)
			end

			local function updatePickerPosition(input)
				local center = Vector2.new(ColorWheel.AbsolutePosition.X + ColorWheel.AbsoluteSize.X/2, 
					ColorWheel.AbsolutePosition.Y + ColorWheel.AbsoluteSize.Y/2)
				local radius = ColorWheel.AbsoluteSize.X/2
				local mousePos = Vector2.new(input.Position.X, input.Position.Y)
				local diff = mousePos - center
				local distance = diff.Magnitude

				if distance > radius then
					diff = diff.Unit * radius
				end

				Picker.Position = UDim2.new(0, diff.X + radius - 3, 0, diff.Y + radius - 3)

				local hue = math.atan2(diff.Y, diff.X) / (2 * math.pi)
				if hue < 0 then hue += 1 end

				local sat = math.clamp(distance / radius, 0, 1)
				local val = 1 - tonumber(ValuePicker.Position.X.Scale)

				updateColor(hue, sat, val)
			end

			local function updateValuePosition(input)
				local pos = (input.Position.X - ValueSlider.AbsolutePosition.X) / ValueSlider.AbsoluteSize.X
				pos = math.clamp(pos, 0, 1)
				ValuePicker.Position = UDim2.new(pos, -1, 0, 0)

				local center = Vector2.new(ColorWheel.AbsolutePosition.X + ColorWheel.AbsoluteSize.X/2,
					ColorWheel.AbsolutePosition.Y + ColorWheel.AbsoluteSize.Y/2)
				local radius = ColorWheel.AbsoluteSize.X/2
				local pickerPos = Vector2.new(Picker.Position.X.Offset, Picker.Position.Y.Offset) - Vector2.new(radius - 3, radius - 3)

				local hue = math.atan2(pickerPos.Y, pickerPos.X) / (2 * math.pi)
				if hue < 0 then hue += 1 end

				local sat = pickerPos.Magnitude / radius
				updateColor(hue, sat, 1 - pos)
			end

			-- ColorPickerButton için click event
			ColorPickerButton.MouseButton1Click:Connect(function()
				Popup.Visible = not Popup.Visible
			end)

			-- Popup dışına tıklandığında kapatma
			local function isMouseInFrame(frame, mousePosition)
				local framePosition = frame.AbsolutePosition
				local frameSize = frame.AbsoluteSize

				return mousePosition.X >= framePosition.X and
					mousePosition.X <= framePosition.X + frameSize.X and
					mousePosition.Y >= framePosition.Y and
					mousePosition.Y <= framePosition.Y + frameSize.Y
			end

			game:GetService("UserInputService").InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mousePosition = Vector2.new(input.Position.X, input.Position.Y)
					if Popup.Visible and not isMouseInFrame(Popup, mousePosition) then
						Popup.Visible = false
					end
				end
			end)

			-- Mouse events
			local draggingWheel = false
			local draggingValue = false

			ColorWheel.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingWheel = true
					updatePickerPosition(input)
				end
			end)

			ValueSlider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingValue = true
					updateValuePosition(input)
				end
			end)

			game:GetService("UserInputService").InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingWheel = false
					draggingValue = false
				end
			end)

			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if draggingWheel then
						updatePickerPosition(input)
					elseif draggingValue then
						updateValuePosition(input)
					end
				end
			end)

			return ColorPicker
		end
			function tab:AddSlider(text, min, max, default, callback)
				local Slider = Instance.new("Frame")
				Slider.Name = "Slider"
				Slider.Size = UDim2.new(1, -10, 0, 45)
				Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				Slider.BorderSizePixel = 0
				Slider.Parent = TabContent

				local SliderCorner = Instance.new("UICorner")
				SliderCorner.CornerRadius = UDim.new(0, 6)
				SliderCorner.Parent = Slider

				local SliderStroke = Instance.new("UIStroke")
				SliderStroke.Color = Color3.fromRGB(45, 45, 45)
				SliderStroke.Thickness = 1
				SliderStroke.Parent = Slider

				local SliderText = Instance.new("TextLabel")
				SliderText.Name = "SliderText"
				SliderText.Size = UDim2.new(1, -10, 0, 20)
				SliderText.Position = UDim2.new(0, 10, 0, 0)
				SliderText.BackgroundTransparency = 1
				SliderText.Text = text
				SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderText.TextXAlignment = Enum.TextXAlignment.Left
				SliderText.Font = Enum.Font.GothamSemibold
				SliderText.TextSize = 14
				SliderText.Parent = Slider

				local ValueText = Instance.new("TextLabel")
				ValueText.Name = "ValueText"
				ValueText.Size = UDim2.new(0, 50, 0, 20)
				ValueText.Position = UDim2.new(1, -60, 0, 0)
				ValueText.BackgroundTransparency = 1
				ValueText.Text = tostring(default)
				ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
				ValueText.TextXAlignment = Enum.TextXAlignment.Right
				ValueText.Font = Enum.Font.GothamSemibold
				ValueText.TextSize = 14
				ValueText.Parent = Slider

				local SliderBar = Instance.new("Frame")
				SliderBar.Name = "SliderBar"
				SliderBar.Size = UDim2.new(1, -20, 0, 4)
				SliderBar.Position = UDim2.new(0, 10, 0, 32)
				SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				SliderBar.BorderSizePixel = 0
				SliderBar.Parent = Slider

				local SliderBarCorner = Instance.new("UICorner")
				SliderBarCorner.CornerRadius = UDim.new(0, 2)
				SliderBarCorner.Parent = SliderBar

				local SliderFill = Instance.new("Frame")
				SliderFill.Name = "SliderFill"
				SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
				SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
				SliderFill.BorderSizePixel = 0
				SliderFill.Parent = SliderBar

				local SliderFillCorner = Instance.new("UICorner")
				SliderFillCorner.CornerRadius = UDim.new(0, 2)
				SliderFillCorner.Parent = SliderFill

				local SliderButton = Instance.new("TextButton")
				SliderButton.Name = "SliderButton"
				SliderButton.Size = UDim2.new(0, 12, 0, 12)
				SliderButton.Position = UDim2.new((default - min)/(max - min), -6, 0.5, -6)
				SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderButton.BorderSizePixel = 0
				SliderButton.Text = ""
				SliderButton.Parent = SliderBar

				local SliderButtonCorner = Instance.new("UICorner")
				SliderButtonCorner.CornerRadius = UDim.new(1, 0)
				SliderButtonCorner.Parent = SliderButton

				local dragging = false
				local function updateSlider(input)
					local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), -6, 0.5, -6)
					local value = math.floor(min + ((max - min) * math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)))

					CreateTween(SliderButton, {Position = pos}, 0.1):Play()
					CreateTween(SliderFill, {Size = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)}, 0.1):Play()

					ValueText.Text = tostring(value)
					callback(value)
				end

				SliderButton.MouseButton1Down:Connect(function()
					dragging = true
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						updateSlider(input)
					end
				end)

				return Slider
			end

			return tab
		end

		-- Make window draggable
		local dragging = false
		local dragInput
		local dragStart
		local startPos

		local function updateDrag(input)
			local delta = input.Position - dragStart
			local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			CreateTween(Container, {Position = position}, 0.1):Play()
		end

		TitleBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = Container.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		TitleBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				updateDrag(input)
			end
		end)

		return library
	end

return SolariaLib
