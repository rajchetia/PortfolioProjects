use Nashville_Housing

--cleaning data inn SQL Queries

select *
from NashVille_Housing_Data

--standardized date format

select SaleDateConverted,Convert(Date,SaleDate)
From NashVille_Housing_Data

Alter TABLE Nashville_Housing_Data
ADD SaleDateConverted Date;

update NashVille_Housing_Data
set SaleDateConverted = Convert(DATE,SaleDate)

--Populate Property Address Data

Select *
From NashVille_Housing_Data
--Where PropertyAddress is null
order by ParcelID

SELECT ParcelID, COUNT(*) AS occurrences
FROM NashVille_Housing_Data
GROUP BY ParcelID
HAVING COUNT(*) > 1;

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
ISNULL(a.propertyaddress,b.PropertyAddress)
From NashVille_Housing_Data a
JOIN NashVille_Housing_Data b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

Update a
SET PropertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress)
From NashVille_Housing_Data a
JOIN NashVille_Housing_Data b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

--Breaking Out Address Into Individual Columns (ADDRESS,CITY,STATE)

Select PropertyAddress
From NashVille_Housing_Data


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From NashVille_Housing_Data


 ALTER TABLE Nashville_Housing_Data
 Add PropertySplitAddress Nvarchar(255);

 UPDATE NashVille_Housing_Data
 SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 


 ALTER TABLE Nashville_Housing_Data
 add PropertySplitCity Nvarchar(300);

 UPDATE NashVille_Housing_Data
SET PropertySplitCity = SUBSTRING(PropertyAddress,
CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

SELECT * 
FROM NashVille_Housing_Data


SELECT OwnerAddress
From NashVille_Housing_Data

SELECT 
PARSENAME(REPLACE(Owneraddress,',','.'),3),
PARSENAME(REPLACE(Owneraddress,',','.'),2),
PARSENAME(REPLACE(Owneraddress,',','.'),1)
From  NashVille_Housing_Data

ALTER TABLE Nashville_Housing_Data
Add OwnerSplitAddress Nvarchar(255);
UPDATE NashVille_Housing_Data
SET OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress,',','.'),3) 

ALTER TABLE Nashville_Housing_Data
add OwnerSplitCity Nvarchar(300);
UPDATE NashVille_Housing_Data
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress,',','.'),2)

ALTER TABLE Nashville_Housing_Data
add OwnerSplitState Nvarchar(300);
UPDATE NashVille_Housing_Data
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress,',','.'),1)


select *
from NashVille_Housing_Data

--change Y and N to 'Yes' and 'NO' in "Sold as vacant" field

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from NashVille_Housing_Data
group by SoldAsVacant
order by 2

UPDATE NashVille_Housing_Data
SET SoldAsVacant=CASE 
WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N'THEN 'No'
ELSE SoldAsVacant
end
FROM NashVille_Housing_Data


--Remove Duplicates
WITH RowNumCTE as (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY 
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY 
		UniqueId
	) RowNum
	From NashVille_Housing_Data
)
SELECT * from RowNumCTE
WHERE RowNum >1
order by PropertyAddress

--delete  from RowNumCTE
--WHERE RowNum >1

--DELETING UNUSED COLUMNS
SELECT * FROM NashVille_Housing_Data

ALTER TABLE Nashville_Housing_Data
DROP column OwnerAddress,TaxDistrict,PropertyAddress


ALTER TABLE Nashville_Housing_Data
DROP column SalePrice









