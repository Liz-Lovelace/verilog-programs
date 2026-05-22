import { promises as fs } from 'fs';
import * as macros from './macros.js';

const helpText = `To use the preprocessor:

$ node preprocess.js clear           remove all generated code

$ node preprocess.js apply-macros    run macros and write them to source code
                                     (no need to clear the files before running this)`;

main()
async function main() {
    const args = parseCliArguments();
    console.time('preprocess end');
    
    if (args.baseInstruction === 'clear') {
        const sourceFiles = await getSourceFiles();
        await removeGeneratedCode(sourceFiles);
    } else if (args.baseInstruction === 'apply-macros') {
        let sourceFiles = await getSourceFiles();
        await removeGeneratedCode(sourceFiles);
        sourceFiles = await getSourceFiles();
        await preprocessFiles(sourceFiles);
    }

    console.timeEnd('preprocess end');
}

function parseCliArguments() {
    const args = process.argv.slice(2);
    
    if (args.length === 0) {
        console.log(helpText);
        process.exit(0);
    }

    const command = args[0];
    
    if (command === 'clear') {
        return { baseInstruction: 'clear' };
    } else if (command === 'apply-macros') {
        return { baseInstruction: 'apply-macros' };
    } else {
        console.log('Invalid command.\n');
        console.log(helpText);
        process.exit(1);
    }
}

async function removeGeneratedCode(sourceFiles) {
    sourceFiles = JSON.parse(JSON.stringify(sourceFiles));
    for (const file of sourceFiles) {
        file.newContents = removeGeneratedCodeFromContents(file.oldContents);
    }
    await writeSourceFiles(sourceFiles);
}

function removeGeneratedCodeFromContents(contents) {
    const lines = contents.split('\n');
    const newLines = [];
    let insideGeneratedBlock = false;
    
    for (const line of lines) {
        if (line.includes('//START GENERATED CODE')) {
            if (insideGeneratedBlock) {
                throw new Error('Found nested START marker while already inside a generated block');
            }
            insideGeneratedBlock = true;
            continue;
        }
        
        if (line.includes('//END GENERATED CODE')) {
            if (!insideGeneratedBlock) {
                throw new Error('Found END marker without a matching START marker');
            }
            insideGeneratedBlock = false;
            continue;
        }
        
        if (!insideGeneratedBlock) {
            newLines.push(line);
        }
    }
    
    if (insideGeneratedBlock) {
        throw new Error('Found START marker with no matching END marker');
    }
    
    return newLines.join('\n');
}

async function getSourceFiles() {
    const files = await fs.readdir(process.cwd());
    const verilogFiles = files.filter(file => file.endsWith('.v'));
    
    const fileTree = await Promise.all(verilogFiles.map(async filename => {
        const absoluteFilepath = `${process.cwd()}/${filename}`;
        const oldContents = await fs.readFile(absoluteFilepath, 'utf8');
        
        return {
            filename,
            absoluteFilepath,
            oldContents,
        };
    }));

    return fileTree;
}

async function preprocessFiles(sourceFiles) {
    sourceFiles = JSON.parse(JSON.stringify(sourceFiles));
    for (const file of sourceFiles) {
        let newContents = await preprocessFile(file);
        file.newContents = newContents;
    }
    await writeSourceFiles(sourceFiles);
}

async function writeSourceFiles(sourceFiles) {
    for (const file of sourceFiles) {
        if (file.newContents) {
            await fs.writeFile(file.absoluteFilepath, file.newContents, 'utf8');
        }
    }
}

async function preprocessFile(file) {
    const macrosInfo = findMacros(file.oldContents);
    if (macrosInfo.length === 0) {
        return;
    }

    let newContents = file.oldContents;
    let offset = 0;  // Track how much we've shifted the indices

    for (let i_macroInfo = 0; i_macroInfo < macrosInfo.length; i_macroInfo++) {
        let macroInfo = macrosInfo[i_macroInfo];
        let generatedCode = macros[macroInfo.macroName](macroInfo.macroContents);
        console.log(`${macroInfo.macroName}: ${generatedCode.length} bytes / ${Math.round(generatedCode.length / 1024 * 100) / 100} KiB / ${Math.round(generatedCode.length / 1024 / 1024 * 100) / 100} MiB`);
        generatedCode = `\n//START GENERATED CODE (edit this in the preprocessor)\n${generatedCode}\n//END GENERATED CODE`;
        
        const insertPosition = macroInfo.endIndex + offset;
        newContents = newContents.slice(0, insertPosition) + generatedCode + newContents.slice(insertPosition);
        offset += generatedCode.length;
    }
    return newContents;
}

function findMacros(contents) {
    const macros = [];
    const lines = contents.split('\n');
    let currentPosition = 0;
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        const macroMatch = line.match(/^(\s*?)\/\*\s*MACRO\s+(\S+)\s*$/);
        
        if (macroMatch) {
            const leadingSpaces = macroMatch[1];
            const macroName = macroMatch[2];
            const startIndex = currentPosition;
            let macroEndPosition = currentPosition;
            
            // Find the end of the macro
            let macroContents = [];
            let j = i + 1;
            let endIndex;
            let foundEnd = false;
            let closingLine = null;
            
            // Move past the opening line
            macroEndPosition += line.length + 1;
            
            while (j < lines.length) {
                const currentLine = lines[j];
                if (currentLine.trim() === '*/') {
                    endIndex = macroEndPosition + currentLine.length;
                    foundEnd = true;
                    closingLine = currentLine;
                    break;
                }
                if (currentLine.includes('*/')) {
                    throw new Error(`Invalid macro format: closing '*/' must be on its own line\nLine: ${currentLine}`);
                }
                if (currentLine.includes('/*')) {
                    throw new Error(`Invalid macro format: nested comment found inside macro\nLine: ${currentLine}`);
                }
                macroContents.push(currentLine);
                macroEndPosition += currentLine.length + 1; // +1 for newline
                j++;
            }
            
            if (!foundEnd) {
                throw new Error(`Invalid macro format: macro starting with '${line.trim()}' never closes`);
            }
            
            // Validate macro name
            if (!/^[a-zA-Z][a-zA-Z0-9_-]*$/.test(macroName)) {
                throw new Error(`Invalid macro name '${macroName}': must start with a letter and contain only letters, numbers, underscores, or hyphens`);
            }
            
            macros.push({
                startIndex,
                endIndex,
                leadingSpaces: leadingSpaces.length,
                macroName,
                macroContents: macroContents.join('\n')
            });
            
            i = j; // Skip the processed lines
            currentPosition = macroEndPosition + (foundEnd ? closingLine.length + 1 : 0);
            continue;
        }
        
        currentPosition += line.length + 1; // +1 for the newline
    }
    
    return macros;
}
