# Railway-Scheduling

## Encodings
### Single-shot encoding
This is the simplest encoding approach, as `rs_singleshot.lp` contains the rules and logic to solve a problem instance (environment) in a single iteration without considering delays. The **HORIZON** defines the maximum number of time steps considered by the solver when generating the train schedule.

`clingo rs_singleshot.lp ENVIROMENT.lp -c k=HORIZON`


### Multi-shot encoding
`python rs_multishot.py rs_multishot.lp ENVIROMENT.lp`


### Multi-shot encoding with delay and TPG
\href{[https://ojs.aaai.org/index.php/ICAPS/article/view/13796](https://ojs.aaai.org/index.php/ICAPS/article/view/13796)}{Temporal Plan Graph}

Step 1: `python rs_multishot_initplan.py rs_multishot_initplan.lp ENVIROMENT.lp`

Step 2: `python rs_multishot_execution.py rs_multishot_execution.lp initplan.lp ENVIROMENT.lp`
