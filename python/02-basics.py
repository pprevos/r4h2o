#################################
#
# R4H2O 2: INTRODUCTION TO PYTHON
#
#################################

# Math library
import math as m

# Assigning variables

diameter = 150
diameter

(m.pi / 4) * (diameter / 1000)**2

# BODMAS

3 - 3 * 6 + 2

7 + 7 / 7 + 7 * 7 - 7

# Array Variables

complaints = [12, 7, 23, 45, 9, 33, 12]
day = list(range(1, 100))

# Arithmetic functions

non_revenue_water = [13, -9, 45, 0]

sum(non_revenue_water)

m.prod(non_revenue_water)

# Most arithmetic functions only work with one value
factorials = []

for x in non_revenue_water:
    if x >= 0:
        factorial = m.factorial(x)
        factorials.append(factorial)
print(factorials)

m.exp(non_revenue_water[0])

m.log(non_revenue_water[0])

m.sqrt(non_revenue_water[0])

# Absolute values
m.sqrt(abs(non_revenue_water[1]))

# Complex numbers
import cmath

cmath.sqrt(non_revenue_water[1])

# Basic visualisation
import matplotlib.pyplot as plt

diameters = list(range(50, 350))
pipe_areas = []
for d in diameters:
    a = (m.pi / 4) * (d / 1000)**2
    pipe_areas.append(a)

plt.clf()
plt.plot(diameters, pipe_areas, color='blue')
plt.title("Pipe Section Area")
plt.xlabel("Diameter")
plt.ylabel("Pipe Area")
# Adding horizontal and vertical lines
plt.axvline(x = 150, color='grey', linestyle='-')
a = (m.pi / 4) * 0.15**2
plt.axhline(y = a, color='grey', linestyle='-')
plt.scatter(150, a, color='red')
plt.show()    
