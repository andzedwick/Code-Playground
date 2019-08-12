#____________________________________________________________________________________________________________________________________________________________________________
#
# The Levenshtein Algorithm - Determines the least number of changes required to change a given string into another given string
#
# Warning, while this program should be able to calculate the distance between any two strings, if the strings are too long, then the graph will not display in a
# readable manner.
#
# Programmed by Andrew C. Zedwick
# 8/8/2019
#
#____________________________________________________________________________________________________________________________________________________________________________

Param(
    [Parameter(Position=0, Mandatory=$true)]
    [String]
    $string1 = $(throw "String1 parameter is required."),

    [Parameter(Position=1, Mandatory=$true)]
    [String]
    $string2 = $(throw "String2 parameter is required.")
)


# Get the strings from the user and convert them to lower-case
$string1 = $string1.ToLower()
$string2 = $string2.ToLower()
$xArrayLength = $string1.Length + 1
$yArrayLength = $string2.Length + 1

# Array to hold the calculated distances/changes to get from one word to another. The bottom right value (last value calculated) will be the end result of the algorithm.
# This is a 1d array (not 2d) so i perform some math on it to treat it as a 2d array.
$distanceArray = New-Object 'int[]' ($xArrayLength * $yArrayLength)


#____________________________________________________________________________________________________________________________________________________________________________
#
# The following two for-loops begin to fill in the $distanceArray. After execution, the formatted array will look like the following (with extra 0's removed):
# 
#       W O R D 1
#    ___________
#   | 0 1 2 3 4 5
# W | 1
# O | 2
# R | 3
# D | 4
# 2 | 5
#
#____________________________________________________________________________________________________________________________________________________________________________

# Fills in X axis
for($i = 0; $i -lt $xArrayLength; $i++){
    $distanceArray[$i] = $i
}

# Fills in Y axis (don't start at 0 because array position 0 is already filled in from the X axis)
for($i = 1; $i -lt $yArrayLength; $i++) {
    $distanceArray[$i * $xArrayLength] = $i
}


#____________________________________________________________________________________________________________________________________________________________________________
#
# Perform the Levenshtein Distance algorithm on each value in the array. (taking the minimum cost for deleting, inserting, or substituting... or doing nothing)
#
#____________________________________________________________________________________________________________________________________________________________________________

for($y = 1; $y -lt $yArrayLength; $y++) {
    for($x = 1; $x -lt $xArrayLength; $x++) {
        if($string1[$x-1] -ne $string2[$y-1]) {

            # Note, when both characters being checked are the same, it is the same as taking the levenshtein distance with both those characters deleted
            # out of the word (because it adds no distance cost) This substitution is shifting left and up in the table.

            # shift left cost (delete character)
            [Int]$delete     = $distanceArray[($y * $xArrayLength) + $x - 1][0]
            # shift up cost (insert character)
            [Int]$insert     = $distanceArray[(($y - 1) * $xArrayLength) + $x][0]
            # shift left and up cost (substitute/replace character)
            [Int]$substitute = $distanceArray[(($y - 1) * $xArrayLength) + $x - 1][0]

            # Get the minimum of $delete, $insert, and $substitute
            $minimum = $substitute
            if($delete -lt $minimum) {
                if($insert -lt $delete) {
                    $minimum = $insert
                } else {
                    $minimum = $delete
                }
            } elseif($insert -lt $minimum) {
                if ($delete -lt $insert) {
                    $minimum = $delete
                } else {
                    $minimum = $insert
                }
            }

            # Set the value to the minimum of $delete, $insert, and $substitute           
            $distanceArray[($y * $xArrayLength) + $x] = ($minimum + 1)
        } else {
            $distanceArray[($y * $xArrayLength) + $x] = $distanceArray[(($y - 1) * $xArrayLength) + $x - 1][0]
        }
    }
}


#____________________________________________________________________________________________________________________________________________________________________________
#
# Print the Array and result:
#
#____________________________________________________________________________________________________________________________________________________________________________

"`n`n"

Write-Host -NoNewline "`t|`t`t"
for($x = 0; $x -lt $string1.Length; $x++) {
    Write-Host -NoNewline $string1[$x] "`t"
}
""
for($x = 0; $x -lt ($string1.Length * 5) + 10; $x++) {
    Write-Host -NoNewline "__"
}
""
Write-Host -NoNewline "`t|`t"
for($y = 0; $y -lt $yArrayLength; $y++) {
    for($x = 0; $x -lt $xArrayLength; $x++) {
        Write-Host -NoNewline $distanceArray[$y * $xArrayLength + $x] "`t"
    }
    ""
    Write-Host -NoNewline $string2[$y] "`t|`t"
}
"`n`n"
"The Minimum Distance between the string `"$($string1)`" and the string `"$($string2)`" is $($distanceArray[-1])"
"`n`n"