
## 🏡 Nashville Housing Data Cleaning Project (SQL)

### 📋 Objective

To clean and transform raw housing data from Nashville using SQL, preparing it for analysis and visualization by addressing formatting issues, handling missing values, standardizing columns, and removing duplicates.

---

### 🧰 Tools Used

* **SQL Server**
* **SSMS (SQL Server Management Studio)**

---

### 🔧 Cleaning Steps Performed

1. **🗓 Standardized Date Format**

   * Converted `SaleDate` into a new column `SaleDateConverted` using `CONVERT(Date, SaleDate)`.

2. **🏷 Filled Missing Property Addresses**

3. **🏠 Split Full Addresses**

   * Split `PropertyAddress` into:

     * `PropertySplitAddress`
     * `PropertySplitCity`
   * Split `OwnerAddress` into:

     * `OwnerSplitAddress`
     * `OwnerSplitCity`
     * `OwnerSplitState`

4. **✔ Cleaned Boolean Field**

5. **🧹 Removed Duplicates**

6. **🗑 Dropped Unnecessary Columns**

---

### ✅ Final Output

A clean and structured SQL table ready for:

* **Data analysis**
* **Dashboard creation**
* **Business insights**


