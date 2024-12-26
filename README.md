# Solaris UI Library Documentation

Welcome to the documentation for the Solaris UI Library. This guide will help you get started and demonstrate how to use the various components of the library effectively.

## **Bootstrapper**
To begin using the library, add the following line to your script:
```lua
local Solaris = loadstring(game:HttpGet("https://raw.githubusercontent.com/luauss/Solaira-Ui-lib/refs/heads/main/EnhancedUILibrary.lua", true))()
```

---

## **Getting Started**

### **Creating a Window**
To create a new window, use the following code:
```lua
local Window = Solaris.new("Solaris Test")
```

---

### **Adding a Tab**
To add a tab to your window, use the following code:
```lua
local MainTab = Window:AddTab("Main")
```

---

## **Components**

### **Button**
To add a button to your tab:
```lua
MainTab:AddButton("Test Button", function()
    print("Test button clicked!")
end)
```

### **Toggle**
To add a toggle switch:
```lua
MainTab:AddToggle("Walk Speed", false, function(toggled)
    if toggled then
        player.Character.Humanoid.WalkSpeed = 50
    else
        player.Character.Humanoid.WalkSpeed = 16
    end
end)
```

### **Input**
To add an input box:
```lua
MainTab:AddInput("Speed", "Enter speed...", 10, function(value)
    print("Input Value:", value)
end)
```

### **Dropdown**
To add a dropdown menu:
```lua
MainTab:AddDropdown("Select Player", {"Player1", "Player2", "Player3"}, function(selected)
    print("Selected Player:", selected)
end)
```

### **Slider**
To add a slider:
```lua
MainTab:AddSlider("Hız", 0, 100, 50, function(value)
    print("Slider Value:", value)
end)
```

### **Color Picker**
To add a color picker:
```lua
MainTab:AddColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Selected Color:", color)
end)
```

---

## **Example**
Here is an example that combines all the components:
```lua
local Window = EnhancedUILibrary.new("Solaris Test")
local MainTab = Window:AddTab("Main")

MainTab:AddButton("Test Button", function()
    print("Test button clicked!")
end)

MainTab:AddToggle("Walk Speed", false, function(toggled)
    if toggled then
        player.Character.Humanoid.WalkSpeed = 50
    else
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

MainTab:AddInput("Speed", "Enter speed...", 10, function(value)
    print("Input Value:", value)
end)

MainTab:AddDropdown("Select Player", {"Player1", "Player2", "Player3"}, function(selected)
    print("Selected Player:", selected)
end)

MainTab:AddSlider("Hız", 0, 100, 50, function(value)
    print("Slider Value:", value)
end)

MainTab:AddColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Selected Color:", color)
end)
```

---

This documentation provides an overview of the features in the Solaris UI Library. Feel free to explore and customize these components for your projects!

