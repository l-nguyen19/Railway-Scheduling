# Railway-Scheduling
The project uses [Answer Set Programming (ASP)](https://potassco.org) to plan train schedules in the [Flatland](https://flatland.aicrowd.com/intro.html) simulation while accounting for [malfunctions](https://flatland-association.github.io/flatland-book/environment/environment/stochasticity.html). Malfunctions simulate delays by stopping trains at random times for random durations. During a malfunction, a train is unable to move for a random but known number of time steps, potentially blocking trains behind it. The solver takes these delays into account when generating a valid and convenient train schedule.
The implementation is based on the [krr-up/flatland](https://github.com/krr-up/flatland) toolkit, which connects Python with ASP. It processes Flatland environments, translates them into logical facts, and visualizes the ASP-generated results as an animated simulation.

## Encodings

### Single-shot encoding
- `rs_singleshot.lp` — defines train movements, track connections, and constraints for generating a valid schedule within a given horizon

This is the simplest encoding approach, it contains the rules and logic to solve a problem instance (environment) in a single iteration without considering malfunctions. The `HORIZON` defines the maximum number of time steps considered by the solver when generating the train schedule.

```
clingo rs_singleshot.lp ENVIROMENT.lp -c k=HORIZON
```

<br>

### Multi-shot encoding
- `rs_multishot.lp` — incrementally generates train schedules by adding one timestep at a time, defines train movements, track connections, and constraints
- `rs_multishot.py` — controls the incremental solving process by automatically increasing the horizon and re-solving until a solution is found

This approach solves the problem incrementally without requiring the `HORIZON` to be specified manually, unlike the single-shot approach. The Python script handles the automatic incrementing of the horizon. The solver starts with the smallest horizon and attempts to find a solution. If no solution is found, the horizon is incrementally increased until a valid train schedule is found. This allows the code to automatically determine the minimum horizon required to find a solution.

```
python rs_multishot.py rs_multishot.lp ENVIROMENT.lp
```

<br>

### Multi-shot encoding with delay and TPG
- `rs_multishot_initplan.lp` — incrementally generates train schedules by adding one timestep at a time, defines train movements, track connections, and constraints
- `rs_multishot_initplan.py` — controls the incremental solving process by automatically increasing the horizon and re-solving until a solution is found and saves the resulting ASP model to initplan.lp
- `rs_multishot_execution.lp` — executes the initial plan while modeling delays and their effects on train positions and temporal ordering, while preventing collisions
- `rs_multishot_execution.py` — execute the initial plan and randomly generates malfunctions with random durations, adds the resulting delays to the ASP model, and checks the TPG and goal constraints

This approach accounts for malfunctions and their resulting delays. Instead of adding delays to a completed schedule, the plan is executed step by step, allowing malfunctions to occur during execution and dynamically affect the schedule, similar to a real-world scenario.

To manage the temporal dependencies between trains, we use the idea of the [Temporal Plan Graph TPG](https://ojs.aaai.org/index.php/ICAPS/article/view/13796), a data structure used in Multi-Agent Pathfinding (MAPF). The TPG represents the plan and maintains the temporal dependencies between agents as they move through different locations. Each agent must enter positions in the same order as specified in its original plan. Additionally, if two agents enter the same position, they must maintain the same order as in the original plan.

The implementation is divided into two steps. First, an initial plan is generated for the Flatland problem, similar to the normal multi-shot approach. Second, the initial plan is executed step by step, while malfunctions and their resulting delays are introduced during execution. This allows the schedule to adapt dynamically to the delays that occur.

Step 1 (generate initial plan):
```
python rs_multishot_initplan.py rs_multishot_initplan.lp ENVIROMENT.lp`
```

Step 2 (execute the initial plan and add delays): 
```
python rs_multishot_execution.py rs_multishot_execution.lp initplan.lp ENVIROMENT.lp
```
