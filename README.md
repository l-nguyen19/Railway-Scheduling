# Railway-Scheduling

## Encodings
### single-shot encoding
clingo rs_singleshot.lp ENVIROMENT.lp -c k=HORIZON


### multi-shot encoding
python rs_multishot.py rs_multishot.lp ENVIROMENT.lp


### multi-shot encoding with delay and TPG
Step 1: python rs_multishot_initplan.py rs_multishot_initplan.lp ENVIROMENT.lp
Step 2: python rs_multishot_execution.py rs_multishot_execution.lp initplan.lp ENVIROMENT.lp
