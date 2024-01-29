-- NASHVILLE HOUSING DATA CLEANING

Select *
From PortfolioProject.dbo.Nashville


--STANDARDIZE DATE FORMAT

Select SaleDate
From PortfolioProject.dbo.Nashville

Select SaleDate, CONVERT(Date,saleDate)
From PortfolioProject.dbo.Nashville

update Nashville
SET SaleDate = CONVERT(Date,saleDate)


-- TO MAKE THE BOTH TABLE REFLECT THE SAME THING
ALTER TABLE Nashville
Add SaleDateConverted Date;

Update Nashville
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject..Nashville




-- POPULATE PROPERTY ADDRESS DATA

Select PropertyAddress
from PortfolioProject..Nashville
where PropertyAddress is null

Select *
from PortfolioProject..Nashville
--where PropertyAddress is null
order by ParcelID



-- TO HANDLE THE NULL VALUES IN PROPERTY ADDRESS

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nashville as a
join PortfolioProject..Nashville as b
    ON a.ParcelID =b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nashville as a
join PortfolioProject..Nashville as b
    ON a.ParcelID =b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nashville as a
join PortfolioProject..Nashville as b
    ON a.ParcelID =b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Select ParcelID, PropertyAddress
from PortfolioProject..Nashville
--where PropertyAddress is null
order by ParcelID


-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS, CITY, STATE)

Select PropertyAddress
From PortfolioProject..Nashville

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address

FROM PortfolioProject..Nashville


-- TO REMOVE THE COMMA FROM THE ADDRESS

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Adress
From PortfolioProject..Nashville

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortfolioProject..Nashville


ALTER TABLE Nashville
Add PropertySplitAddress Nvarchar(255);

Update Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE Nashville
Add PropertySplitCity Nvarchar(255);

Update Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))



Select *
From PortfolioProject..Nashville










-- SIMPLER WAY TO THE ABOVE CHALLENGE


Select OwnerAddress
From PortfolioProject..Nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject..Nashville

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
From PortfolioProject..Nashville

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject..Nashville



ALTER TABLE Nashville
Add OwnerSplitAddress Nvarchar(255);

Update Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE Nashville
Add OwnerSplitCity Nvarchar(255);

Update Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville
Add OwnerSplitState Nvarchar(255);

Update Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



select *
From PortfolioProject..Nashville





-- CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

Select Distinct(SoldAsVacant)
From PortfolioProject..Nashville


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..Nashville
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject..Nashville

Update Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..Nashville
Group by SoldAsVacant
Order by 2




-- REMOVE DUPLICATES

WITH RowNumCTE AS (
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SaleDate,
				 LegalReference
				 Order By
				    UniqueID
					) row_num
	
	
From PortfolioProject..Nashville
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--TO DELETE THE DUPLICATE

WITH RowNumCTE AS (
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SaleDate,
				 LegalReference
				 Order By
				    UniqueID
					) row_num
	
	
From PortfolioProject..Nashville
--order by ParcelID
)

DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress




-- DELETE UNUSED COLUMNS




Select *
From PortfolioProject..Nashville


ALTER TABLE PortfolioProject..Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject..Nashville
DROP COLUMN SaleDate


Select *
From PortfolioProject..Nashville
