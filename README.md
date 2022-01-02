# | AutoHoodPop |
![Released January 2022](https://img.shields.io/badge/release%20date-January%202022-purple)
![1.2.0](https://raster.shields.io/badge/version-v1.2.0-blue)
![moonloader](https://img.shields.io/badge/lua-moonloader-red)
![MIT License](https://img.shields.io/badge/license-MIT-green)
![Requires: sampfuncs](https://img.shields.io/badge/requires-sampfuncs%20|%20moonloader%20|%20inicfg-yellow)

**| AutoHoodPop |** is a GTA:SA Moonloader modification that automatically opens your car hood at a specified health. The health "danger zone" is defaulted at 400 and can be changed and saved permanently by the user.

## Requirements
- inicfg
- Moonloader
- Sampfuncs

## Installation
Extract AutoHoodPop.lua from the zip file to the "moonloader" folder located in your GTA:SA Install Folder. The first time you run GTA:SA with this installed a configuration directory and file will be created.

### Modification File & Folder Structure
```
AutoHoodPop.lua
config
    -Masaharu's Config
        --AutoHoodPop.ini
```

Note: README.md is not required for the modification to work.

## Usage
**| AutoHoodPop |** is automatically enabled when initially installed. It can be disabled using [/ahp]. You can set the health to pop the hood by using [/ahphealth]. All settings are saved to a configuration file to remember your choices on next login.

```
/ahp - Enable/Disable | AutoHoodPop |
/ahphelp - Show the help menu.
/ahphealth - Set health hood will open at. E.g. [/ahphealth 350]
```

- [/ahphealth] Allowed Health Range - 250 HP -> 999 HP

## Contributing
Please contact [Masaharu Morimoto#2302](https://litelink.at/masaharu) through Discord if you would like to contribute to this project. Pull requests are also welcome however, cannot be guaranteed to be added to the official project.

### Bugs, Errors, Bounties
Please contact [Masaharu Morimoto#2302](https://litelink.at/masaharu) through Discord or on the HZRP forums if you encounter any bugs or errors. I am more than willing to check it out for you. Please provide screenshots of the console and your game if possible. ***Press "`" to open the console***

If you find a critical bug, ***especially security related***, you will be paid a minimum sum of ***$20,000HZRP*** plus a bonus depending on severity.

## Author
- [Masaharu Morimoto](https://litelink.at/masaharu)

## Special Thanks
- [Brad Ringer (Consulting & Boilerplate Only - No Script Use/Design/Legal Responsibility or Involement)](https://forums.hzgaming.net/member.php/34885-Brad-Ringer)
- Valeria (inicfg)

## License
[MIT](https://choosealicense.com/licenses/mit/)
