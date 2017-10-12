# Exercise 4

## 1: Write a comment above each line explaining to yourself
##    what it does in English.

cars = 100 # assign 100 to variable "cars", and the same for the folloing lines
space_in_a_car = 4.0
drivers = 30
passengers = 90
cars_not_driven = cars - drivers
cars_driven = drivers
carpool_capacity = cars_driven * space_in_a_car # multiply these two variables
average_passengers_per_car = passengers / cars_driven # divide passengers by cars_driven


print("There are", cars, "cars available.")
print("There are only", drivers, "drivers available.")
print("There will be", cars_not_driven, "empty cars today.")
print("We can transport", carpool_capacity, "people today.")
print("We have", passengers, "to carpool today.")
print("We need to put about", average_passengers_per_car, "in each car.")

## 2: Read your .py file backward.

## 3: Read your .py file out loud, saying even the characters.


# Study Drills

## 1: I used 4.0 for space_in_a_car, but is that necessary? What happens if it's just 4?

# If we are sure that space_in_a_car can only be integer, then it is better to use 4 instead
# of 4.0. If we are not sure whether it can be floating number or not, we should use 4.0.
# When it is just 4, actually they are the same.

if(4.0 == 4):
    print("4.0==4")
else:
    print("4.0!=4")


## 2: Remember that 4.0 is a floating point number. It's just a number with a decimal
##    point, and you need 4.0 instead of just 4 so that it is floating point.

## 3: Write comments above each of the variable assignments.

# Done.

## 4: Make sure you know what = is called (equals) and that its purpose is to give
##    data (numbers, strings, etc.) names (cars_driven, passengers).

# "=" is used to assgin values.

## 5: Remember that _ is an underscore character.

## 6: Try running python3.6 from the Terminal as a calculator like you did before,
##    and use variable names to do your calculations. Popular variable names are
##    also i, x, and j.

x = 3
y = 5

print("x =",x)
print("y =",y)
print("x + y =",x+y)
