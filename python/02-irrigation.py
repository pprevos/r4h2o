########################################
#
# R4H2O 2: IRRIGATION CHANNEL CASE STUDY
#
########################################

# Libraries
import math as m

# Define constants

cd = 0.62
g = 9.81
b = 0.5

# Question 1
# Flow in m3/s when h = 100 mm

h1 = 100 / 1000
q1 = (2 / 3) * cd * m.sqrt(2 * g) * b * h1**(3 / 2)
q1

# Question 2
# h=150mm, h = 136mm, h = 75mm

h2 = [150, 136, 75]
q2 = []
for h in h2:
    q = (2 / 3) * cd * m.sqrt(2 * g) * b * (h / 1000)**(3 / 2)
    q2.append(q)
sum(q2) / len(q2)

# Question 3
# Plot the flow in m3/s for all heights between 50mm and 500mm

h3 = list(range(50, 500))
q3 = []
for h in h3:
    q = (2 / 3) * cd * m.sqrt(2 * g) * b * (h / 1000)**(3 / 2)
    q3.append(q)

import matplotlib.pyplot as plt

plt.clf()
plt.plot(h3, q3, color='blue')
plt.title("Open Channel Flow, Cd = {}".format(cd))
plt.xlabel("Height [m]")
plt.ylabel("Flow [m3/s]")
for i in range(0, 3):
    plt.axvline(x = h2[i], color='grey', linestyle='dotted', linewidth=1)
    plt.axhline(y = q2[i], color='grey', linestyle='dotted', linewidth=1)
plt.scatter(h2, q2, color='red')
plt.show()
