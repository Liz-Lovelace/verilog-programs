echo "preprocessing..."
node preprocessor/preprocess.js apply-macros

echo "compiling..."
iverilog -o test fallthrough_microinstructions.v microinstruction_counter.v persistence.v ram.v multiplexers.v test.v

echo "clearing preprocessed code..."
node preprocessor/preprocess.js clear

echo "running simulation..."
vvp test

sleep 0.1
