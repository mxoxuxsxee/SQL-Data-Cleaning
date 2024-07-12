# SQL Data Cleaning

###  📑 Table of Contents

- [Description](#description)
- [SQL Server Features](#sql-server-features)
- [Intstallation](#installation)
- [Usage](#usage)


### 📖 Description
This micro-project aims to clean housing data from the `Housing_Data_for_Cleaning.xlsx` file. The goal is to prepare the data for further analysis and reporting, as well as to practice and solidify data cleaning skills in SQL Server.

Problems addressed by the project:

- Lack of normalization in the address columns; ***OwnerAddress*** and ***PropertyAddress*** (address, city and state data were in one column)
- Improper format of the ***SaleDate***
- Missing data (some of which were filled in based on other rows)
- Inconsistent values in the ***SoldAsVacant*** column (values **"Y"**, **"N"**, **"Yes"**, and **"No"** were standardized to **"Yes"** and **"No"**)
- Removal of duplicates
- Removal of unnecessary columns

### 💻 SQL Server Features
- Data Normalization
  - Used `SUBSTRING()` and `CHARINDEX()` to separate address details (city, state) from a combined address field.
  - Also utilized `PARSENAME()` and `REPLACE()` for an alternative approach to address parsing.
- Date Standardization
  - Standardized date formats using the `CONVERT()` function to ensure uniformity across the dataset.
- Value Standardization
  - Unified values in the SoldAsVacant column ("Y", "N", "Yes", "No") using `COUNT` and `CASE WHEN` statements.
- Duplicate Removal
  - Removed duplicates using ***Common Table Expressions (CTEs)*** and `ROW_NUMBER()` for efficient row identification.


### 👇 Installation
1. Install SQL Server Management Studio (SSMS).
   - [Download here](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16)
3. Download the data file: `Housing_Data_for_Cleaning.xlsx`
3. Download the SQL script from the GitHub repository: `Data_Cleaning.sql`

### ⌨️ Usage
1. Open SQL Server Management Studio (SSMS).
2. Import the data file into the database.
3. Open the `Data_Cleaning.sql` file in SSMS.
4. Run the queries from the `Data_Cleaning.sql` file.
5. After executing the queries, right-click on the query result and select ***Save As...*** to save the cleaned data.
6. You can compare your data with `Cleaned_Housing_Data.xlsx`
