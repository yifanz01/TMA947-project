using JuMP
import Ipopt

# Import data from the data file
include("project_data.jl")

# Create the model object
the_model = Model(Ipopt.Optimizer)

# Create (one set of) variables, and their lower and upper bounds
@variable(the_model, lb[i] <= x[i = 1:n_vars] <= ub[i])
@variable(the_model, theta_lb <= theta[i = 1:n_nodes] <= theta_ub)
@variable(the_model, voltage_lb <= v[i = 1:n_nodes] <= voltage_ub)
@variable(the_model, -0.003 * capacity[i] <= y[i = 1:n_vars] <= 0.003 * capacity[i])
@variable(the_model, p[k = 1:n_nodes, l = 1:n_nodes])
@variable(the_model, q[k = 1:n_nodes, l = 1:n_nodes])


for k in 1:n_nodes
    for l in 1:n_nodes
        if adj_matrix[k, l] == 1
            unregister(the_model, :epr)
            unregister(the_model, :epr2)
            @NLexpression(the_model, epr, v[k]^2 * g[k, l] - v[k]*v[l]*g[k, l]*cos(theta[k] - theta[l]) - v[k]*v[l]*b[k, l]*sin(theta[k] - theta[l]))
            @NLexpression(the_model, epr2, -1*v[k]^2 * b[k, l] + v[k]*v[l]*b[k, l]*cos(theta[k] - theta[l]) - v[k]*v[l]*g[k, l]*sin(theta[k] - theta[l]))
            @NLconstraint(the_model, p[k, l] == epr)
            @NLconstraint(the_model, q[k, l] == epr2)
            # @variable(the_model, q[k, l] == -1*v[k]^2 * b[k, l] + v[k]*v[l]*b[k, l]*cos(theta[k] - theta[l]) - v[k]*v[l]*g[k, l]*sin(theta[k] - theta[l]))
            # @NLexpression(the_model, p[k, l], v[k]^2 * g[k, l] - v[k]*v[l]*g[k, l]*cos(theta[k] - theta[l]) - v[k]*v[l]*b[k, l]*sin(theta[k] - theta[l]))
            # @NLexpression(the_model, q[k, l], -1*v[k]^2 * b[k, l] + v[k]*v[l]*b[k, l]*cos(theta[k] - theta[l]) - v[k]*v[l]*g[k, l]*sin(theta[k] - theta[l]))
            # p[k, l] = v[k]^2 * g[k, l] - v[k]*v[l]*g[k, l]*cos(theta[k] - theta[l]) - v[k]*v[l]*b[k, l]*sin(theta[k] - theta[l])
            
        end
    end
end

# Create the nonlinear objective \sum_i (x_i - 1)^2, which we want to minimize
# @NLobjective(the_model, Min, sum((x[i] - 1)^2 for i in 1:n_vars))
@objective(the_model, Min, sum(cost[i] * x[i] for i in 1:n_vars))

# Active power constraints
for k in 1:n_nodes
    neighbors = [l for l in 1:n_nodes if adj_matrix[k, l] == 1]
    generators = [n for n in 1:n_vars if gl[n] == k]
    consumers = [m for m in 1:n_consumers if cl[m] == k]
    @NLconstraint(the_model, sum(x[n] for n in generators) == sum(p[k, l] for l in neighbors) + sum(consumer[m] for m in consumers))
end

# Reactive power constraints
for k in 1:n_nodes
    neighbors = [l for l in 1:n_nodes if adj_matrix[k, l] == 1]
    generators = [n for n in 1:n_vars if gl[n] == k]
    # generators = [n for n in 1:n_vars if (gl[n] == k) || any(gl[n] == neighbor for neighbor in neighbors)]
    @NLconstraint(the_model, 0 == sum(q[k, l] for l in neighbors) + sum(y[n] for n in generators))
end


# Print the optimzation problem in the terminal
println(the_model)

# Solve the optimization problem
optimize!(the_model)

# Printing some of the results for further analysis
println("") # Printing white line after solver output, before printing
println("Termination statue: ", JuMP.termination_status(the_model))
println("Optimal(?) objective function value: ", JuMP.objective_value(the_model))
println("Optimal(?) point: ", JuMP.value.(x))
println("Optimal(?) theta: ", JuMP.value.(theta))
println("Optimal(?) voltage: ", JuMP.value.(v))
println("Optimal(?) reactive power: ", JuMP.value.(y))
println("Optimal p:")
for k in 1:n_nodes
    for l in 1:n_nodes
        if adj_matrix[k, l] == 1
            println("p[", k, ",", l, "] = ", JuMP.value(p[k, l]))
        end
    end
end

println("Optimal q:")
for k in 1:n_nodes
    for l in 1:n_nodes
        if adj_matrix[k, l] == 1
            println("q[", k, ",", l, "] = ", JuMP.value(q[k, l]))
        end
    end
end
# println("Dual variables/Lagrange multipliers corresponding to some of the constraints: ")
# println(JuMP.dual.(SOS_constr))
# println(JuMP.dual.(JuMP.UpperBoundRef.(x)))
