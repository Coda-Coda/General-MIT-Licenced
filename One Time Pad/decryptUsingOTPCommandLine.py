import sys
fileToDecrypt = sys.argv[1]
outputFilename = sys.argv[2]
padFile = sys.argv[3]
padOffset = int(sys.argv[4])
with open(fileToDecrypt, "rb") as f:
    with open(padFile, "rb") as pad:
        with open(outputFilename, "wb") as outputFile:
            for byte, padByte in zip(f.read(), pad.read()[padOffset:]):
                outputFile.write(((byte - padByte) % 256).to_bytes(1, byteorder='big'))
print("Success, generated: " + outputFilename)
