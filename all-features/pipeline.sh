# Run from this directory

SERVERS=../../construct/integrate/neo4j/servers.py
python $SERVERS --write servers.json
python $SERVERS --start-all

jupyter nbconvert --execute metapaths.ipynb --inplace --ExecutePreprocessor.timeout=-1
jupyter nbconvert --execute partition.ipynb --inplace --ExecutePreprocessor.timeout=-1
jupyter nbconvert --execute extract.ipynb --inplace --ExecutePreprocessor.timeout=-1
jupyter nbconvert --execute performance.ipynb --inplace --ExecutePreprocessor.timeout=-1
jupyter nbconvert --execute pyvisualize.ipynb --inplace --ExecutePreprocessor.timeout=-1
