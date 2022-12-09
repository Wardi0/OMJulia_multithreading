tstart = time()
using OMJulia
using Fresa

println("Loaded packages at t="*string(time()-tstart)*"s\n")
println("Number of threads: "*string(Threads.nthreads()))

# Set up OM session(s) and load model
cd(@__DIR__)
sessions = []
for thread in 1:Threads.nthreads()
    push!(sessions, OMJulia.OMCSession())
    sessions[thread].ModelicaSystem("ThermodynamicDesign/package.mo","ThermodynamicDesign.Tests.RegenerationCycle")
end

println("Loaded Modelica model at t="*string(time()-tstart)*"s\n")

# Define the valid domain of the decision variables [main pressure, extraction pressure, extraction_fraction]
upper = x -> [250e5,100e5,0.9]
lower = x -> [100e5,10e5,0.0]
domain = Fresa.Domain(lower,upper)

# Objective function (minimise deviation integral)
# function controller_error(x, sessions :: Vector{OMJulia.OMCSession})
function neg_efficiency(x, sessions)
    thread_id = Threads.threadid() 
    model = sessions[thread_id]
    # Default values are poor in case of simulation failiure
    eff = 0
    feasibility = 1e6
    # Try to evaluate the design point up to 5 times while catching errors
    for i in 1:5
        try     
            if x[2] <= x[1]          # Main pressure > Extraction pressure 
                model.setParameters(["main_steam_state.p_set=$(x[1])", "reheat_steam_state.p_set=$(x[2])", "splitter.split_fraction=$(1-x[3])"]) # Set design parameters
                model.simulate() 
                feasibility = 0.0 # Assume solution is feasible
                eff = model.getSolutions("eta_energ")[1][1]
                if model.getSolutions("pump.X_in")[1][1] > 0.0          # Pump inlet fluid must be fully liquid
                    feasibility = 1e4 * model.getSolutions("pump.X_in")[1][1] + 1
                elseif model.getSolutions("LPT.X_out")[1][1] < 0.9      # Turbine outlet cannot exceed 10mass% condensation
                    feasibility = 1e2 * (0.9-model.getSolutions("LPT.X_out")[1][1]) + 1
                end  
            else
                # Non-physical design with lowest feasibility - don't simulate
                eff = -Inf
                feasibility = 1e8 * (x[2] - x[1]) + 1
            end
            break
        catch TaskFailedException
            println("Caught TaskFailedException on thread $thread_id")
        end
    end
    println("Simulation on thread $thread_id: x=$x\nObjective=$(-eff) | Feasibility=$feasibility")
    return (-eff, feasibility)
end

p0 = [Fresa.createpoint([160e5,60e5,0.5], neg_efficiency, sessions)] # Initial point 

best, pop = Fresa.solve(neg_efficiency, p0, domain; parameters=sessions, multithreading = true, ngen = 20, tolerance = 0.0) # Run Fresa optimiser


