# Railway-Scheduling
The project uses [Answer Set Programming (ASP)](https://potassco.org) to plan train schedules in the [Flatland](https://flatland.aicrowd.com/intro.html) simulation while accounting for [malfunctions](https://flatland-association.github.io/flatland-book/environment/environment/stochasticity.html). Malfunctions simulate delays by stopping trains at random times for random durations. During a malfunction, a train is unable to move for a random but known number of time steps, potentially blocking trains behind it. The solver takes these delays into account when generating a valid and convenient train schedule.
The implementation is based on the [krr-up/flatland](https://github.com/krr-up/flatland) toolkit, which connects Python with ASP. It processes Flatland environments, translates them into logical facts, and visualizes the ASP-generated results as an animated simulation.

## Encodings

- `rs_singleshot.lp` — builds the track graph from environment facts
- `rs_multishot_initplan.lp` — route choice and action output
- `rs_multishot_execution.lp` — auto-extracted waypoints per train
- `rs_multishot.lp` — stations, required visits, visit order
- `rs_multishot.py` — passenger itineraries and transfer validation
- `rs_multishot_execution.py` — the cost layer: each convenience criterion is computed per train, multiplied by its profile weight, and minimized
- `rs_multishot_initplan.py` — the cost layer: each convenience criterion is computed per train, multiplied by its profile weight, and minimized


### Single-shot encoding
This is the simplest encoding approach, as `rs_singleshot.lp` contains the rules and logic to solve a problem instance (environment) in a single iteration without considering delays. The **HORIZON** defines the maximum number of time steps considered by the solver when generating the train schedule.

`clingo rs_singleshot.lp ENVIROMENT.lp -c k=HORIZON`


### Multi-shot encoding
`python rs_multishot.py rs_multishot.lp ENVIROMENT.lp`


### Multi-shot encoding with delay and TPG
[Temporal Plan Graph](https://ojs.aaai.org/index.php/ICAPS/article/view/13796)

Step 1: `python rs_multishot_initplan.py rs_multishot_initplan.lp ENVIROMENT.lp`

Step 2: `python rs_multishot_execution.py rs_multishot_execution.lp initplan.lp ENVIROMENT.lp`
