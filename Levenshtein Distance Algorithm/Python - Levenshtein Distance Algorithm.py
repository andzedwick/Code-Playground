# Python Levenshtein Distance Algorithm
# Programmed by Andrew C. Zedwick
# 8/8/2019

# Test strings (longer) and their results:
# String1: jehwieiidiisiileqkl
# String2: aosidoamdskieklwke
# Outcome: should be 16

# Get two strings from the user
string1 = input("Enter your first string:  ").lower()
string2 = input("Enter your second string: ").lower()
xLength = len(string1) + 1
yLength = len(string2) + 1

# Create an array to hold the distances in the algorithm
distanceArray = [[0] * yLength for i in range(xLength)]

# Fill in the initial x and y values in the distance array
for x in range(xLength):
  distanceArray[x][0] = x
for y in range(yLength):
  distanceArray[0][y] = y

# Perform the algorithm on the rest of the values in the distanceArray
for y in range(1,yLength):
  for x in range(1,xLength):
    if (string1[x-1] != string2[y-1]):
      delete = distanceArray[x-1][y]
      insert = distanceArray[x][y-1]
      replace = distanceArray[x-1][y-1]

      distanceArray[x][y] = min(delete, insert, replace) + 1
    else:
      distanceArray[x][y] = distanceArray[x-1][y-1]

# Print the final graph
print("\n\n")
tempString = "     \t"
for c in string1:
  tempString += c + "\t"
print(tempString)

tempString = "________"
for c in string1:
  tempString += "_____"
print(tempString)

for y in range(yLength):
  if (y > 0):
    tempString = string2[y - 1] + " | "
  else:
    tempString = "  | "
  for x in range(xLength):
    tempString += str(distanceArray[x][y]) + "\t"
  print(tempString)

# Print the distance/answer
print("\n\nThe distance between \"" + string1 + "\" and \"" + string2 + "\" is: " + str(distanceArray[xLength - 1][yLength - 1]))