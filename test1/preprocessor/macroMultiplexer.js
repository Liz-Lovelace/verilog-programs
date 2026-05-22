import crypto from 'crypto';
import { parseSimpleInput, allBinaryCombinations } from './macroUtils.js';

export default function multiplexer(input) {
  let { inputWire, inputNotWire, outputWire, inputWidth, type } = parseSimpleInput(input);
  console.log(`multiplexer for width ${inputWidth}`);
  if (type === 'binaryToSingleBit') {
    let code = binaryToSingleBit({inputWire, inputNotWire, outputWire, inputWidth});
    return code;
  }
  throw new Error(`Unknown multiplexer type: ${type}`);
}

function binaryToSingleBit({inputWire, inputNotWire, outputWire, inputWidth}) {
  let code = ``;
  for (let i = 0; i < inputWidth; i++) {
    code += `not(${inputNotWire}[${i}], ${inputWire}[${i}]);\n`;
  }
  let binaryCombinations = allBinaryCombinations(inputWidth);
  for (let i = 0; i < binaryCombinations.length; i++) {
    let bitMatcherCode = matchBusToBits({bus: inputWire, notBus: inputNotWire, correctBits: binaryCombinations[i], outputBit: `${outputWire}[${i}]`});
    code += bitMatcherCode;
  }
  return code;
}

function matchBusToBits({bus, notBus, correctBits, outputBit}) {
  let uuid = Buffer.from(crypto.randomUUID()).toString('base64');
  let code = ``;
  let prevInput = correctBits[0] == '0' ? `${notBus}[0]` : `${bus}[0]`;
  for (let i = 1; i < correctBits.length; i++) {
    let correctBit = correctBits[i]
    let nextWire = `w_${uuid}_${i}`;;
    if (i == correctBits.length - 1) {
      nextWire = outputBit;
    }
    let currentInput;
    if (correctBit == '0') {
      currentInput = `${notBus}[${i}]`;
    } else {
      currentInput = `${bus}[${i}]`
    }
    if (i != correctBits.length - 1) {
      code += `wire ${nextWire};\n`
    }
    code += `and(${nextWire}, ${prevInput}, ${currentInput});\n`;
    prevInput = nextWire;
  }
  return code + '\n';
}