SELECT *
FROM DataCleaning.dbo.NashvilleHousing;



-- Stadarize SaleDate -----------------------------------------------------------------------------------------------------------------
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM DataCleaning.dbo.NashvilleHousing;

--Update DataCleaning.dbo.NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate) 

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update DataCleaning.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);



-- Filling blank adress data PropertyAddress, --------------------------------------------------------------------------------
-- if ParcelID is the same, and UniqueID is different, copy adress
SELECT *
FROM DataCleaning.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ];



-- Separating the address into separate columns - Address, City and State --------------------------------------------------------------------------
SELECT PropertyAddress
FROM DataCleaning.dbo.NashvilleHousing;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM DataCleaning.dbo.NashvilleHousing;

ALTER TABLE DataCleaning.dbo.NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE DataCleaning.dbo.NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));



-- same for OwnerAddress but this time using PARSENAME ------------------------------------------------------------------------
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State, -- change "," on "." beacuse PARSENAME works only with "."
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Adress
FROM DataCleaning.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);


ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);



-- Change "Y" and "N" to "Yes" and "No" in SoldAsVacant -----------------------------------------------------------------------------------------------
SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM DataCleaning.dbo.NashvilleHousing
GROUP BY SoldAsVacant;

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM DataCleaning.dbo.NashvilleHousing;

Update DataCleaning.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END;



-- Removing duplicates -------------------------------------------------------------------------------------------------------------------
WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER(
		  PARTITION BY ParcelID, 
					   PropertyAddress, 
					   SalePrice, 
					   SaleDate, 
					   LegalReference 
					   ORDER BY 
						  UniqueID
						  ) row_num
FROM DataCleaning.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE 
WHERE row_num > 1;



-- Removing unnecessary columns --------------------------------------------------------------------------------------------------------
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT * FROM DataCleaning.dbo.NashvilleHousing;
