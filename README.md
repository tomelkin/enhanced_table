# Enhanced Mingle table macro

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
* The AS keyword is case insensitive, but column names are not.
* When a column is used in a calculated column expression, all of its row's values should be numeric. A null value returned by MQL is treated as zero for the sake of all calculated values.
