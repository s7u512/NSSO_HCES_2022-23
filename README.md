# NSSO Household Consumption Expenditure Survey: 2022-23
Basic Estimation Scripts for Household Consumption Expenditure Survey (2022-23) by India's National Sample Survey Office

## Description
This repository contains a few scripts to extract unit level data from the fixed width files for the Household Consumption Expenditure Survey: 2022-23 (HCES22) and do a basic estimation check to match with the associated Report from the National Sample Survey Office.
Specifically, the third script estimates the national average Monthly Per Capita Expenditure in Rural India at nominal prices. This matches with the figure in the official report up to two decimal places.

## Usage
1. Clone the repo or download it. See [here](https://resources.github.com/github-and-rstudio/) for some help.
2. Create two additional folders named `RawData` and `Output`  (they are hidden here via `.gitignore`)
3. Place the fixed width files in the RawData folder. They are available at the [official website](https://microdata.gov.in/nada43/index.php/catalog/194) which requires a sign up, or alternatively [here](https://github.com/advaitmoharir/hces_2022/tree/main/03_raw) 
4. Run the scripts in order through `R` (I recommend `RStudio` as an IDE)
5. Your output files should be available in the `Output` folder

## 5. Contributing

These scripts were designed for personal use, but if you would like to contribute to this project, feel free to [reach out](https://twitter.com/all_awry). I would also appreciate help to expand documentation. Do [open an issue](https://github.com/s7u512/NSSO-77-SAS/issues/new) or [reach out](https://twitter.com/all_awry) for any help.

## Disclaimer

I am not an expert in either `R` or sample survey estimation. 

I have done my best to keep the code uniform and well-commented. However, there may be mistakes and/or better ways to approach the task I set out to do. Please [let me know](https://twitter.com/all_awry) if you spot any issues or have suggestions for improvement.

I have not done an exhaustive check of formatting consistency or even other potential issues, so please don't hesitate to [open an issue](https://github.com/s7u512/NSSO-77-SAS/issues/new) or [reach out](https://twitter.com/all_awry) if you find something.

## License

This work is licensed under the [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license. This work is free: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This work is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

## Acknowledgements

This is a personal project. I would like to thank [Deepak](https://github.com/deepakjohnson91/) for making `R` accessible for me. Also thanks to Arindam for his inspiration and help. 
