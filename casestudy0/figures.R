# Figure 3.2

png("manuscript/resources/03_basics/basic_plots.png", width = 800, height = 400)
par(mfrow = c(1, 2))

x <- -10:10
y <- -x^2 -2 * x + 30
plot(x, y, type = "l", col = "blue", main = "Parabola")
abline(h = 0, col = "grey")
abline(v = 0, col = "grey")

complaints <- c(12, 3, 23, 45, 2, 99, 1)
barplot(complaints, main = "Complaints", names.arg = 1:7)
dev.off()
