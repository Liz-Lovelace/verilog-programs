export function parseSimpleInput(input) {
  let parsedInput = {};
  let lines = input.split('\n').map(line => line.trim()).filter(line => line.length > 0);
  for (let line of lines) {
    let [key, value] = line.split(':').map(s => s.trim());
    if (!key || !value) {
      throw new Error(`Invalid macro format: key-value pair not found in line '${line}'`);
    }
    parsedInput[key] = value;
  }
  return parsedInput;
}

export function allBinaryCombinations(bitLength) {
  let combinations = [];
  for (let i = 0; i < Math.pow(2, bitLength); i++) {
    combinations.push(i.toString(2).padStart(bitLength, '0').split('').reverse().join(''));
  }
  return combinations;
}