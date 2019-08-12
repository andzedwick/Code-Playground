#____________________________________________________________________________________________________________________________________________________________________________
#
# The Levenshtein Algorithm - Determines the least number of replacements required to change a given string into another given string
#
# Warning, while this program should be able to calculate the distance between any two strings, if the strings are too long, then the graph will not display in a
# readable manner.
#
# Programmed by Andrew C. Zedwick
# 8/8/2019
#
#____________________________________________________________________________________________________________________________________________________________________________

# Loop to allow the user to re-run the program.
do { 

    # Get the strings from the user and convert them to lower-case
    $word1 = Read-Host "Enter your first word"
    $word2 = Read-Host "Enter your second word"
    $word1 = $word1.ToLower()
    $word2 = $word2.ToLower()
    $xArrayLength = $word1.Length + 1
    $yArrayLength = $word2.Length + 1

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

    # Fills in Y axis (don't start at 0 because 0,0 is already filled in)
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
            if($word1[$x-1] -ne $word2[$y-1]) {

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
    for($x = 0; $x -lt $word1.Length; $x++) {
        Write-Host -NoNewline $word1[$x] "`t"
    }
    ""
    for($x = 0; $x -lt ($word1.Length * 5) + 10; $x++) {
        Write-Host -NoNewline "__"
    }
    ""
    Write-Host -NoNewline "`t|`t"
    for($y = 0; $y -lt $yArrayLength; $y++) {
        for($x = 0; $x -lt $xArrayLength; $x++) {
            Write-Host -NoNewline $distanceArray[$y * $xArrayLength + $x] "`t"
        }
        ""
        Write-Host -NoNewline $word2[$y] "`t|`t"
    }
    "`n`n"
    "The Minimum Distance between the string `"$($word1)`" and the string `"$($word2)`" is $($distanceArray[-1])"
    "`n`n"

} while ((Read-Host "Hit 'R' to re-run the program, or any other key to exit").ToLower() -eq 'r')