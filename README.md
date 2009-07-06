# Enhanced Table Mingle macro

A clone of the existing Mingle table macro, that has been extended to allow renaming of outputted columns and new columns to be calculated as a product of one or more existing columns.

Once installed the enhanced table macro can be used like follows:

    {{
      enhanced_table
        query: SELECT Name, 'Start Date', 'Total Planning Estimate', 'Total Task Size', 'Avg Story TTL'  WHERE Type = 'Release'
        rename: 'Total Planning Estimate' as 'P Estimate', Name as 'Story Name'
        calculate: 'P Estimate' * 2 + 5 AS 'New Column 1', 'Total Task Size' + 'P Estimate'
    }}

* The 'rename' and 'calculate' parameters are both optional.
* Either single or double quotes can be used for column names, although the macro can handle whitespace in column names without them.
* If you are renaming a column from the MQL query and want to use it in a calculated column expression, you must use it's new name, not the original.
* If you do an ORDER BY in your MQL query on a column that you rename, you must use the original column name in the ORDER BY clause.
* The AS keyword is case insensitive, but column names are not.
* When a column is used in a calculated column expression, all of its row's values should be numeric. A null value returned by MQL is treated as zero for the sake of all calculated values.

# Column colouring options

Columns that are Managed Text types or Managed Number types can have their text or backgrounds coloured based on their defined reporting colour.  (See Project Admin -> Card Properties)  There are two parameters that can be used to colour a table.
* The first parameter is 'table-color-option' -> this parameter will define default colouring option for table
  The options for this parameter are : 'off', 'text' and 'background'.  This parameter is optional, and by default is set to 'off'
  e.g.
     {{
       enhanced_table
         query: SELECT 'Total Planning Estimate', 'Priority' WHERE Type = 'Defect'
         table-color-option: background
     }}

* The second parameter is 'column-color-options' -> this parameter specified color-option for different column in a table based on column name.  This option will override the default color option set by 'table-color-option' parameter. Options for this parameter is the same as 'table-color-option'.  This parameter is optional and by default is set to 'off'.
  e.g.

    {{
      enhanced_table
        query: SELECT 'Total Planning Estimate', 'Priority' WHERE Type = 'Defect'
        table-color-option: background
        column-color-options:
            Total Planning Estimate: background
            Priority: text
    }}
  
 



