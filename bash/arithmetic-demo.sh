#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

read -p "Please enter 3 number:" firstnum secondnum thirdnum

sum=$(($firstnum + $secondnum + $thirdnum))
product=$(($firstnum * $secondnum * $thirdnum))

## save for later, just in case it is needed again
#dividend=$((firstnum / secondnum))
#fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")

cat <<EOF
$firstnum plus $secondnum plus $thirdnum is: $sum
$firstnum multiplied by $secondnum mulitplied by $thirdnum is: $product
EOF

## save for later just in case it is needed again
#$firstnum divided by $secondnum is $dividend
#  - More precisely, it is $fpdividend

