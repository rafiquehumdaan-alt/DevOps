#!/bin/bash

echo "Enter first number:"
read NUM1

echo "Enter second number:"
read NUM2

SUM=$((NUM1 + NUM2))
DIFFERENCE=$((NUM1 - NUM2))
PRODUCT=$((NUM1 * NUM2))

echo
echo "Results:"
echo "$NUM1 + $NUM2 = $SUM"
echo "$NUM1 - $NUM2 = $DIFFERENCE"
echo "$NUM1 × $NUM2 = $PRODUCT"

if [ "$NUM2" -eq 0 ]; then
    echo "Cannot divide by zero."
else
    DIVISION=$((NUM1 / NUM2))
    echo "$NUM1 ÷ $NUM2 = $DIVISION"
fi