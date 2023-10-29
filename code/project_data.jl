# Small data file to show how one can import julia files into other julia files.
# It, e.g., gives a convenient way to create files containing all the data for a problem.

n_vars = 9 # Number of variables
n_consumers = 7
n_nodes = 11 # Number of nodes
lb = [0, 0, 0, 0, 0, 0, 0, 0, 0] # Lower bounds for the varaibles
ub = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05] # Upper bounds for the variable
cost = [175, 100, 150, 150, 300, 350, 400, 300, 200] # Energy production cost
consumer = [0.10, 0.19, 0.11, 0.09, 0.21, 0.05, 0.04] # Demand active power
gl = [2, 2, 2, 3, 4, 5, 7, 9, 9]
cl = [1, 4, 6, 8, 9, 10, 11]
capacity = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05]
theta_lb = -pi
theta_ub = pi
voltage_lb = 0.98
voltage_ub = 1.02
# p = fill(Inf, 11, 11)
# q = fill(Inf, 11, 11)
adj_matrix = zeros(11, 11)
adj_matrix[1, 2] = 1
adj_matrix[1, 11] = 1
adj_matrix[2, 1] = 1
adj_matrix[2, 11] = 1
adj_matrix[2, 3] = 1
adj_matrix[3, 2] = 1
adj_matrix[3, 4] = 1
adj_matrix[3, 9] = 1
adj_matrix[4, 3] = 1
adj_matrix[4, 5] = 1
adj_matrix[5, 4] = 1
adj_matrix[5, 8] = 1
adj_matrix[5, 6] = 1
adj_matrix[6, 5] = 1
adj_matrix[6, 7] = 1
adj_matrix[7, 6] = 1
adj_matrix[7, 8] = 1
adj_matrix[7, 9] = 1
adj_matrix[8, 5] = 1
adj_matrix[8, 7] = 1
adj_matrix[8, 9] = 1
adj_matrix[9, 7] = 1
adj_matrix[9, 8] = 1
adj_matrix[9, 3] = 1
adj_matrix[9, 10] = 1
adj_matrix[10, 9] = 1
adj_matrix[10, 11] = 1
adj_matrix[11, 10] = 1
adj_matrix[11, 2] = 1
adj_matrix[11, 1] = 1

lx = [
    0 0 0;
    0 1 2
]
b = [
    0 -20.1 0 0 0 0 0 0 0 0 -22.3;
    -20.1 0 -16.8 0 0 0 0 0 0 0 -17.2;
    0 -16.8 0 -11.7 0 0 0 0 -19.4 0 0;
    0 0 -11.7 0 -10.8 0 0 0 0 0 0;
    0 0 0 -10.8 0 -12.3 0 -9.2 0 0 0;
    0 0 0 0 -12.3 0 -13.9 0 0 0 0;
    0 0 0 0 0 -13.9 0 -8.7 -11.3 0 0;
    0 0 0 0 -9.2 0 -8.7 0 -14.7 0 0;
    0 0 -19.4 0 0 0 -11.3 -14.7 0 -13.5 0;
    0 0 0 0 0 0 0 0 -13.5 0 -26.7;
    -22.3 -17.2 0 0 0 0 0 0 0 -26.7 0;
]
g = [
    0 4.12 0 0 0 0 0 0 0 0 5.67;
    4.12 0 2.41 0 0 0 0 0 0 0 2.78;
    0 2.41 0 1.98 0 0 0 0 3.23 0 0;
    0 0 1.98 0 1.59 0 0 0 0 0 0;
    0 0 0 1.59 0 1.71 0 1.26 0 0 0;
    0 0 0 0 1.71 0 1.11 0 0 0 0;
    0 0 0 0 0 1.11 0 1.32 2.01 0 0;
    0 0 0 0 1.26 0 1.32 0 2.41 0 0;
    0 0 3.23 0 0 0 2.01 2.41 0 2.14 0;
    0 0 0 0 0 0 0 0 2.14 0 5.06;
    5.67 2.78 0 0 0 0 0 0 0 5.06 0;
]